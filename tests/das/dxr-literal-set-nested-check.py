#!/usr/bin/env python3
import sys
MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('bad DXR length')
    return [int.from_bytes(data[i:i + 8], 'little') & MASK
            for i in range(0, len(data), 8)]

def mem(op, ac, y):
    return ((op & 0o777) << 27) | ((ac & 0o17) << 23) | (y & HALF)

words = read_words(sys.argv[1])
image_words = words[1] >> 18
if image_words != 7:
    raise SystemExit('nested .set literal image size mismatch')
image = words[2:9]
expected = [
    mem(0o200, 1, 3),
    mem(0o200, 3, 5),
    mem(0o254, 4, 0),
    mem(0o200, 2, 4),
    1,
    mem(0o200, 4, 6),
    2,
]
if image != expected:
    print('nested .set literal mismatch', file=sys.stderr)
    print('expected:', ['%012o' % x for x in expected], file=sys.stderr)
    print('got:     ', ['%012o' % x for x in image], file=sys.stderr)
    raise SystemExit(1)
