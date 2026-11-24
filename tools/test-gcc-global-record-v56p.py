#!/usr/bin/env python3
"""Run native record/pointer regressions through the dedicated KL10B loader."""
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
    work=Path(tempfile.mkdtemp(prefix='pdp10-global-record-v56p-',dir=tmp))
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
    cases=[('record',ROOT/'tests/codegen/kl10/gcc-global-record-pointer-v56p.c',{'fail_id':0,'result':765}),
           ('switch',ROOT/'tests/semantic/base/base_switch_byteptr_live.c',{'fail_id':0,'got':29,'got1':60,'got2':42,'got3':49})]
    for name,src,oracle in cases:
        for opt in ('O0','O1','O2','Os'):
            case=work/(name+'-'+opt);case.mkdir()
            asm=case/'test.s';obj=case/'test.dobj';image=case/'test.p10x';mp=case/'test.map'
            print('RUN',case,flush=True)
            run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',asm])
            run([tools/'das','-C','-O',obj,asm])
            run([linker,'--extended','1001000','2001000','3001000','-o',image,'-M',mp,startup,obj,libgcc])
            syms={n:int(v,8) for n,v in (l.split() for l in mp.read_text().splitlines())}
            m.execute(image,case,{syms[n]:v for n,v in oracle.items()},syms['done'],steps=100000)
    print('PASS native global record and pointer regressions',work,flush=True)


if __name__=='__main__':main()
