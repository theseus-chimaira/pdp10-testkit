#!/usr/bin/env python3
"""Dedicated extended wide/narrow multiplication and packed-field checks."""
import argparse
from concurrent.futures import ThreadPoolExecutor
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('extended',ROOT/'tools/test-kl10b-extended-link-v56m.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)


def local_checks(work, gcc, prefix):
    """Use the installed local p10run path, without adding matrix cells."""
    src=ROOT/'tests/codegen/kl10/gcc-wide-truncation-v56u.c'
    support=ROOT/'support'
    cases=[(cpu,width,opt) for cpu in ('pdp6','ka10','ki10','ks10')
           for width in (71,72) for opt in ('O0','O1','O2','Os')]

    def run_local(case):
        cpu,width,opt=case
        d=work/f'local-{cpu}-{width}-{opt}';d.mkdir()
        asm=d/'test.s';log=d/'test.log'
        with log.open('w') as out:
            subprocess.run([gcc,'-march='+cpu,'-munextended',
                            f'-mlong-long-{width}bit','-'+opt,'-S',src,'-o',asm],
                           stdout=out,stderr=subprocess.STDOUT,timeout=60,check=True)
            subprocess.run([prefix/'p10run','--machine',cpu,'--mode','deposit',
                            '--exec-mode','step','--step-limit','1000000',
                            '--timeout','18','--workdir',d/'run','--name','wide-trunc',
                            '--expect','__test_exit=0','--expect','fail_id=0',
                            '--expect','result=1375',support/'crt0-upstream-v1.s',
                            asm,support/'exit-v1.s',support/'abort-v1.s'],
                           stdout=out,stderr=subprocess.STDOUT,timeout=30,check=True)
        print(f'PASS local {cpu} {width} {opt}: {log}',flush=True)

    with ThreadPoolExecutor(max_workers=4) as pool:
        list(pool.map(run_local,cases))


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    group=ap.add_mutually_exclusive_group()
    group.add_argument('--local-only',action='store_true')
    group.add_argument('--extended-only',action='store_true')
    args=ap.parse_args()
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-global-wide-v56u-',dir=tmp))
    prefix=Path(os.environ['PDP10_PREFIX'])/'bin'
    tools=Path(os.environ.get('DOBJ2_TOOLS') or prefix)
    linker=Path(os.environ.get('P10X_LINKER') or prefix/'dlink')
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or prefix/'pdp10-dec-none-gcc')
    if args.local_only:
        local_checks(work,gcc,prefix)
        return
    def run(cmd):
        p=subprocess.run(list(map(str,cmd)),capture_output=True,text=True,timeout=60)
        if p.returncode:raise AssertionError((cmd,p.stderr,work))
        return p.stdout
    crt=work/'crt.s'
    crt.write_text('.text\n.entry start\n.globl start,done,abort\n.extern main\nstart:\n move 17,[GIW 4001000]\n pushj 17,@[GIW main]\n movei 6,765\ndone: halt 0\nabort: halt 0\n')
    startup=work/'crt.dobj';run([tools/'das','-C','-O',startup,crt])
    libgcc=run([gcc,'-print-libgcc-file-name']).strip()
    cases=[('trunc71','tests/codegen/kl10/gcc-wide-truncation-v56u.c',{'fail_id':0,'result':765},'71'),
           ('trunc72','tests/codegen/kl10/gcc-wide-truncation-v56u.c',{'fail_id':0,'result':765},'72'),
           ('wide','tests/semantic/regression/pdp10-wide-multiply-36bit-v1.c',{'fail_id':0},'71'),
           ('unsigned','tests/semantic/runtime/runtime-pattern-mulsi3-unsigned.c',{'semantic_fail_id':0,'semantic_sink':1},'71'),
           ('signbit','tests/semantic/runtime/runtime-reduce-umulsi3-signbit.c',{'semantic_fail_id':0},'71'),
           ('packed-direct','tests/codegen/kl10/gcc-global-packed-direct-v56t.c',{'fail_id':0,'result':765},'71')]
    for name,src,oracle,width in cases:
        for opt in ('O0','O1','O2','Os'):
            case=work/(name+'-'+opt);case.mkdir()
            asm=case/'test.s';obj=case/'test.dobj';image=case/'test.p10x';mp=case/'test.map'
            print('RUN',case,flush=True)
            run([gcc,'-march=kl10','-mextended','-mlong-long-'+width+'bit','-'+opt,'-I',ROOT/'support/gcc','-I',ROOT/'support/common','-S',ROOT/src,'-o',asm])
            run([tools/'das','-C','-O',obj,asm])
            run([linker,'--extended','1001000','2001000','3001000','-o',image,'-M',mp,startup,obj,libgcc])
            syms={n:int(v,8) for n,v in (l.split() for l in mp.read_text().splitlines())}
            m.execute(image,case,{syms[n]:v for n,v in oracle.items()},syms['done'],steps=100000)
    print('PASS global wide multiplication, truncation and direct packed fields',work,flush=True)
    if not args.extended_only:
        local_checks(work,gcc,prefix)


if __name__=='__main__':main()
