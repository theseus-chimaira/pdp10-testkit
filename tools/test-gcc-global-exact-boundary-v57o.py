#!/usr/bin/env python3
"""Run actual typed exact-width memory accesses across section boundaries."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('oracle',ROOT/'tools/test-gcc-global-exact-model-v56y.py')
oracle=importlib.util.module_from_spec(spec);spec.loader.exec_module(oracle)
m=oracle.m
MASK=oracle.WORD
GUARD=0o123456701234
BOUNDARIES=(0o5377777,0o5777777,0o36777777)


def sign(value,width,signed):
    if signed and value & (1<<(width-1)): value-=1<<width
    return value&MASK


def rows(boundaries=BOUNDARIES, fitting_only=False):
    cases=[]
    for addr in boundaries:
        for width in (16,32):
            tags=[(pos+1,pos) for pos in range(36)]
            tags += [(0o45,0),(0o54,16)] if width==16 else [(0,4)]
            for tag,pos in tags:
                if fitting_only and pos+width>36: continue
                for signed in (0,1):
                    first,second=0o654321076543,0o765432107654
                    bits=(1<<width)-1
                    value=(0x9abcfed1^(pos*0x10203))&bits
                    if signed: value|=1<<(width-1)
                    if width==32 and tag==0:
                        first=sign(first&bits,width,signed)
                        read=first
                        after0,after1=sign(value,width,signed),second
                    else:
                        combined=(first<<36)|second
                        shift=72-pos-width
                        read=sign((combined>>shift)&bits,width,signed)
                        mask=bits<<shift
                        after=(combined&~mask)|(value<<shift)
                        after0,after1=after>>36,after&MASK
                    cases.append((width,(tag<<30)|addr,addr,signed,first,second,
                                  read,value,sign(value,width,signed),after0,after1,GUARD))
    return cases


def main():
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-exact-boundary-v57o-',dir=tmp))
    prefix=Path(os.environ['PDP10_PREFIX'])/'bin'
    tools=Path(os.environ.get('DOBJ2_TOOLS') or prefix)
    linker=Path(os.environ.get('P10X_LINKER') or prefix/'dlink')
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or prefix/'pdp10-dec-none-gcc')
    def run(cmd):
        p=subprocess.run(list(map(str,cmd)),capture_output=True,text=True,timeout=60)
        if p.returncode:raise AssertionError((cmd,p.stderr,work))
        return p.stdout
    def asm(name,body):
        s=work/(name+'.s');o=work/(name+'.dobj');s.write_text(body,encoding='ascii')
        run([tools/'das','-C','-O',o,s]);return o
    crt=asm('crt','.text\n.entry start\n.globl start,done\n.extern main\nstart:\n move 17,[GIW 4001000]\n pushj 17,@[GIW main]\n movei 6,765\ndone: halt 0\n')
    cases=rows()
    guard_addr=0o7777777
    guards=rows((guard_addr,),fitting_only=True)
    def word(x):return '0'+format(x&MASK,'o')
    body=['.data','.globl memory_count,memory_cases,guard_count,guard_cases',
          'memory_count: .long '+word(len(cases)),
          'guard_count: .long '+word(len(guards)), 'memory_cases:']
    body.extend(' .long '+','.join(word(v) for v in row) for row in cases)
    body.append('guard_cases:')
    body.extend(' .long '+','.join(word(v) for v in row) for row in guards)
    data=asm('oracle','\n'.join(body)+'\n')
    lib=run([gcc,'-print-libgcc-file-name']).strip()
    src=ROOT/'tests/codegen/kl10/gcc-global-exact-boundary-v57o.c'
    extra={a+offset:GUARD for a in BOUNDARIES for offset in (-1,0,1,2)}
    extra.update({guard_addr-1:GUARD,guard_addr:GUARD})
    final=extra.copy()
    final[guard_addr]=guards[-1][9]
    for row in cases:final[row[2]],final[row[2]+1]=row[9:11]
    for opt in ('O0','O1','O2','Os'):
        case=work/opt;case.mkdir();s=case/'test.s';o=case/'test.dobj';image=case/'test.p10x';mp=case/'test.map'
        print('RUN',case,len(cases),'memory rows,',len(guards),'unmapped-next-section guards',flush=True)
        run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s]);run([tools/'das','-C','-O',o,s]);run([linker,'--extended','1001000','2001000','3001000','-o',image,'-M',mp,crt,o,data,lib])
        syms={n:int(v,8) for n,v in (l.split() for l in mp.read_text().splitlines())}
        expected={syms['fail_id']:0,syms['result']:765,syms['checked']:len(cases)+len(guards),syms['observed']:0,syms['expected']:0}
        expected.update(final)
        m.execute(image,case,expected,syms['done'],steps=1000000,extra_words=extra)
    print('PASS',len(cases),'signed/unsigned boundary rows and',len(guards),'non-crossing guards;',work,flush=True)


if __name__=='__main__': main()
