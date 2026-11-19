#!/usr/bin/env python3
"""Pin original 960416-1.c GNU union/limb algorithm to PDP10 width 36.

Generate exact source prefix (unaltered original df macro and both
functions), followed by 36-bit/71-bit host-integer expected cases.
"""
from pathlib import Path
import argparse
import sys

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'tests/todo/generic/960416-1.c'
DEST=ROOT/'tests/semantic/regression/pdp10-original-wide-karatsuba-v1.c'
W=(1<<36)-1
D=(1<<71)-1
L=(1<<35)-1


def limbs(d,mode):
    h=(d>>35)&W
    l=(d&L)|(((d>>70)&1)<<35)
    if mode=='be':return h,l
    return l,h


def oracle(a,b,mode):
    ah,al=limbs(a,mode)
    bh,bl=limbs(b,mode)
    ad=(ah-al)&W
    bd=(bl-bh)&W
    sign=0
    if bd>bl:
        bd=(-bd)&W
        sign=-1
    lp=(al*bl)&D
    hp=(ah*bh)&D
    dp=((ad*bd)&D)^(sign&D)
    hh=(hp+limbs(hp,mode)[0]+limbs(lp,mode)[0]+limbs(dp,mode)[0])&D
    m=(limbs(lp,mode)[0]+limbs(hp,mode)[1]+limbs(lp,mode)[1]+limbs(dp,mode)[1])&D
    return (limbs(hh,mode)[1]+limbs(m,mode)[1])&W


def generate():
    original=SOURCE.read_text(encoding='ascii')
    prefix=original[:original.index('main ()')]
    for token in ('typedef unsigned long int st;',
                  'typedef unsigned long long dt;',
                  '#define df(f, t)',
                  'df(f_le, t_le)',
                  'df(f_be, t_be)'):
        if token not in prefix:
            raise ValueError('historical full Karatsuba test changed: '+token)
    entries=(('be',1<<35,1<<35),('le',1<<35,1<<35),
             ('be',(0x123<<35)|0x12345,(0x456<<35)|0x67890),
             ('le',(0x123<<35)|0x12345,(0x456<<35)|0x67890),
             ('be',(0x222<<35)|0x33455,(0x19<<35)|0x223344),
             ('le',(0x222<<35)|0x33455,(0x19<<35)|0x223344))
    lines=['','/* PDP10 original 960416-1.c exact Karatsuba function bodies.',' * ABI reference: unsigned long=36, unsigned long long=71,',' * physical continuation word holds low35 and copies top sign bit.',' * Decimal values derive independently from Python modulo 2^36/2^71.',' * Original unsigned arithmetic and return-by-value union are tested;',' * unrelated vacuous 32/32-bit preconditions are removed.',' */',
           'extern void abort(void);',
           'volatile unsigned int fail_id;',
           'static volatile dt first_v1, second_v1;',
           '', 'int','main(void)','{',
           '    t_be be_first_v1, be_second_v1;',
           '    t_le le_first_v1, le_second_v1;',
           '    st actual_v1;']
    for i,(mode,a,b) in enumerate(entries,1):
        exp=oracle(a,b,mode)
        lines+=['    /* Case '+str(i)+': independent '+mode+
                ' oracle '+str(exp)+' (36-bit unsigned). */',
                '    first_v1 = '+str(a)+'ULL;',
                '    second_v1 = '+str(b)+'ULL;']
        if mode=='be':
            lines+=['    be_first_v1.d = first_v1;',
                    '    be_second_v1.d = second_v1;',
                    '    actual_v1 = (st)f_be(be_first_v1, be_second_v1);']
        else:
            lines+=['    le_first_v1.d = first_v1;',
                    '    le_second_v1.d = second_v1;',
                    '    actual_v1 = (st)f_le(le_first_v1, le_second_v1);']
        lines+=['    if (actual_v1 != '+str(exp)+'UL) {',
                '        fail_id = '+str(i)+';',
                '        abort();','    }']
    lines+=['    return 0;', '}','']
    return prefix+'\n'.join(lines)


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--write',action='store_true')
    args=p.parse_args()
    text=generate()
    if args.write:
        DEST.write_text(text,encoding='ascii')
    if not DEST.is_file() or DEST.read_text(encoding='ascii')!=text:
        print('ERROR: historical GNU union Karatsuba oracle mismatch',file=sys.stderr)
        return 1
    print('P1 original wide Karatsuba oracle: PASS')
    return 0

if __name__=='__main__':
    sys.exit(main())
