#!/usr/bin/env python3
"""Check actual static absolute pointer words against the v57o host oracle."""
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
    work=Path(tempfile.mkdtemp(prefix='pdp10-exact-constant-v57p-',dir=tmp))
    prefix=Path(os.environ['PDP10_PREFIX'])/'bin'
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or prefix/'pdp10-dec-none-gcc')
    das=Path(os.environ.get('DOBJ2_TOOLS') or prefix)/'das'
    lines=[];expected={}
    for width in (16,32):
        lines.append(f'typedef unsigned int u{width} __attribute__((size ({width})));')
        values=[];words=[]
        for w,p,n,q in model.rows():
            if w!=width:continue
            values.extend((f'(u{width} *)0{p:o}UL + ({n}L)',f'(u{width} *)0{q:o}UL - ({n}L)'))
            words.extend((q,p))
        name=f'ptr{width}';expected[name]=words
        lines.append(f'u{width} *{name}[] = {{\n'+',\n'.join(values)+'\n};')
    src=work/'constant-v57p.c';src.write_text('\n'.join(lines)+'\n',encoding='ascii')
    for opt in ('O0','O1','O2','Os'):
        s=work/(opt+'.s');o=work/(opt+'.dobj');log=work/(opt+'.log')
        with log.open('w') as out:
            subprocess.run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s],stdout=out,stderr=subprocess.STDOUT,timeout=90,check=True)
            subprocess.run([das,'-C','-O',o,s],stdout=out,stderr=subprocess.STDOUT,timeout=90,check=True)
        _,sections,symbols,rel,_=model.m.obj.read_object(o)
        names={n:(k,sec,off) for n,k,sec,off in symbols}
        for name,words in expected.items():
            _,sec,off=names[name]
            assert sec==2,(name,sec,work)
            for i,w in enumerate(words):
                actual=sections[sec][off+i]
                assert actual==w and (sec,off+i) not in rel,(opt,name,i,oct(actual),oct(w),work)
        print('PASS',opt,sum(map(len,expected.values())),'absolute static pointer words',work,flush=True)


if __name__=='__main__':main()
