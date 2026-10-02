#!/usr/bin/env python3
import sys

MASK36 = (1 << 36) - 1
HALF18 = (1 << 18) - 1

def words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('bad DXR length')
    return [int.from_bytes(data[i:i + 8], 'little') & MASK36
            for i in range(0, len(data), 8)]

def mem(op, ac, y):
    return ((op & 0o777) << 27) | ((ac & 0o17) << 23) | (y & HALF18)

w = words(sys.argv[1])
if len(w) < 7:
    raise SystemExit('short DXR image')
if (w[1] >> 18) != 5:
    raise SystemExit('expected five image words')
expected = [
    mem(0o200, 1, 3),
    2,
    (-int('107654321077', 8)) & MASK36,
    0,
    1,
]
if w[2:7] != expected:
    print('GCC syntax compatibility image mismatch', file=sys.stderr)
    print('expected:', ['%012o' % x for x in expected], file=sys.stderr)
    print('got:     ', ['%012o' % x for x in w[2:7]], file=sys.stderr)
    raise SystemExit(1)
