#!/usr/bin/env python3
"""Run typed exact16 pointer regressions through the dedicated KL10B loader."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('extended',ROOT/'tools/test-kl10b-extended-link-v56m.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)


def main():
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-global-exact16-v57e-',dir=tmp))
    prefix=Path(os.environ['PDP10_PREFIX'])/'bin'
    tools=Path(os.environ.get('DOBJ2_TOOLS') or prefix)
    linker=Path(os.environ.get('P10X_LINKER') or prefix/'dlink')
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or prefix/'pdp10-dec-none-gcc')
    def run(cmd):
        p=subprocess.run(list(map(str,cmd)),capture_output=True,text=True,timeout=30)
        if p.returncode:raise AssertionError((cmd,p.stderr,work))
        return p.stdout
    crt=work/'crt.s';crt.write_text('.text\n.entry start\n.globl start,done\n.extern main\nstart:\n move 17,[GIW 4001000]\n pushj 17,@[GIW main]\n movei 6,765\ndone: halt 0\n')
    startup=work/'crt.dobj';run([tools/'das','-C','-O',startup,crt])
    libgcc=run([gcc,'-print-libgcc-file-name']).strip()
    cases=[('exact16',ROOT/'tests/codegen/kl10/gcc-global-exact16-v57e.c',{'fail_id':0,'result':765})]
    for name in ('exact16-pointer-call-1','exact16-word-roundtrip-1',
                 'packed-exact16-global-roundtrip-1','packed-exact16-global-arith-1'):
        cases.append((name,ROOT/'tests/semantic/gcc-historical-v1'/(name+'.c'),{}))
    for name,src,oracle in cases:
        for opt in ('O0','O1','O2','Os'):
            case=work/(name+'-'+opt);case.mkdir()
            asm=case/'test.s';obj=case/'test.dobj';image=case/'test.p10x';mp=case/'test.map'
            print('RUN',case,flush=True)
            run([gcc,'-march=kl10','-mextended','-'+opt,'-I',ROOT/'support/gcc','-I',ROOT/'support/common','-S',src,'-o',asm])
            run([tools/'das','-C','-O',obj,asm])
            run([linker,'--extended','1001000','2001000','3001000','-o',image,'-M',mp,startup,obj,libgcc])
            syms={n:int(v,8) for n,v in (l.split() for l in mp.read_text().splitlines())}
            m.execute(image,case,{syms[n]:v for n,v in oracle.items()},syms['done'],steps=1000000)
    print('PASS typed exact16 global pointers',work,flush=True)


if __name__=='__main__':main()
