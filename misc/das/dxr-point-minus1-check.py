#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1


def six(s):
    w = 0
    for ch in s:
        w = (w << 6) | (ord(ch) - 32)
    return w & HALF


def word(lh, rh):
    return ((lh & HALF) << 18) | (rh & HALF)


def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('bad length')
    return [int.from_bytes(data[i:i + 8], 'little') & MASK
            for i in range(0, len(data), 8)]


# DXR header, three text words, literal word, relocation bitmap.
# POINT 6,target,-1 encodes P=36 (044 octal), S=6 and target address 2.
exp = [
    word(six('DXR'), 0),
    word(4, 0),
    (0o200 << 27) | (5 << 23) | 3,
    (0o254 << 27) | (4 << 23),
    0,
    (0o44 << 30) | (6 << 24) | 2,
    0o440000000000,
]
got = read_words(sys.argv[1])
if got != exp:
    print('DXR POINT -1 literal mismatch', file=sys.stderr)
    print('expected:', ['%012o' % x for x in exp], file=sys.stderr)
    print('got:     ', ['%012o' % x for x in got], file=sys.stderr)
    raise SystemExit(1)
print('DAS POINT -1 literal contract passed')
