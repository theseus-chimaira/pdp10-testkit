#!/usr/bin/env python3
"""Dedicated P10X1 link and sparse KL10B execution tests (not matrix cells)."""
import importlib.util
import os
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
MASK = (1 << 18) - 1
ADDR = (1 << 30) - 1
BASES = (0o1001000, 0o2001000, 0o3001000)
STACK = 0o4001000


def module(name):
    spec = importlib.util.spec_from_file_location(name, ROOT/'tools'/name)
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m


isa = module('test-kl10b-section-execution-v56b.py')
obj = module('test-dobj2-global-address-v56h.py')


def read_image(path):
    words = obj.read_words(path)
    if len(words) < 8 or words[0] != obj.sixbit('P10X1 '):
        raise ValueError('not P10X1')
    entry = words[1]
    ranges = [(words[i],words[i+1]) for i in (2,4,6)]
    if any(b > ADDR or b <= MASK or b & MASK < 0o20 or
           n > (1 << 18) - (b & MASK) for b,n in ranges):
        raise ValueError('invalid virtual range')
    for i,(a,n) in enumerate(ranges):
        for b,m in ranges[i+1:]:
            if n and m and a < b+m and b < a+n:
                raise ValueError('overlapping virtual range')
    if not ranges[0][0] <= entry < sum(ranges[0]) or len(words) != 8+ranges[0][1]+ranges[1][1]:
        raise ValueError('invalid entry or image length')
    return entry,ranges,words[8:]


def deposits(path):
    entry,ranges,words = read_image(path)
    # Small host-only execution fixture: allocate pages on demand, never
    # allocate the address-space holes between sections. Reserve pages 0/2
    # for bootstrap/EPT and page tables separately from guest frames.
    sections = sorted({0, STACK>>18} | {b>>18 for b,n in ranges if n})
    if sections[-1] > 0o37:
        raise ValueError('test fixture supports sections 0..37 octal')
    tables = {s:i+3 for i,s in enumerate(sections)}
    phys = {0o100:0o701200060002, 0o101:isa.ins(0o254,5,0o120),
            0o120:0, 0o121:entry}
    for s,t in tables.items():phys[0o2540+s]=isa.direct(t)
    phys[tables[0]<<9]=isa.direct(0)
    frames = {}
    def mapword(a):
        page=a>>9
        if page not in frames:
            frame=3+len(tables)+len(frames)
            if frame>=512:raise ValueError('physical memory exhausted')
            frames[page]=frame
            phys[(tables[a>>18]<<9)+(page&0o777)]=isa.direct(frame)
        return (frames[page]<<9)|(a&0o777)
    at=0
    for i,(base,count) in enumerate(ranges):
        for off in range(count):
            p=mapword(base+off)
            if i<2:phys[p]=words[at];at+=1
    # Stack is an independent physical allocation. All fixture memory
    # starts zero in a fresh emulator process; BSS has no stored words.
    if any(n and b < STACK+0o1000 and STACK < b+n for b,n in ranges):
        raise ValueError('stack overlap')
    for a in range(STACK,STACK+0o1000,512):mapword(a)
    return phys,mapword,entry


def execute(path, work, expected, halt_pc, want=0, steps=10000):
    phys,mapped,entry=deposits(path)
    probes={1:want,6:0o765,0o17:STACK}
    probes.update({mapped(a):w for a,w in expected.items()})
    # SIMH automatically reads simh.ini in its working directory.
    # Never use that name for the explicitly supplied command file.
    ini=work/'extended-v56m-run.ini'
    lines=['set cpu kl10b','set cpu 256K','set cpu noidle','set cpu history=100']
    lines += [f'deposit {a:o} {w:012o}' for a,w in sorted(phys.items())]
    lines += ['deposit pc 100',f'step {steps:d}','examine pc_sect','examine t20_page']
    lines += [f'examine {a:o}' for a in probes]+['show cpu history=40','quit']
    ini.write_text('\n'.join(lines)+'\n')
    sim=os.environ.get('SIMH_KL') or str(Path(os.environ['PDP10_PREFIX'])/'bin/pdp10-kl')
    log=work/'simh.log'
    with log.open('wb') as out:
        subprocess.run([sim,str(ini)],cwd=work,stdin=subprocess.DEVNULL,stdout=out,stderr=subprocess.STDOUT,timeout=30,check=True)
    output=log.read_text()
    values={m[1]:int(m[2],8) for m in re.finditer(r'^([A-Z_0-7]+):\s*([0-7]+)\s*$',output,re.M)}
    assert output.count('HALT instruction')==1 and 'Step expired' not in output and 'Time expired' not in output,log
    assert values.get('PC_SECT')==entry>>18 and values.get('T20_PAGE')==1,log
    assert re.search(rf'^{halt_pc:08o}\s+.*HALT',output,re.M),log
    for a,w in probes.items():assert values.get(f'{a:o}')==w,(f'{a:o}',w,values.get(f'{a:o}'),log)
    print('PASS SIMH',work.name,flush=True)
    klh=os.environ.get('KLH10_KL') or str(Path(os.environ['PDP10_PREFIX'])/'bin/kn10-kl')
    if Path(klh).is_file():
        k=module('test-klh10-isa-v56e.py')
        k.run(klh,work,'klh10',[f'deposit P{a:o} {w:012o}' for a,w in sorted(phys.items())],probes,(entry>>18)<<18)
    else:
        print('SKIP KLH10 executable not installed',flush=True)


def main():
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    root=Path(tempfile.mkdtemp(prefix='pdp10-extended-link-v56m-',dir=tmp))
    prefix=Path(os.environ['PDP10_PREFIX'])/'bin'
    tools=Path(os.environ.get('DOBJ2_TOOLS') or prefix)
    linker=Path(os.environ.get('P10X_LINKER') or prefix/'dlink')
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or prefix/'pdp10-dec-none-gcc')
    def run(cmd,fail=None):
        p=subprocess.run(list(map(str,cmd)),capture_output=True,text=True,timeout=30)
        if fail is None:assert p.returncode==0,(cmd,p.stderr,root)
        else:assert p.returncode!=0 and fail in p.stderr,(cmd,p.stderr,root)
        return p
    def asm(name,source):
        s=root/(name+'.s');o=root/(name+'.dobj');s.write_text(source,encoding='ascii')
        run([tools/'das','-C','-O',o,s]);return o
    def link(name,objects,bases=BASES,fail=None):
        image=root/(name+'.p10x');mapfile=root/(name+'.map')
        run([linker,'--extended',*[f'{a:o}' for a in bases],'-o',image,'-M',mapfile,*objects],fail)
        if fail is not None:assert not image.exists();return
        syms={n:int(v,8) for n,v in (l.split() for l in mapfile.read_text().splitlines())}
        return image,syms
    # Independently specify the architectural instruction word; an
    # assembler mnemonic regression must not be hidden by the C test.
    xmovei=asm('xmovei','.text\n xmovei 17,2(17)\n')
    version,secs,_,_,_=obj.read_object(xmovei)
    assert secs[1]==[0o415757000002]
    run([tools/'das','-B','-C','-O',root/'base-xmovei.dobj',root/'xmovei.s'],
        'non-base opcode rejected')
    # Compare the exact local link bytes with an optional previous linker.
    local=asm('local','.text\n.entry local_start\n.globl local_start\nlocal_start: move 1,[123]\n halt 0\n.data\n .long local_start\n')
    legacy=root/'local-new.dxr'
    run([linker,'-b','1000','-o',legacy,local])
    previous=os.environ.get('P10X_BASELINE_LINKER')
    if previous:
        old=root/'local-old.dxr'
        run([previous,'-b','1000','-o',old,local])
        assert legacy.read_bytes()==old.read_bytes()
        print('PASS byte-identical local DXR link',flush=True)
    run([linker,'--extended','1001000','2001000','3001000','--pure','-o',root/'bad-option.p10x',local],
        'incompatible with legacy image options')
    startup=asm('crt0','.text\n.entry start\n.globl start,done\n.extern main\nstart:\n move 17,[GIW 4001000]\n pushj 17,@[GIW main]\n movei 6,765\ndone: halt 0\n')
    # Archive extraction must see an ADDR30-only reference. No ordinary
    # RH18 reference may accidentally pull this provider into the link.
    caller=asm('caller','.text\n.globl main\n.extern datum,fun,zero\nmain:\n move 1,@[GIW datum]\n pushj 17,@[GIW fun]\n movem 1,@[GIW zero]\n movei 1,0\n popj 17,\n.data\n.globl ptr,carry,negative\nptr: OWGBP 70,datum\ncarry: GIW datum+777000\nnegative: GIW datum-1\n')
    provider=asm('provider','.text\n.globl fun\nfun: addi 1,1\n popj 17,\n.data\n.globl datum\ndatum: .long 0123\n.bss\n.globl zero\nzero: .block 1\n')
    archive=root/'provider.darc';run([tools/'darc','-o',archive,provider])
    image,syms=link('archive',[startup,caller,archive])
    entry,ranges,words=read_image(image)
    assert entry==BASES[0] and [b for b,n in ranges]==list(BASES)
    memory={a+i:w for (a,n),start in zip(ranges[:2],(0,ranges[0][1])) for i,w in enumerate(words[start:start+n])}
    assert memory[syms['ptr']]==(0o70<<30)|syms['datum']
    assert memory[syms['carry']]==syms['datum']+0o777000 and memory[syms['carry']]>>18==3
    assert memory[syms['negative']]==syms['datum']-1
    work=root/'archive-run';work.mkdir();execute(image,work,{syms['zero']:0o124},syms['done'])
    bad=asm('bad-rh','.text\n.extern datum\n move 1,datum\n')
    link('cross-rh',[startup,caller,provider,bad],fail='cross-section 18-bit relocation')
    bad=asm('bad-overflow','.text\n.extern datum\n GIW datum+7777777777\n')
    link('overflow',[startup,caller,provider,bad],fail='extended relocation overflow')
    bad=asm('bad-underflow','.text\n.extern datum\n GIW datum-7777777777\n')
    link('underflow',[startup,caller,provider,bad],fail='extended relocation overflow')
    link('overlap',[startup,caller,provider],(BASES[0],BASES[0],BASES[2]),fail='overlapping extended ranges')
    link('range',[startup,caller,provider],(0o1777777,BASES[1],BASES[2]),fail='extended range exceeds CPU section')
    link('undefined',[startup,caller],fail='undefined symbol')
    print('PASS link rejection controls',flush=True)
    libgcc=run([gcc,'-print-libgcc-file-name']).stdout.strip()
    for opt in ('O0','O1','O2','Os'):
        s=root/(opt+'.s');o=root/(opt+'.dobj')
        run([gcc,'-march=kl10','-mextended','-'+opt,'-S',ROOT/'tests/codegen/kl10/gcc-global-execution-v56m.c','-o',s])
        run([tools/'das','-C','-O',o,s])
        image,syms=link(opt,[startup,o,libgcc])
        work=root/(opt+'-run');work.mkdir()
        execute(image,work,{syms['scratch']:36},syms['done'])
    print('PASS P10X1 and all four extended GCC runtime profiles',root,flush=True)


if __name__=='__main__':main()
