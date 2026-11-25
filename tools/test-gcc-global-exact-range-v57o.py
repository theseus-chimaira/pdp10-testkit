#!/usr/bin/env python3
"""Compiler-generated exact-width arithmetic across 30-bit coordinates."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('oracle', ROOT/'tools/test-gcc-global-exact-model-v56y.py')
oracle = importlib.util.module_from_spec(spec)
spec.loader.exec_module(oracle)
m = oracle.m


def rows():
    # Reuse the independent host bit-coordinate oracle. Add both sides
    # of address bit 29 for signed comparison and section carry checks.
    result = oracle.arithmetic()
    for width in (16, 32):
        for address in ((1<<29)-1, 1<<29):
            for pos in range(36):
                start = 36*address + pos
                for n in (-9,-2,-1,1,2,9):
                    result.append((width,oracle.packed(start),n,
                                   oracle.packed(start+n*width)))
            for slot in range(2 if width==16 else 1):
                start = address*(2 if width==16 else 1)+slot
                for n in (-2,-1,1,2):
                    result.append((width,oracle.native(start,width),n,
                                   oracle.native(start+n,width)))
    return result


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home()/'tmp')
    tmp.mkdir(parents=True,exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='pdp10-exact-range-v57o-',dir=tmp))
    prefix = Path(os.environ['PDP10_PREFIX'])/'bin'
    tools = Path(os.environ.get('DOBJ2_TOOLS') or prefix)
    linker = Path(os.environ.get('P10X_LINKER') or prefix/'dlink')
    gcc = Path(os.environ.get('PDP10_GCC_OVERRIDE') or prefix/'pdp10-dec-none-gcc')
    def run(cmd):
        p=subprocess.run(list(map(str,cmd)),capture_output=True,text=True,timeout=60)
        if p.returncode: raise AssertionError((cmd,p.stderr,work))
        return p.stdout
    def asm(name,body):
        s=work/(name+'.s'); o=work/(name+'.dobj')
        s.write_text(body,encoding='ascii');run([tools/'das','-C','-O',o,s]);return o
    startup=asm('crt','.text\n.entry start\n.globl start,done\n.extern main\nstart:\n move 17,[GIW 4001000]\n pushj 17,@[GIW main]\n movei 6,765\ndone: halt 0\n')
    cases=rows()
    def word(x):return '0'+format(x&oracle.WORD,'o')
    data=asm('oracle','.data\n.globl arithmetic_count,arithmetic_cases\narithmetic_count: .long '+word(len(cases))+'\narithmetic_cases:\n'+''.join(' .long '+','.join(word(v) for v in row)+'\n' for row in cases))
    lib=run([gcc,'-print-libgcc-file-name']).strip()
    src=ROOT/'tests/codegen/kl10/gcc-global-exact-range-v57o.c'
    for opt in ('O0','O1','O2','Os'):
        case=work/opt;case.mkdir();s=case/'test.s';o=case/'test.dobj';image=case/'test.p10x';mp=case/'test.map'
        print('RUN',case,len(cases),'arithmetic rows',flush=True)
        run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s]);run([tools/'das','-C','-O',o,s])
        run([linker,'--extended','1001000','2001000','3001000','-o',image,'-M',mp,startup,o,data,lib])
        syms={n:int(v,8) for n,v in (l.split() for l in mp.read_text().splitlines())}
        m.execute(image,case,{syms['fail_id']:0,syms['result']:765,syms['checked']:len(cases),syms['observed']:0,syms['expected']:0},syms['done'],steps=5000000)
    print('PASS',len(cases),'rows, seven typed checks per row;',work,flush=True)


if __name__=='__main__': main()
