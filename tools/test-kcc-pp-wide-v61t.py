#!/usr/bin/env python3
"""Independent 36/71-bit preprocessing arithmetic oracle, host and target.

The native fixture uses the exact evaluator region of ccpp.c with the
compiler's own token structures. Only token input is supplied by the test;
this is not a full native KCPP guest run.
"""
import os
from pathlib import Path
import random
import re
import subprocess
import tempfile

from compiler_negative_policy_v1 import check_kcc_rejection

ROOT = Path(__file__).resolve().parents[1]
KCCROOT = Path(os.environ.get('KCC_ROOT') or ROOT.parent / 'kcc').resolve()
BIN = Path(os.environ['PDP10_PREFIX']) / 'bin'
OPS = {'(': 'T_LPAREN', ')': 'T_RPAREN', '?': 'Q_QUERY', ':': 'T_COLON',
       '+': 'Q_PLUS', '-': 'Q_MINUS', '*': 'Q_MPLY', '/': 'Q_DIV', '%': 'Q_MOD',
       '<<': 'Q_LSHFT', '>>': 'Q_RSHFT', '<': 'Q_LESS', '>': 'Q_GREAT',
       '<=': 'Q_LEQ', '>=': 'Q_GEQ', '==': 'Q_EQUAL', '!=': 'Q_NEQ',
       '&': 'Q_ANDT', '^': 'Q_XORT', '|': 'Q_OR', '&&': 'Q_LAND', '||': 'Q_LOR',
       '!': 'Q_NOT', '~': 'Q_COMPL'}
TOKENS = re.compile(r"0[xX][0-9a-fA-F]+[uUlL]*|[0-9]+[uUlL]*|<<|>>|<=|>=|==|!=|&&|\|\||[()+\-*/%<>&^|!~?:]")


def corpus(width, count):
    rng = random.Random(61071+width)
    mask = (1 << width)-1
    signed_max = (1 << (width-1))-1
    suffix = 'ULL' if width == 71 else 'UL'
    ss = 'LL' if width == 71 else 'L'
    def u(x):
        return hex(x & mask)+suffix
    def s(x):
        # Avoid an unrepresentable positive signed literal for INTMAX_MIN.
        if x == -signed_max-1:
            return '(-'+str(signed_max)+ss+'-1)'
        return '('+str(x)+ss+')'
    cases = [
        f'(~0{suffix}) == {u(mask)}',
        f'(0{suffix}-1) == {u(mask)}',
        f'(1{suffix} << {width-1}) == {u(1 << (width-1))}',
        f'(-1{ss} >> {width-1}) == -1',
        f'(-1 < 0{suffix}) == 0',
        f'((1 ? -1 : 0{suffix}) < 0) == 0',
        f'((0 ? 0{suffix} : -1) < 0) == 0',
        f'((1 ? 1 : 1{suffix}/0) == 1)',
        '(0 && (1/0)) == 0', '1 || (1/0)',
        f'(-9{ss}/4) == -2', f'(-9{ss}%4) == -1',
        f'(9{ss}%-4) == 1',
        f'({u(mask)} / 3) == {u(mask//3)}',
        f'({u(mask)} % 3) == {u(mask%3)}',
        f'({u(mask)} / {u((1 << (width-1))+1)}) == 1',
        f'({u(mask)} % {u((1 << (width-1))+1)}) == {u((1 << (width-1))-2)}',
        f'({u(mask)} + 1) == 0',
        f'((1{suffix} << {width-1}) >> {width-1}) == 1',
        f'({s(-signed_max-1)} >> {width-1}) == -1',
    ]
    for n in (0, 1, 17, 18, 34, 35, 36, 64, 69, 70):
        if n >= width:
            continue
        x = rng.getrandbits(width)
        y = -rng.randrange(1, signed_max+1)
        cases.extend((f'({u(x)} << {n}) == {u(x << n)}',
                      f'({u(x)} >> {n}) == {u(x >> n)}',
                      f'({s(y)} >> {n}) == {s(y >> n)}'))
    for _ in range(count):
        a, b = rng.getrandbits(width), rng.getrandbits(width) or 1
        for op, result in (('+', a+b), ('-', a-b), ('*', a*b),
                           ('/', a//b), ('%', a%b), ('&', a&b),
                           ('|', a|b), ('^', a^b)):
            cases.append(f'({u(a)} {op} {u(b)}) == {u(result)}')
        cases.extend((f'({u(a)} < {u(b)}) == {int(a<b)}',
                      f'({u(a)} >= {u(b)}) == {int(a>=b)}'))
        # Signed division truncates toward zero, unlike Python //.
        x = rng.randint(-signed_max, signed_max)
        y = rng.randint(-signed_max, signed_max) or 1
        q = abs(x)//abs(y)*(-1 if (x<0)!=(y<0) else 1)
        cases.extend((f'({s(x)} / {s(y)}) == {s(q)}',
                      f'({s(x)} % {s(y)}) == {s(x-q*y)}',
                      f'({s(x)} < {s(y)}) == {int(x<y)}'))
    return cases


def compile_host(work, mode, cases, negative=False):
    source = work/'host.c'
    if negative:
        source.write_text(cases, encoding='ascii')
    else:
        text = '\n'.join(f'#if !({expr})\n#error case_{i}\n#endif' for i,expr in enumerate(cases))
        if mode != 'c89':
            text += '\n#if __LONG_LONG_MAX__ != 1180591620717411303423LL\n#error limit\n#endif\n'
        source.write_text(text+'\nint main(void) {return 0;}\n', encoding='ascii')
    result = subprocess.run([str(BIN/'kcc'), '-P'+mode, '-S', '-v=nostats', '-x=pdp6',
                             '-R=unit', str(source)], cwd=work, capture_output=True,
                            text=True, timeout=30)
    if negative:
        assert check_kcc_rejection(result.returncode,result.stdout+result.stderr) is None, result.stdout+result.stderr
    else:
        assert not result.returncode, (mode,result.stdout+result.stderr)


def native_source(cases):
    source = (KCCROOT/'ccpp.c').read_text(encoding='ascii')
    start = source.index('static PPTOK *\nppifskip(')
    end = source.index('/* IFTEST',start)
    evaluator = source[start:end]
    lines = ['#include "cc.h"', '#include "cclex.h"', '#define tokn2p(n) (n)',
             'int clevkcc, cstdmode;', 'volatile int __test_exit;', evaluator,
             'struct spec { int kind; char *value; };',
             'static const struct spec specs[] = {']
    max_tokens = 0
    for expr, width in cases:
        ts = TOKENS.findall(expr)
        assert ''.join(ts) == ''.join(expr.split()), expr
        max_tokens = max(max_tokens,len(ts))
        for t in ts:
            lines.append('{'+OPS.get(t,'T_ICONST')+','+('0' if t in OPS else '"'+t+'"')+'},')
        lines.append('{0,"'+str(width)+'"},')
    lines.extend(['{0,0}};',f'static PPTOK tokens[{max_tokens}];',
        'int main(void) {', '  int i=0, n, bad, test=0; PPTOK *p; PPVAL v;',
        '  while (specs[i].kind) {',
        '    n=0; while (specs[i].kind) {',
        '      tokens[n].pt_typ=specs[i].kind; tokens[n].pt_val.cp=specs[i].value;',
        '      tokens[n].pt_nxt=&tokens[n+1]; ++n; ++i;',
        '    }',
        '    tokens[n-1].pt_nxt=0; clevkcc=0;',
        "    cstdmode=specs[i].value[0]=='7' ? CSTD_C99 : CSTD_C89; ++i;",
        '    bad=0; p=tokens; ppifcond(&p,1,&bad,&v); ++test;',
        '    if (bad || ppifskip(p) || !pptruth(&v)) return test;',
        '  }', '  return 0;', '}'])
    return '\n'.join(lines)+'\n'


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home()/'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, PATH=str(BIN)+os.pathsep+os.environ.get('PATH',''))
    work = Path(tempfile.mkdtemp(prefix='kcc-pp-wide-v61t.',dir=tmp))
    try:
        wide = corpus(71,12)
        narrow = corpus(36,8)
        for mode in ('gnu89','gnu99','c99','c89'):
            compile_host(work,mode,narrow if mode == 'c89' else wide)
        for mode in ('gnu89','gnu99','c99'):
            for expr in ('1ULL<<71','1ULL/0','0x800000000000000000ULL', '1ULL>>-1'):
                compile_host(work,mode,'#if '+expr+'\nint x;\n#endif\n',True)
        for expr in ('1UL<<36','0x1000000000UL'):
            compile_host(work,'c89','#if '+expr+'\nint x;\n#endif\n',True)
        print('PASS: host preprocessing expression checks',len(wide)*3+len(narrow), 'and 14 rejections',flush=True)
        native_cases = [(x,71) for x in corpus(71,2)] + [(x,36) for x in corpus(36,1)]
        source = work/'native.c'
        source.write_text(native_source(native_cases),encoding='ascii')
        for cpu in ('pdp6','ka10','ki10','ks10'):
            for opt in ([],['-n']):
                tag = cpu+('-noopt' if opt else '-opt')
                asm = work/(tag+'.s')
                subprocess.run([str(BIN/'kcc'),'-Pgnu99','-S','-v=nostats','-x='+cpu,
                    '-m=gas','-DHOST_DAIMOS=1','-DHOST_UNIX=0','-I'+str(KCCROOT),
                    '-I'+str(KCCROOT/'self/include'),'-H'+str(KCCROOT/'self/include'),
                    *opt,'-o',str(asm),str(source)],cwd=work,check=True,timeout=40)
                subprocess.run([str(BIN/'p10run'),'--machine',cpu,'--mode','deposit',
                    '--exec-mode','step','--step-limit','100000000','--timeout','45',
                    '--workdir',str(work/tag),'--name',tag,'--expect','__test_exit=0',
                    str(ROOT/'misc/kcc-regression/semantic-crt0.s'),str(asm)],
                    cwd=work,env=env,check=True,timeout=60,stdout=subprocess.DEVNULL)
                print('PASS:',tag,len(native_cases),'native evaluator expressions',flush=True)
    except BaseException:
        print('Failure evidence:',work,flush=True)
        raise
    else:
        import shutil
        shutil.rmtree(work)


if __name__ == '__main__':
    main()
