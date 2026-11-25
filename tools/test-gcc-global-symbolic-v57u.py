#!/usr/bin/env python3
"""Verify symbolic scalar pointer words before and after ADDR30 relocation."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile
import argparse

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('link',ROOT/'tools/test-kl10b-extended-link-v56m.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
MASK=(1<<30)-1
WIDTHS={6:(0o46,6),7:(0o62,5),8:(0o55,4),9:(0o70,4),16:(0o45,2),18:(0o75,2),32:(0,1),36:(0,1)}


def generate(negative):
    lines=[];expected={};defs=['.text','.entry start','.globl start','start: halt 0','.data']
    for width,(tag,slots) in WIDTHS.items():
        typ={9:'unsigned char',18:'unsigned short',36:'unsigned long'}.get(width,'unsigned int __attribute__((size (%d)))'%width)
        # Attribute placement on the typedef name matches the target syntax.
        decl=(f'typedef unsigned int u{width} __attribute__((size ({width})));' if width not in (9,18,36) else f'typedef {typ} u{width};')
        base=f'b{width}';lines.extend((decl,f'extern u{width} {base}[];'));defs.extend((f'.globl {base}',f'{base}: .long 0'))
        vals=[];want=[]
        for slot in range(slots):
            for displacement in ([-(1<<29),-262145,-262144,-2,-1,0] if negative else [0,1,2,262143,262144,(1<<29)-1]):
                for end in range(slots):
                    count=displacement*slots+end-slot
                    vals.append(f'&{base}[{slot}]+({count}L)')
                    selector=(0o54 if end else 0o45) if width==16 else tag+end
                    want.append((base,selector,displacement))
        name=f'p{width}';expected[name]=want
        lines.append(f'u{width} *{name}[] = {{\n'+',\n'.join(vals)+'\n};')
    return '\n'.join(lines)+'\n', '\n'.join(defs)+'\n',expected


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--baseline',action='store_true');args=parser.parse_args()
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-symbolic-v57u-',dir=tmp));pre=Path(os.environ['PDP10_PREFIX'])/'bin'
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or pre/'pdp10-dec-none-gcc');das=Path(os.environ.get('DOBJ2_TOOLS') or pre)/'das';ld=Path(os.environ.get('P10X_LINKER') or pre/'dlink')
    failures=0
    for negative in (False,True):
        key='negative' if negative else 'positive';source,defs,expected=generate(negative)
        src=work/(key+'.c');src.write_text(source,encoding='ascii');ds=work/(key+'-defs.s');ds.write_text(defs,encoding='ascii');do=ds.with_suffix('.dobj')
        subprocess.run([das,'-C','-O',do,ds],check=True)
        for opt in (('O0',) if args.baseline else ('O0','O1','O2','Os')):
            stem=work/(key+'-'+opt);s=stem.with_suffix('.s');o=stem.with_suffix('.dobj');log=stem.with_suffix('.log');im=stem.with_suffix('.p10x');mp=stem.with_suffix('.map')
            with log.open('w') as out:
                subprocess.run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s],stdout=out,stderr=subprocess.STDOUT,check=True,timeout=60)
                subprocess.run([das,'-C','-O',o,s],stdout=out,stderr=subprocess.STDOUT,check=True,timeout=60)
            v,sections,symbols,rel,_=m.obj.read_object(o);assert v==2
            names={n:(sec,off) for n,k,sec,off in symbols};bad=total=0;first=None
            for name,words in expected.items():
                sec,off=names[name];assert sec==2
                for i,(target,tag,add) in enumerate(words):
                    actual=(sections[sec][off+i],rel.get((sec,off+i)));want=(tag<<30,(6,0,target,add));total+=1
                    if actual!=want:
                        bad+=1
                        if first is None:first=(name,i,actual,want)
            print(key,opt,total,'relocations',bad,'mismatches',first,work,flush=True);failures+=bad
            if args.baseline:continue
            assert not bad
            data='4001001000' if negative else '2001000'
            with log.open('a') as out:subprocess.run([ld,'--extended','1001000',data,'3001000','-o',im,'-M',mp,do,o],stdout=out,stderr=subprocess.STDOUT,check=True,timeout=60)
            _,ranges,words=m.read_image(im);syms={n:int(a,8) for n,a in (l.split() for l in mp.read_text().splitlines())};db,dc=ranges[1];textcount=ranges[0][1]
            for name,entries in expected.items():
                off=syms[name]-db;assert 0<=off<dc
                for i,(target,tag,add) in enumerate(entries):
                    address=syms[target]+add;assert 0<=address<=MASK
                    assert words[textcount+off+i]==(tag<<30)|address,(name,i,work)
            print('PASS linked',key,opt,total,'words',flush=True)
    if args.baseline:assert failures


if __name__=='__main__':main()
