#!/usr/bin/env python3
import sys
HALF = (1 << 18) - 1
MASK36 = (1 << 36) - 1

def word(op, ac, y, ind=0, xr=0):
    return (((op & 0o777) << 27) |
            ((ac & 0o17) << 23) |
            ((ind & 1) << 22) |
            ((xr & 0o17) << 18) |
            (y & HALF)) & MASK36

def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('bad DXR byte count')
    out = []
    for i in range(0, len(data), 8):
        v = 0
        for b in reversed(data[i:i + 8]):
            v = (v << 8) | b
        out.append(v & MASK36)
    return out

w = read_words(sys.argv[1])
text = w[2:]
expected = [
    word(0o255, 0o4, 7),
    word(0o255, 0o4, 7),
    word(0o255, 0o2, 7),
    word(0o255, 0o2, 7),
    word(0o255, 0o10, 7),
    word(0o255, 0o10, 7),
    word(0o255, 0o4, 8),
    word(0o263, 0o17, 0),
    word(0o344, 0o1, 9),
]
if text[:len(expected)] != expected:
    print('DXR JFCL alias mismatch', file=sys.stderr)
    print('expected:', [oct(x) for x in expected], file=sys.stderr)
    print('got:     ', [oct(x) for x in text[:len(expected)]], file=sys.stderr)
    raise SystemExit(1)
