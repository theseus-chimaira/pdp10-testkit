#!/usr/bin/env python3
"""Check widened exact-width symbolic addends in data and code literals."""
import argparse
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('link', ROOT/'tools/test-kl10b-extended-link-v56m.py')
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
MASK = (1 << 30) - 1


def generate(negative):
    lines = []
    expected = {}
    calls = []
    code_expected = []
    defs = ['.text', '.entry start', '.globl start,done', '.extern main',
            'start:', ' move 17,[GIW 4001000]', ' pushj 17,@[GIW main]',
            ' movei 6,765', 'done: halt 0', '.data']
    displacements = ([-(1 << 30)+(1 << 20), -(1 << 29)-2, -(1 << 29)-1,
                      -(1 << 29)] if negative else
                     [(1 << 29)-1, 1 << 29, (1 << 29)+1, (1 << 30)-(1 << 20)])
    for width in (16,32):
        lines.append(f'typedef unsigned int u{width} __attribute__((size ({width})));')
        vals = []
        want = []
        for prefix in range(1,5):
            base = f'b{width}_{prefix}'
            lines.append(f'extern struct r{width}_{prefix} {{ unsigned pre:{prefix}; u{width} a[9]; }} __attribute__((packed)) {base};')
            defs.extend((f'.globl {base}', f'{base}: .long 0'))
            for slot in range(9):
                start = prefix+width*slot
                for d in displacements:
                    n0 = (36*d-start+width-1)//width
                    for n in range(n0,n0+3):
                        word, bit = divmod(start+n*width,36)
                        if word != d:
                            continue
                        step = 1 if n > 0 else -1
                        exprs = (f'&{base}.a[{slot}]+({n}L)',
                                 f'&{base}.a[{slot}]-({-n}L)',
                                 f'(&{base}.a[{slot}]+({n-step}L))+({step}L)')
                        # Cross the former signed boundary and return.
                        if abs(d) == (1 << 29):
                            exprs += (f'(&{base}.a[{slot}]+({n+9*step}L))-({9*step}L)',)
                        at = len(vals)
                        vals.extend(exprs)
                        want.extend(((base,bit+1,word),)*len(exprs))
                        if prefix == 1 and slot == 0 and n == n0:
                            for k,expr in enumerate(exprs[:3]):
                                fun=f'f{width}_{len(calls)}'
                                lines.append(f'__attribute__((noinline)) u{width} *{fun}(void) {{ return {expr}; }}')
                                calls.append(f'if ({fun}()!=p{width}[{at+k}]) return {len(calls)+1};')
                                code_expected.append((base,bit+1,word))
        name=f'p{width}'
        expected[name]=want
        lines.append(f'u{width} * volatile {name}[] = {{\n'+',\n'.join(vals)+'\n};')
    lines.append('volatile int result;\nint main(void) {\n'+'\n'.join(calls)+'\nresult=765; return 0; }')
    return '\n'.join(lines)+'\n','\n'.join(defs)+'\n',expected,code_expected


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--baseline',action='store_true')
    args=parser.parse_args()
    tmp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp')
    tmp.mkdir(parents=True,exist_ok=True)
    work=Path(tempfile.mkdtemp(prefix='pdp10-wide-packed-symbolic-v57w-',dir=tmp))
    pre=Path(os.environ['PDP10_PREFIX'])/'bin'
    gcc=Path(os.environ.get('PDP10_GCC_OVERRIDE') or pre/'pdp10-dec-none-gcc')
    das=Path(os.environ.get('DOBJ2_TOOLS') or pre)/'das'
    ld=Path(os.environ.get('P10X_LINKER') or pre/'dlink')
    lib=subprocess.check_output([gcc,'-print-libgcc-file-name'],text=True).strip()
    for negative in (False,True):
        key='negative' if negative else 'positive'
        source,defs,expected,code_expected=generate(negative)
        src=work/(key+'.c')
        src.write_text(source,encoding='ascii')
        ds=work/(key+'-defs.s')
        ds.write_text(defs,encoding='ascii')
        do=ds.with_suffix('.dobj')
        subprocess.run([das,'-C','-O',do,ds],check=True)
        for opt in (('O0',) if args.baseline else ('O0','O1','O2','Os')):
            case=work/(key+'-'+opt)
            case.mkdir()
            s=case/'test.s';o=case/'test.dobj';log=case/'compile.log'
            im=case/'test.p10x';mp=case/'test.map'
            with log.open('w') as out:
                ret=subprocess.run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s],stdout=out,stderr=subprocess.STDOUT,timeout=90)
                if args.baseline:
                    assert ret.returncode and 'global pointer relocation addend out of signed 30-bit range' in log.read_text(),log
                    print('BASELINE rejected',key,opt,work,flush=True)
                    continue
                ret.check_returncode()
                subprocess.run([das,'-C','-O',o,s],stdout=out,stderr=subprocess.STDOUT,check=True,timeout=90)
            v,sections,symbols,rel,_=m.obj.read_object(o)
            assert v==2
            names={n:(sec,off) for n,k,sec,off in symbols}
            total=0
            for name,entries in expected.items():
                sec,off=names[name]
                assert sec==2
                for i,(target,tag,add) in enumerate(entries):
                    actual=(sections[sec][off+i],rel.get((sec,off+i)))
                    want=(tag<<30,(6,0,target,add))
                    assert actual==want,(key,opt,name,i,actual,want,work)
                    total+=1
            # Every distinct expected code literal must carry the exact
            # independent selector and displacement; reuse is allowed.
            observed={(r[2],sections[sec][off]>>30,r[3])
                      for (sec,off),r in rel.items() if sec==1 and r[0]==6}
            assert set(code_expected)<=observed,(key,opt,set(code_expected)-observed,work)
            data='7777001000' if negative else '2001000'
            with log.open('a') as out:
                subprocess.run([ld,'--extended','1001000',data,'3001000','-o',im,'-M',mp,do,o,lib],stdout=out,stderr=subprocess.STDOUT,check=True,timeout=60)
            _,ranges,words=m.read_image(im)
            syms={n:int(a,8) for n,a in (l.split() for l in mp.read_text().splitlines())}
            db,dc=ranges[1];tc=ranges[0][1]
            for name,entries in expected.items():
                off=syms[name]-db
                assert 0<=off<dc
                for i,(target,tag,add) in enumerate(entries):
                    address=syms[target]+add
                    assert 0<=address<=MASK
                    assert words[tc+off+i]==(tag<<30)|address,(name,i,work)
            for (sec,off),r in rel.items():
                if sec==1 and r[0]==6 and (r[2],sections[sec][off]>>30,r[3]) in code_expected:
                    assert words[off+len(m.obj.read_object(do)[1][1])]==(sections[sec][off] & ~MASK)|(syms[r[2]]+r[3]),(key,opt,off,work)
            print('PASS',key,opt,total,'data words and',len(set(code_expected)),'code relocations',work,flush=True)
            if not negative:
                m.execute(im,case,{syms['result']:765},syms['done'],steps=1000000)
    if not args.baseline:
        # Check the largest displacement magnitudes at object level, then
        # require an explicit diagnostic beyond the architectural range.
        for width in (16,32):
            for d in (MASK,-MASK,MASK+1,-MASK-1):
                count=(36*d-5+width-1)//width
                word,bit=divmod(5+count*width,36)
                assert word==d
                stem=work/f'limit-{width}-{d}'
                src=stem.with_suffix('.c')
                src.write_text(f'typedef unsigned int u __attribute__((size ({width})));\nextern struct r {{ unsigned pre:5; u a[9]; }} __attribute__((packed)) b;\nu *p=b.a+({count}L);\n',encoding='ascii')
                for opt in ('O0','O1','O2','Os'):
                    s=work/f'limit-{width}-{d}-{opt}.s';o=s.with_suffix('.dobj');log=s.with_suffix('.log')
                    ret=subprocess.run([gcc,'-march=kl10','-mextended','-'+opt,'-S',src,'-o',s],capture_output=True,text=True,timeout=60)
                    log.write_text(ret.stdout+ret.stderr)
                    if abs(d)>MASK:
                        assert ret.returncode and 'global pointer relocation addend exceeds address space' in ret.stderr,(log,ret.stderr)
                        print('PASS impossible displacement rejected',width,d,opt,flush=True)
                    else:
                        ret.check_returncode()
                        subprocess.run([das,'-C','-O',o,s],check=True,timeout=60)
                        _,sections,symbols,rel,_=m.obj.read_object(o)
                        _,_,sec,off=next(row for row in symbols if row[0]=='p')
                        assert rel[sec,off]==(6,0,'b',d) and sections[sec][off]==(bit+1)<<30,(width,d,opt,work)
                        print('PASS extreme displacement',width,d,opt,flush=True)
    print('PASS wide packed symbolic profiles',work,flush=True)


if __name__=='__main__':
    main()
