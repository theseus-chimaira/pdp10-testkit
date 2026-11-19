#!/usr/bin/env python3
"""Generate and verify 1000 original-LCG PDP10 9/18/36 divmod oracles.

No expected values derive from guest compiler output. C source and
independent expected rolling signatures are generated using Python
unbounded integers and explicit 36-bit seed overflow semantics.
"""
from pathlib import Path
import argparse
import sys

ROOT=Path(__file__).resolve().parents[1]
DEST=ROOT/'tests/semantic/regression/pdp10-arith-random-1000-v1.c'
MASK=(1<<36)-1
WIDTHS=(('u9','unsigned char',9,False),('s9','signed char',9,True),
        ('u18','unsigned short',18,False),('s18','signed short',18,True),
        ('u36','unsigned long',36,False),('s36','signed long',36,True))


def original_rng_oracle():
    seed=47114711
    def get_rand():
        nonlocal seed
        seed=(seed*1103515245+12345)&MASK
        return seed>>8
    def make_bits():
        bits=0
        count=0
        while True:
            rnd=get_rand()
            n=(rnd>>1)%16
            count+=n
            if n==0:
                return bits
            bits=((bits<<n)|(((1<<n)-1) if rnd&1 else 0))&MASK
            if count>9*4+6:
                return bits
    signatures={key:0 for key,_,_,_ in WIDTHS}
    skipped={key:0 for key,_,_,_ in WIDTHS}
    first_pairs=[]
    for i in range(1000):
        a,b=make_bits(),make_bits()
        if i < 4:
            first_pairs.append((a,b))
        for key,_,width,signed in WIDTHS:
            mask=(1<<width)-1
            x=a&mask
            y=b&mask
            if signed:
                if x&(1<<(width-1)):x-=(1<<width)
                if y&(1<<(width-1)):y-=(1<<width)
            if y==0 or (signed and x==-(1<<(width-1)) and y==-1):
                skipped[key]+=1
                signatures[key]=((signatures[key]*33)^0o12345)&MASK
                continue
            q=abs(x)//abs(y)
            if (x<0)!=(y<0):q=-q
            r=x-q*y
            h=signatures[key]
            for n in (q,r):h=((h*33)^(n&MASK))&MASK
            signatures[key]=h
    return signatures,skipped,first_pairs


def generate():
    original=(ROOT/'tests/todo/generic/arith-rand.c').read_text(encoding='ascii')
    for snippet in ('static unsigned long seed = 47114711',
                    'seed * 1103515245 + 12345',
                    'n_bits = (ran >> 1) % 16',
                    'if (tot_bits > 8 * sizeof (long) + 6)',
                    'for (i = 0; i < 1000; i++)'):
        if snippet not in original:
            raise ValueError('Original random arithmetic source changed: '+snippet)
    sig,skip,first_pairs=original_rng_oracle()
    lines=['/* Reconstructed original 1000-iteration arithmetic stress, 36-bit PDP10.',' * Original simple_rand LCG and random_bitstring generation preserved',' * with unsigned 36-bit wrap and nine-bit char native widths.',' * Host Python independently derives six 36-bit rolling signatures',' * from 1000 x/y pairs, signed truncation-toward-zero q and remainder.',' * Exclude zero divisors and MIN/-1, which are undefined in C.',' * The historical 8*sizeof(long) termination assumes eight-bit bytes;',' * correct target termination is 9*sizeof(long)+6. No fake runtime.',' */','extern void abort(void);','volatile unsigned int fail_id;',
           'static volatile unsigned long seed_v1 = 47114711UL;',
           'static unsigned long hash_u9_v1, hash_s9_v1;',
           'static unsigned long hash_u18_v1, hash_s18_v1;',
           'static unsigned long hash_u36_v1, hash_s36_v1;','',
           'static unsigned long','rand_v1(void)','{',
           '    unsigned long next = seed_v1 * 1103515245UL + 12345UL;',
           '    seed_v1 = next;', '    return next >> 8;', '}','',
           'static unsigned long','bits_v1(void)','{',
           '    unsigned long x = 0UL;',
           '    unsigned long ran;',
           '    int n_bits;',
           '    int total = 0;',
           '    for (;;) {',
           '        ran = rand_v1();',
           '        n_bits = (int)((ran >> 1) % 16UL);',
           '        total += n_bits;',
           '        if (n_bits == 0)',
           '            return x;',
           '        x <<= n_bits;',
           '        if (ran & 1UL)',
           '            x |= (1UL << n_bits) - 1UL;',
           '        if (total > 9 * (int)sizeof(long) + 6)',
           '            return x;',
           '    }','}','',
           'static unsigned long','mix_v1(unsigned long hash, unsigned long value)',
           '{','    return (hash * 33UL) ^ value;','}','']
    for key,ctype,width,signed in WIDTHS:
        lines+=['static void','check_'+key+'_v1(unsigned long x, unsigned long y)',
                '{', '    volatile '+ctype+' a = ('+ctype+')x;',
                '    volatile '+ctype+' b = ('+ctype+')y;',
                '    '+ctype+' quotient;', '    '+ctype+' remainder;',
                '    if (b == 0'+('' if signed else 'U')+
                (' || (a == ('+ctype+')(1UL << '+str(width-1)+') && b == -1)' if signed else '')+') {',
                '        hash_'+key+'_v1 = mix_v1(hash_'+key+'_v1, 012345UL);',
                '        return;', '    }',
                '    quotient = a / b;', '    remainder = a % b;',
                '    hash_'+key+'_v1 = mix_v1(hash_'+key+'_v1, (unsigned long)quotient);',
                '    hash_'+key+'_v1 = mix_v1(hash_'+key+'_v1, (unsigned long)remainder);',
                '}','']
    lines+=['int','main(void)','{', '    unsigned long x, y;',
            '    int i;',
            '    if (sizeof(char) != 1 || sizeof(short) != 2 ||',
            '        sizeof(long) != 4) {','        fail_id = 1;',
            '        abort();', '    }',
            '    for (i = 0; i < 1000; i++) {',
            '        x = bits_v1();',
            '        y = bits_v1();']
    for i,(a,b) in enumerate(first_pairs):
        lines+=['        if (i == '+str(i)+' && (x != '+str(a)+
                'UL || y != '+str(b)+'UL)) {',
                '            fail_id = 1;',
                '            abort();',
                '        }']
    for key,_,_,_ in WIDTHS:
        lines.append('        check_'+key+'_v1(x, y);')
    lines+=['    }']
    for index,(key,_,_,_) in enumerate(WIDTHS,2):
        lines+=['    /* '+key+': independently skipped '+str(skip[key])+' undefined cases. */',
                '    if (hash_'+key+'_v1 != '+str(sig[key])+'UL) {',
                '        fail_id = '+str(index)+';', '        abort();', '    }']
    lines+=['    return 0;', '}','']
    return '\n'.join(lines)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write',action='store_true')
    args=parser.parse_args()
    text=generate()
    if args.write:
        DEST.write_text(text,encoding='ascii')
    if not DEST.is_file() or DEST.read_text(encoding='ascii')!=text:
        print('ERROR: Original 1000-case native divmod oracle changed',file=sys.stderr)
        return 1
    print('P1 random divmod 1000-case generator: PASS signatures',
          original_rng_oracle()[0])
    return 0

if __name__=='__main__':
    sys.exit(main())
