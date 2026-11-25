#!/usr/bin/env python3
"""Check wide symbolic pointer casts in static data and function returns."""
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


# Independent mapping of canonical storage slots to physical bit positions.
# Test casts as representation probes, not dereferences of misaligned objects.
def position(tag):
    if tag in (0,0o45):return 0
    if tag==0o54:return 16
    if 1<=tag<=36:return tag-1
    for w,(first,slots) in WIDTHS.items():
        if w not in (16,32,36) and first<=tag<first+slots:
            return (tag-first)*w
    raise AssertionError(tag)


def convert(tag,width):
    pos=position(tag)
    if width==36:return 0
    if width in (16,32):
        if 1<=tag<=36:return tag
        if not pos:return 0o45 if width==16 else 0
        if width==16 and pos==16:return 0o54
        return pos+1
    first,slots=WIDTHS[width]
    return first+min(pos//width,slots-1)


def to_void(tag,width):
    if width in (18,36) or (width==32 and tag==0):
        return convert(tag,9)
    return tag


def generate(negative):
    lines=[];expected={};calls=[];code_expected=[]
    defs=['.text','.entry start','.globl start,done','.extern main','start:',
          ' move 17,[GIW 4001000]',' pushj 17,@[GIW main]',
          ' movei 6,765','done: halt 0','.data']
    for w in WIDTHS:
        typ={9:'unsigned char',18:'unsigned short',36:'unsigned long'}.get(w)
        lines.append(f'typedef {typ} u{w};' if typ else f'typedef unsigned int u{w} __attribute__((size ({w})));')
    sources=[]
    disps=(-(1<<29)-1,-(1<<30)+(1<<20)) if negative else (1<<29,(1<<30)-(1<<20))
    for w,(first,slots) in WIDTHS.items():
        base=f'b{w}'
        lines.append(f'extern u{w} {base}[];')
        defs.extend((f'.globl {base}',f'{base}: .long 0'))
        for slot in range(slots):
            tag=(0o54 if slot else 0o45) if w==16 else first+slot
            for d in disps:
                sources.append((w,base,tag,d,f'({base}+({d*slots+slot}L))'))
    for w in (16,32):
        for pre in range(1,5):
            base=f'r{w}_{pre}'
            lines.append(f'extern struct s{w}_{pre} {{ unsigned pre:{pre}; u{w} a[9]; }} __attribute__((packed)) {base};')
            defs.extend((f'.globl {base}',f'{base}: .long 0'))
            for d in disps:
                for slot in range(9):
                    n=(36*d-pre-w*slot+w-1)//w
                    addr,bit=divmod(pre+w*(slot+n),36)
                    assert addr==d
                    sources.append((w,base,bit+1,d,f'(&{base}.a[{slot}]+({n}L))'))
    for dest in (0,*WIDTHS):
        name=f'p{dest}';typ=f'u{dest}' if dest else 'void'
        vals=[];want=[]
        for w,base,tag,d,expr in sources:
            vtag=to_void(tag,w)
            if dest==0:
                variants=[(f'(void *){expr}',vtag)]
            else:
                variants=[(f'(u{dest} *)(void *){expr}',convert(vtag,dest))]
                if dest in (16,32) or w in (16,32):
                    variants.append((f'(u{dest} *){expr}',tag if w==dest else convert(tag,dest)))
                # Check ordinary native conversions at word alignment,
                # where both old ordinal and physical mappings agree.
                elif position(tag)==0:
                    # charN <-> charM conversions deliberately preserve
                    # the raw representation in the existing target ABI.
                    v=tag if w<=9 and dest<=9 else convert(tag,dest)
                    variants.append((f'(u{dest} *){expr}',v))
            for e,t in variants:
                at=len(vals);vals.append(e);want.append((base,t,d))
                if at%29==0:
                    fun=f'f{dest}_{at}'
                    lines.append(f'__attribute__((noinline)) {typ} *{fun}(void) {{ return {e}; }}')
                    # Compare the raw representation, not void equality.
                    calls.append(f'if ((unsigned long){fun}()!=(unsigned long){name}[{at}]) return {len(calls)+1};')
                    code_expected.append((base,t,d))
        expected[name]=want
        lines.append(f'{typ} * volatile {name}[] = {{\n'+',\n'.join(vals)+'\n};')
    lines.append('volatile int result;\nint main(void) {\n'+'\n'.join(calls)+'\nresult=765; return 0; }')
    return '\n'.join(lines)+'\n', '\n'.join(defs)+'\n',expected,code_expected


def native_limits(work,gcc,das):
    """Check the full architectural displacement magnitude, not placement."""
    for w,(tag,slots) in WIDTHS.items():
        typ={9:'unsigned char',18:'unsigned short',36:'unsigned long'}.get(w)
        decl=f'typedef {typ} u;' if typ else f'typedef unsigned int u __attribute__((size ({w})));'
        for d in (MASK,-MASK,MASK+1,-MASK-1):
            src=work/f'limit-{w}-{d}.c'
            src.write_text(f'{decl}\nextern u b[];\nu *p=b+({d*slots}L);\n',encoding='ascii')
            for opt in ('O0','O1','O2','Os'):
                stem=work/f'limit-{w}-{d}-{opt}'
                s=stem.with_suffix('.s');o=stem.with_suffix('.dobj');log=stem.with_suffix('.log')
                ret=subprocess.run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s],capture_output=True,text=True,timeout=60)
                log.write_text(ret.stdout+ret.stderr,encoding='utf-8')
                if abs(d)>MASK:
                    assert ret.returncode and 'global pointer relocation addend exceeds address space' in ret.stderr,(log,ret.stderr)
                    continue
                ret.check_returncode()
                subprocess.run([das,'-C','-O',o,s],check=True,timeout=60)
                _,secs,syms,rels,_=m.obj.read_object(o)
                _,_,sec,off=next(row for row in syms if row[0]=='p')
                assert rels.get((sec,off))==(6,0,'b',d) and secs[sec][off]==tag<<30,(w,d,opt,work)
        print('PASS native extreme and impossible displacement controls',w,flush=True)
    print('PASS 64 extreme native objects and 64 impossible displacement controls',work,flush=True)


def main():
    parser=argparse.ArgumentParser();parser.add_argument('--baseline',action='store_true');args=parser.parse_args()
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp');tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-wide-cast-v58a-',dir=tmp));pre=Path(os.environ['PDP10_PREFIX'])/'bin'
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
    else:native_limits(work,gcc,das)


if __name__=='__main__':main()
