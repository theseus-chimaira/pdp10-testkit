#!/usr/bin/env python3
"""Check static native pointer adjustments, differences and relations."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile
import argparse

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('native',ROOT/'tools/test-gcc-global-native-boundary-v57s.py')
native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--baseline',action='store_true');args=parser.parse_args()
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-native-constant-v57t-',dir=tmp))
    prefix=Path(os.environ['PDP10_PREFIX'])/'bin'
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or prefix/'pdp10-dec-none-gcc')
    das=Path(os.environ.get('DOBJ2_TOOLS') or prefix)/'das'
    types='\n'.join(f'typedef unsigned int u{w} __attribute__((size ({w})));' for w in (6,7,8))+ '\ntypedef unsigned char u9;\ntypedef unsigned short u18;\ntypedef unsigned long u36;\n'
    cases=native.arithmetic();failures=0
    for kind in ('adjust','difference','compare'):
        lines=[types];expected={}
        for width in native.WIDTHS:
            exprs=[];words=[]
            for w,p,q,n in cases:
                if w!=width:continue
                a=f'((u{w} *)0{p:o}UL)';b=f'((u{w} *)0{q:o}UL)'
                if kind=='adjust':
                    exprs.extend((f'{a}+({n}L)',f'{b}-({n}L)'));words.extend((q,p))
                elif kind=='difference':
                    exprs.extend((f'{b}-{a}',f'{a}-{b}'));words.extend((n&native.MASK,(-n)&native.MASK))
                else:
                    for op,v in zip(('==','!=','<','<=','>','>='),(n==0,n!=0,n<0,n<=0,n>0,n>=0)):
                        exprs.append(f'{b}{op}{a}');words.append(int(v))
            name=f'{kind}{width}';expected[name]=words
            decl=f'u{width} *' if kind=='adjust' else 'long '
            lines.append(f'{decl}{name}[] = {{\n'+',\n'.join(exprs)+'\n};')
        src=work/(kind+'.c');src.write_text('\n'.join(lines)+'\n',encoding='ascii')
        for opt in (('O0',) if args.baseline else ('O0','O1','O2','Os')):
            base=work/(kind+'-'+opt);s=base.with_suffix('.s');o=base.with_suffix('.dobj');log=base.with_suffix('.log')
            with log.open('w') as out:
                ret=subprocess.run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s],stdout=out,stderr=subprocess.STDOUT,timeout=90)
                if not ret.returncode:ret=subprocess.run([das,'-C','-O',o,s],stdout=out,stderr=subprocess.STDOUT,timeout=90)
            if ret.returncode:
                print('REJECT',kind,opt,work,flush=True);failures+=1
                if not args.baseline:raise AssertionError(log)
                continue
            _,sections,symbols,rel,_=native.m.obj.read_object(o);names={n:(sec,off) for n,k,sec,off in symbols}
            total=bad=0;first=None
            for name,words in expected.items():
                sec,off=names[name];assert sec==2
                for i,w in enumerate(words):
                    actual=sections[sec][off+i];total+=1
                    if actual!=w or (sec,off+i) in rel:
                        bad+=1
                        if first is None:first=(name,i,oct(actual),oct(w))
            print(kind,opt,total,'words',bad,'mismatches',first,work,flush=True)
            failures+=bad
            if not args.baseline:assert not bad
    if args.baseline:assert failures


if __name__=='__main__':main()
