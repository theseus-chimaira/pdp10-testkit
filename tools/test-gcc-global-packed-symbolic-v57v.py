#!/usr/bin/env python3
"""Verify packed exact-width symbolic pointer words before and after ADDR30 relocation."""
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
def generate(negative):
    lines=[];expected={};defs=['.text','.entry start','.globl start','start: halt 0','.data']
    for width in (16,32):
        lines.append(f'typedef unsigned int u{width} __attribute__((size ({width})));')
        vals=[];want=[]
        for prefix in range(1,5):
            base=f'b{width}_{prefix}'
            lines.append(f'extern struct r{width}_{prefix} {{ unsigned pre:{prefix}; u{width} a[9]; }} __attribute__((packed)) {base};')
            defs.extend((f'.globl {base}',f'{base}: .long 0'))
            for slot in range(9):
                start=prefix+width*slot
                for displacement in ([-(1<<29),-262145,-262144,-2,-1,0] if negative else [0,1,2,262143,262144,(1<<29)-1]):
                    # First reachable field position in the selected word.
                    count=(36*displacement-start+width-1)//width
                    for n in range(count,count+2):
                        word,bit=divmod(start+n*width,36)
                        if word!=displacement:continue
                        # Split the adjustment with an intermediate closer
                        # to the starting object, so both addends fit.
                        step=1 if n>0 else -1 if n<0 else 0
                        vals.extend((f'&{base}.a[{slot}]+({n}L)',
                                     f'&{base}.a[{slot}]-({-n}L)',
                                     f'(&{base}.a[{slot}]+({n-step}L))+({step}L)'))
                        want.extend(((base,bit+1,word),)*3)
        name=f'p{width}';expected[name]=want
        lines.append(f'u{width} *{name}[] = {{\n'+',\n'.join(vals)+'\n};')
    return '\n'.join(lines)+'\n', '\n'.join(defs)+'\n',expected


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--probe-overflow',action='store_true',help='expect the previous compiler to emit a wrong relocation');args=parser.parse_args()
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-packed-symbolic-v57v-',dir=tmp));pre=Path(os.environ['PDP10_PREFIX'])/'bin'
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or pre/'pdp10-dec-none-gcc');das=Path(os.environ.get('DOBJ2_TOOLS') or pre)/'das';ld=Path(os.environ.get('P10X_LINKER') or pre/'dlink')
    for negative in (False,True):
        key='negative' if negative else 'positive';source,defs,expected=generate(negative)
        src=work/(key+'.c');src.write_text(source,encoding='ascii');ds=work/(key+'-defs.s');ds.write_text(defs,encoding='ascii');do=ds.with_suffix('.dobj')
        subprocess.run([das,'-C','-O',do,ds],check=True)
        for opt in (('O0','O1','O2','Os')):
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
            print(key,opt,total,'relocations',bad,'mismatches',first,work,flush=True)
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
    # v57v diagnosed the first offsets outside signed 30 bits. Since
    # v57x these are representable: require their exact wide relocations.
    for width in (16,32):
        n=(1<<29)*36//width
        for direction,count in (('positive',n),('negative',-n-1)):
            word,bit=divmod(5+count*width,36)
            src=work/f'overflow-{width}-{direction}.c'
            src.write_text(f'typedef unsigned int u __attribute__((size ({width})));\nextern struct r {{ unsigned pre:5; u a[9]; }} __attribute__((packed)) b;\nu *p=b.a+({count}L);\n',encoding='ascii')
            for opt in ('O0','O1','O2','Os'):
                s=work/f'overflow-{width}-{direction}-{opt}.s';log=s.with_suffix('.log');o=s.with_suffix('.dobj')
                ret=subprocess.run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s],capture_output=True,text=True,timeout=60)
                log.write_text(ret.stdout+ret.stderr)
                assert not ret.returncode,(log,ret.stderr)
                subprocess.run([das,'-C','-O',o,s],check=True,timeout=60)
                _,sections,symbols,rel,_=m.obj.read_object(o)
                _,_,sec,off=next(row for row in symbols if row[0]=='p')
                add=((word+(1<<29))%(1<<30))-(1<<29) if args.probe_overflow else word
                assert rel[sec,off]==(6,0,'b',add) and sections[sec][off]==(bit+1)<<30,(width,direction,opt,work)
                print('BASELINE wrong' if args.probe_overflow else 'PASS wide',width,direction,opt,flush=True)


if __name__=='__main__':main()
