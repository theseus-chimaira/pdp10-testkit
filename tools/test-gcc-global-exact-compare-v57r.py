#!/usr/bin/env python3
"""Check static exact-width pointer differences and comparisons."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('range_oracle',ROOT/'tools/test-gcc-global-exact-range-v57o.py')
model=importlib.util.module_from_spec(spec);spec.loader.exec_module(model)


def main():
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-exact-compare-v57r-',dir=tmp))
    prefix=Path(os.environ['PDP10_PREFIX'])/'bin'
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or prefix/'pdp10-dec-none-gcc')
    das=Path(os.environ.get('DOBJ2_TOOLS') or prefix)/'das'
    lines=['typedef unsigned int u16 __attribute__((size (16)));',
           'typedef unsigned int u32 __attribute__((size (32)));']
    diffs=[];comparisons=[];dw=[];cw=[]
    for width,p,n,q in model.rows():
        a=f'((u{width} *)0{q:o}UL)';b=f'((u{width} *)0{p:o}UL)'
        diffs.extend((f'{a}-{b}',f'{b}-{a}'));dw.extend((n&model.oracle.WORD,(-n)&model.oracle.WORD))
        for op,v in zip(('==','!=','<','<=','>','>='),(n==0,n!=0,n<0,n<=0,n>0,n>=0)):
            comparisons.append(f'{a}{op}{b}');cw.append(int(v))
    # Separate translation units so the comparison baseline can be
    # inspected even when constant subtraction is rejected.
    for name,exprs,expected in (('differences',diffs,dw),('comparisons',comparisons,cw)):
        src=work/(name+'.c');src.write_text('\n'.join(lines)+f'\nlong {name}[] = {{\n'+',\n'.join(exprs)+'\n};\n',encoding='ascii')
        for opt in ('O0','O1','O2','Os'):
            s=work/(name+'-'+opt+'.s');o=s.with_suffix('.dobj');log=s.with_suffix('.log')
            with log.open('w') as out:
                subprocess.run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s],stdout=out,stderr=subprocess.STDOUT,timeout=90,check=True)
                subprocess.run([das,'-C','-O',o,s],stdout=out,stderr=subprocess.STDOUT,timeout=90,check=True)
            _,sections,symbols,rel,_=model.m.obj.read_object(o)
            _,_,sec,off=next(row for row in symbols if row[0]==name)
            assert sec==2,(name,sec,work)
            for i,w in enumerate(expected):
                actual=sections[sec][off+i]
                assert actual==w and (sec,off+i) not in rel,(opt,name,i,oct(actual),oct(w),work)
            print('PASS',opt,name,len(expected),'static words',work,flush=True)


if __name__=='__main__':main()
