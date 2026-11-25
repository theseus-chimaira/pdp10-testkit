#!/usr/bin/env python3
"""Test candidate one-word exact pointer math, memory and ADDR30 tags.

This runs explicit word operations, not GCC exact-width pointer lowering.
The host oracle uses unbounded linear bit/slot coordinates independently
of the quotient/remainder implementation in the guest.
"""
import os
from pathlib import Path
import subprocess
import tempfile
import importlib.util

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('extended',ROOT/'tools/test-kl10b-extended-link-v56m.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
ADDR=(1<<30)-1
WORD=(1<<36)-1


def packed(coord):
    address,pos=divmod(coord,36)
    if not 0<=address<=ADDR:raise ValueError(coord)
    return (pos+1)<<30|address


def native(coord,width):
    slots=2 if width==16 else 1
    address,slot=divmod(coord,slots)
    if not 0<=address<=ADDR:raise ValueError(coord)
    tag=(0o45,0o54)[slot] if width==16 else 0
    return tag<<30|address


def arithmetic():
    rows=[]
    for width in (16,32):
        for addr in (1,0o777777,0o1000000,0o37777777,ADDR-1,ADDR):
            for bit in range(36):
                origin=36*addr+bit
                for delta in (-19,-9,-2,-1,0,1,2,9,19):
                    dest=origin+width*delta
                    if 0<=dest<36*(ADDR+1):rows.append((width,packed(origin),delta,packed(dest)))
        # Large valid moves use the high bits of a 30-bit coordinate.
        for delta in (1<<29,(1<<30)-1, -(1<<29),-((1<<30)-1)):
            origin=36*(ADDR//2)+17
            dest=origin+width*delta
            if 0<=dest<36*(ADDR+1):rows.append((width,packed(origin),delta,packed(dest)))
        # Exercise almost the entire 30-bit word range. The two
        # endpoints have the same typed-array stride residue.
        origin=36
        delta=(36*(ADDR+1)-1-origin)//width
        rows.append((width,packed(origin),delta,packed(origin+delta*width)))
        slots=2 if width==16 else 1
        delta=slots*(ADDR+1)-1-slots
        rows.append((width,native(slots,width),delta,native(slots+delta,width)))
        for addr in (1,0o777777,0o1000000,ADDR-1,ADDR):
            for slot in range(slots):
                origin=slots*addr+slot
                for delta in (-19,-2,-1,0,1,2,19,1<<29,-(1<<29)):
                    dest=origin+delta
                    if 0<=dest<slots*(ADDR+1):rows.append((width,native(origin,width),delta,native(dest,width)))
    return rows


def memory():
    rows=[]
    for width in (16,32):
        positions=[(pos,pos+1) for pos in range(36)]
        positions += [(0,0o45),(16,0o54)] if width==16 else [(4,0)]
        for pos,tag in positions:
            before=(0o654321076543,0o123456701234)
            value=(0x9abcfed1 ^ (pos*0x10203)) & ((1<<width)-1)
            combined=before[0]<<36|before[1]
            shift=72-pos-width;mask=((1<<width)-1)<<shift
            read=(combined&mask)>>shift
            after=(combined&~mask)|(value<<shift)
            if width==32 and tag==0:after=value<<36|before[1]
            rows.append((width,tag,*before,read,value,after>>36,after&WORD))
    return rows


def main():
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-exact-model-v56y-',dir=tmp))
    prefix=Path(os.environ['PDP10_PREFIX'])/'bin'
    tools=Path(os.environ.get('DOBJ2_TOOLS') or prefix)
    ld=Path(os.environ.get('P10X_LINKER') or prefix/'dlink')
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or prefix/'pdp10-dec-none-gcc')
    def run(cmd,fail=False):
        p=subprocess.run(list(map(str,cmd)),capture_output=True,text=True,timeout=60)
        assert (p.returncode!=0)==fail,(cmd,p.stderr,work)
        return p.stdout
    def asm(name,body,flags=('-C',),fail=False):
        s=work/(name+'.s');o=work/(name+'.dobj');s.write_text(body,encoding='ascii')
        run([tools/'das',*flags,'-O',o,s],fail)
        return o
    def octword(x):return '0'+format(x&WORD,'o')
    # All possible upper tags, including architectural selectors and 077.
    # Check relocation metadata rather than inferring it from printed words.
    tagged=asm('tagged','.text\n.globl start\n.entry start\n.extern fields\nstart: move 1,[%GADDR(44,fields+1)]\n halt 0\n.data\nlocal:\n'+''.join(f' .long %GADDR({t:o},local-1),%GADDR({t:o},fields+1000000)\n' for t in range(64)))
    version,sections,symbols,rel,_=m.obj.read_object(tagged)
    assert version==2 and len(sections[2])==128
    for t in range(64):
        assert sections[2][2*t:2*t+2]==[t<<30,t<<30]
        assert rel[2,2*t]==(5,2,None,-1)
        assert rel[2,2*t+1]==(6,0,'fields',0o1000000)
    assert sections[1][2]==0o44<<30 and rel[1,2]==(6,0,'fields',1)
    # Resolve every tag through the real extended linker, including
    # section carry and negative addends. No tag may participate in
    # address overflow, and the 077 tag is not a negative displacement.
    definition=asm('definition','.bss\n.globl fields\nfields: .space 16\n')
    tagimage=work/'tagged.p10x'
    run([ld,'--extended','1001000','2001000','3001000','-o',tagimage,tagged,definition])
    _,ranges,words=m.read_image(tagimage)
    assert words[ranges[0][1]:]==[v for t in range(64) for v in ((t<<30)|0o2000777,(t<<30)|0o4001000)]
    for name,addend in [('over','+7777777777'),('under','-7777777777')]:
        bad=asm(name,'.text\n.entry start\n.globl start\nstart: halt 0\n.data\nlocal: .long %GADDR(77,local'+addend+')\n')
        run([ld,'--extended','1001000','2001000','3001000','-o',work/(name+'.p10x'),bad],True)
    absobj=asm('absolute','.text\n'+''.join(f' .long %GADDR({t:o},7777777777)\n' for t in range(64)))
    assert m.obj.read_object(absobj)[1][1]==[(t<<30)|ADDR for t in range(64)]
    # Existing parenthesized EXIND literals must remain a single word.
    exind=asm('exind','.text\n move 1,[%EXIND(1,2,02001000)]\n halt 0\n')
    assert m.obj.read_object(exind)[1][1][2:]==[(0o22<<30)|0o2001000]
    for i,bad in enumerate(('%GADDR(100,1000)','%GADDR(-1,1000)','%GADDR(local,1000)',
                            '%GADDR(1,10000000000)','%GADDR(1,local+10000000000)',
                            '%GADDR(1,)','%GADDR(1,1000,2000)','%GADDR(1,1000)junk',
                            '%GADDR(1,1000')):
        asm('bad'+str(i),'.text\nlocal: .long '+bad+'\n',fail=True)
    asm('strict','.text\n .long %GADDR(1,1000)\n',('-B','-C'),True)
    asm('dxr','.text\nlocal: .long %GADDR(1,local)\n',(),True)
    print('PASS 64 absolute tags, 128 symbolic tag relocations, literal and rejection checks',flush=True)
    ac=arithmetic();mc=memory()
    body=['.data','.globl arithmetic_count,memory_count,arithmetic_cases,memory_cases,fields',
          'arithmetic_count: .long '+octword(len(ac)), 'memory_count: .long '+octword(len(mc)), 'arithmetic_cases:']
    body.extend(' .long '+','.join(octword(v) for v in row) for row in ac)
    body.append('memory_cases:')
    for w,t,*rest in mc:body.append(' .long '+octword(w)+f',%GADDR({t:o},fields+1),'+','.join(octword(v) for v in rest))
    body+=['.bss','fields: .space 16']
    data=asm('oracle','\n'.join(body)+'\n')
    crt=asm('crt','.text\n.entry start\n.globl start,done\n.extern main\nstart:\n move 17,[GIW 4001000]\n pushj 17,@[GIW main]\n movei 6,765\ndone: halt 0\n')
    lib=run([gcc,'-print-libgcc-file-name']).strip()
    src=ROOT/'tests/codegen/kl10/gcc-global-exact-pointer-model-v56y.c'
    for opt in ('O0','O1','O2','Os'):
        case=work/opt;case.mkdir();s=case/'test.s';o=case/'test.dobj';image=case/'test.p10x';mp=case/'test.map'
        run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s]);run([tools/'das','-C','-O',o,s]);run([ld,'--extended','1001000','2001000','3001000','-o',image,'-M',mp,crt,o,data,lib])
        syms={n:int(v,8) for n,v in (l.split() for l in mp.read_text().splitlines())}
        m.execute(image,case,{syms['fail_id']:0,syms['result']:765,syms['checked']:len(ac)+len(mc)},syms['done'],steps=5000000)
    print(f'PASS {len(ac)} arithmetic rows (four checks each), {len(mc)} field rows per execution; {work}',flush=True)


if __name__=='__main__':main()
