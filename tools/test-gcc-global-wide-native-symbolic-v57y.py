#!/usr/bin/env python3
"""Check wide native scalar symbolic pointers in data and code."""
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
    lines=[];expected={};calls=[];code_expected=[]
    defs=['.text','.entry start','.globl start,done','.extern main','start:',
          ' move 17,[GIW 4001000]',' pushj 17,@[GIW main]',
          ' movei 6,765','done: halt 0','.data']
    for width,(tag,slots) in WIDTHS.items():
        typ={9:'unsigned char',18:'unsigned short',36:'unsigned long'}.get(width,'unsigned int __attribute__((size (%d)))'%width)
        # Attribute placement on the typedef name matches the target syntax.
        decl=(f'typedef unsigned int u{width} __attribute__((size ({width})));' if width not in (9,18,36) else f'typedef {typ} u{width};')
        base=f'b{width}';lines.extend((decl,f'extern u{width} {base}[];'));defs.extend((f'.globl {base}',f'{base}: .long 0'))
        vals=[];want=[]
        for slot in range(slots):
            for displacement in ([-(1<<30)+(1<<20),-(1<<29)-2,-(1<<29)-1,-(1<<29)] if negative else [(1<<29)-1,1<<29,(1<<29)+1,(1<<30)-(1<<20)]):
                for end in range(slots):
                    count=displacement*slots+end-slot
                    step=1 if count>0 else -1
                    exprs=(f'&{base}[{slot}]+({count}L)', f'&{base}[{slot}]-({-count}L)', f'(&{base}[{slot}]+({count-step}L))+({step}L)')
                    at=len(vals)
                    vals.extend(exprs)
                    selector=(0o54 if end else 0o45) if width==16 else tag+end
                    want.extend(((base,selector,displacement),)*len(exprs))
                    if slot==0 and end==slots-1:
                        for k,expr in enumerate(exprs):
                            fun=f'f{width}_{len(calls)}'
                            lines.append(f'__attribute__((noinline)) u{width} *{fun}(void) {{ return {expr}; }}')
                            calls.append(f'if ({fun}()!=p{width}[{at+k}]) return {len(calls)+1};')
                            code_expected.append((base,selector,displacement))
        name=f'p{width}';expected[name]=want
        lines.append(f'u{width} * volatile {name}[] = {{\n'+',\n'.join(vals)+'\n};')
    lines.append('volatile int result;\nint main(void) {\n'+'\n'.join(calls)+'\nresult=765; return 0; }')
    return '\n'.join(lines)+'\n', '\n'.join(defs)+'\n',expected,code_expected


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--baseline',action='store_true');args=parser.parse_args()
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-wide-native-symbolic-v57y-',dir=tmp));pre=Path(os.environ['PDP10_PREFIX'])/'bin'
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or pre/'pdp10-dec-none-gcc');das=Path(os.environ.get('DOBJ2_TOOLS') or pre)/'das';ld=Path(os.environ.get('P10X_LINKER') or pre/'dlink')
    failures=0
    lib=subprocess.check_output([gcc,'-print-libgcc-file-name'],text=True).strip()
    for negative in (False,True):
        key='negative' if negative else 'positive';source,defs,expected,code_expected=generate(negative)
        src=work/(key+'.c');src.write_text(source,encoding='ascii');ds=work/(key+'-defs.s');ds.write_text(defs,encoding='ascii');do=ds.with_suffix('.dobj')
        subprocess.run([das,'-C','-O',do,ds],check=True)
        for opt in (('O0',) if args.baseline else ('O0','O1','O2','Os')):
            case=work/(key+'-'+opt);case.mkdir();stem=case/'test';s=stem.with_suffix('.s');o=stem.with_suffix('.dobj');log=stem.with_suffix('.log');im=stem.with_suffix('.p10x');mp=stem.with_suffix('.map')
            with log.open('w') as out:
                ret=subprocess.run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s],stdout=out,stderr=subprocess.STDOUT,timeout=60)
                if ret.returncode and args.baseline:
                    print("BASELINE rejected",key,opt,work,flush=True);failures+=1;continue
                ret.check_returncode()
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
            observed={(r[2],sections[sec][off]>>30,r[3]) for (sec,off),r in rel.items() if sec==1 and r[0]==6}
            required={r for r in code_expected if not -(1<<29)<=r[2]<(1<<29)}
            assert required<=observed,(key,opt,required-observed,work)
            data='7777001000' if negative else '2001000'
            with log.open('a') as out:subprocess.run([ld,'--extended','1001000',data,'3001000','-o',im,'-M',mp,do,o,lib],stdout=out,stderr=subprocess.STDOUT,check=True,timeout=60)
            _,ranges,words=m.read_image(im);syms={n:int(a,8) for n,a in (l.split() for l in mp.read_text().splitlines())};db,dc=ranges[1];textcount=ranges[0][1]
            for name,entries in expected.items():
                off=syms[name]-db;assert 0<=off<dc
                for i,(target,tag,add) in enumerate(entries):
                    address=syms[target]+add;assert 0<=address<=MASK
                    assert words[textcount+off+i]==(tag<<30)|address,(name,i,work)
            text_prefix=len(m.obj.read_object(do)[1][1])
            for (sec,off),r in rel.items():
                if sec==1 and r[0]==6 and (r[2],sections[sec][off]>>30,r[3]) in code_expected:
                    assert words[off+text_prefix]==(sections[sec][off]&~MASK)|(syms[r[2]]+r[3]),(key,opt,off,work)
            print('PASS linked',key,opt,total,'words and',len(required),'required distinct wide code relocations',flush=True)
            if not negative:
                m.execute(im,case,{syms['result']:765},syms['done'],steps=1000000)
    if args.baseline:assert failures


if __name__=='__main__':main()
