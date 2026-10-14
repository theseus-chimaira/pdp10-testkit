#!/usr/bin/env python3
import sys
MASK = (1 << 36) - 1

def six(s):
    w = 0
    for ch in s:
        w = (w << 6) | (ord(ch) - 32)
    return w & MASK

def word(lh, rh):
    return ((lh & 0o777777) << 18) | (rh & 0o777777)

def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('DXR host container length is not a word multiple')
    out = []
    for i in range(0, len(data), 8):
        out.append(int.from_bytes(data[i:i+8], 'little') & MASK)
    return out

exp = [
    word(six('DXR'), 0),
    word(4, 4),
    0o201040000003,
    0o260740000002,
    0o263740000000,
    six('HELLO '),
    0o600000000000,
]
got = read_words(sys.argv[1])
if got != exp:
    print('DXR binary mismatch', file=sys.stderr)
    print('expected:', ['%012o' % x for x in exp], file=sys.stderr)
    print('got:     ', ['%012o' % x for x in got], file=sys.stderr)
    raise SystemExit(1)
