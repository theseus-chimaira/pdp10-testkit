#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('bad host container length')
    return [int.from_bytes(data[i:i + 8], 'little') & MASK
            for i in range(0, len(data), 8)]

def word(lh, rh):
    return ((lh & HALF) << 18) | (rh & HALF)

image = [
    1,
    0, 0,
    0,
    2,
    0, 0,
    0o030776000000,
    word(0o001100, 12),
    0, 0, 0,
    4,
    5,
]
got = read_words(sys.argv[1])
if len(got) != 2 + len(image) + 1:
    raise SystemExit('assignment-directive image size mismatch')
if got[2:2 + len(image)] != image:
    print('assignment-directive word mismatch', file=sys.stderr)
    print('expected:', ['%012o' % x for x in image], file=sys.stderr)
    print('got:     ', ['%012o' % x for x in got[2:2 + len(image)]], file=sys.stderr)
    raise SystemExit(1)
print('DAS assignment/directive source-order contract passed')
