#!/usr/bin/env python3
"""Independent native byte/word coordinate and physical boundary tests."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('boundary',ROOT/'tools/test-gcc-global-exact-boundary-v57o.py')
boundary=importlib.util.module_from_spec(spec);spec.loader.exec_module(boundary)
m=boundary.m
MASK=boundary.MASK
GUARD=boundary.GUARD
WIDTHS={6:0o46,7:0o62,8:0o55,9:0o70,18:0o75,36:0}
ADDR=(1<<30)-1


def encode(width,coord):
    a,s=divmod(coord,36//width)
    assert 0<=a<=ADDR
    return ((WIDTHS[width]+s)<<30)|a


def arithmetic():
    rows=[]
    for w in WIDTHS:
        slots=36//w
        for a in (1,0o5377777,0o5777777,0o6000000,0o36777777,0o37000000,(1<<29)-1,1<<29,ADDR-1,ADDR):
            for s in range(slots):
                p=a*slots+s
                for n in (-19,-7,-2,-1,0,1,2,7,19):
                    q=p+n
                    if slots<=q<(ADDR+1)*slots:rows.append((w,encode(w,p),encode(w,q),n))
        p=slots
        q=(ADDR+1)*slots-1
        # Full-span element counts and both signs. ADJBP is evaluated
        # on its architectural address field, not mapped memory.
        rows.append((w,encode(w,p),encode(w,q),q-p))
        rows.append((w,encode(w,q),encode(w,p),p-q))
    return rows


def memory():
    rows=[];extra={};final={}
    for a in (*boundary.BOUNDARIES,0o7777777):
        fitting=a==0o7777777
        extra.update({a-1:GUARD,a:GUARD})
        if not fitting:extra[a+1]=GUARD
        for w in WIDTHS:
            slots=36//w;mask=(1<<w)-1
            for s in range(slots):
                shift=36-w*(s+1);initial=0o654321076543
                before=(initial>>shift)&mask
                unsigned=mask-1;negative=(1<<(w-1))|3
                after=(initial&~(mask<<shift))|(negative<<shift)
                nextword=0o765432107654
                nextptr=encode(w,(a+1)*slots) if s==slots-1 and not fitting else 0
                nextvalue=(nextword>>(36-w))&mask
                rows.append((w,encode(w,a*slots+s),a,initial,before,boundary.sign(before,w,1),unsigned,negative,boundary.sign(negative,w,1),after,nextword,nextptr,nextvalue,GUARD))
                final[a]=after
                if nextptr:final[a+1]=nextword
        final[a-1]=GUARD
    return rows,extra,final


def main():
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-native-boundary-v57s-',dir=tmp))
    prefix=Path(os.environ['PDP10_PREFIX'])/'bin'
    tools=Path(os.environ.get('DOBJ2_TOOLS') or prefix)
    linker=Path(os.environ.get('P10X_LINKER') or prefix/'dlink')
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or prefix/'pdp10-dec-none-gcc')
    def run(cmd):
        p=subprocess.run(list(map(str,cmd)),capture_output=True,text=True,timeout=60)
        if p.returncode:raise AssertionError((cmd,p.stderr,work))
        return p.stdout
    def asm(name,body):
        s=work/(name+'.s');o=work/(name+'.dobj');s.write_text(body,encoding='ascii');run([tools/'das','-C','-O',o,s]);return o
    crt=asm('crt','.text\n.entry start\n.globl start,done\n.extern main\nstart:\n move 17,[GIW 4001000]\n pushj 17,@[GIW main]\n movei 6,765\ndone: halt 0\n')
    ar=arithmetic();mem,extra,final=memory()
    def word(x):return '0'+format(x&MASK,'o')
    body=['.data','.globl arithmetic_count,arithmetic_cases,memory_count,memory_cases', 'arithmetic_count: .long '+word(len(ar)), 'memory_count: .long '+word(len(mem)), 'arithmetic_cases:']
    body.extend(' .long '+','.join(word(v) for v in row) for row in ar)
    body.append('memory_cases:');body.extend(' .long '+','.join(word(v) for v in row) for row in mem)
    data=asm('oracle','\n'.join(body)+'\n');lib=run([gcc,'-print-libgcc-file-name']).strip()
    src=ROOT/'tests/codegen/kl10/gcc-global-native-boundary-v57s.c'
    for opt in ('O0','O1','O2','Os'):
        case=work/opt;case.mkdir();s=case/'test.s';o=case/'test.dobj';image=case/'test.p10x';mp=case/'test.map'
        print('RUN',case,len(ar),'arithmetic rows,',len(mem),'memory rows',flush=True)
        run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s]);run([tools/'das','-C','-O',o,s]);run([linker,'--extended','1001000','2001000','3001000','-o',image,'-M',mp,crt,o,data,lib])
        syms={n:int(v,8) for n,v in (l.split() for l in mp.read_text().splitlines())}
        expected={syms['fail_id']:0,syms['result']:765,syms['checked']:len(ar)+len(mem),syms['observed']:0,syms['expected']:0};expected.update(final)
        m.execute(image,case,expected,syms['done'],steps=5000000,extra_words=extra)
    print('PASS',len(ar),'arithmetic rows and',len(mem),'memory rows;',work,flush=True)


if __name__=='__main__':main()
