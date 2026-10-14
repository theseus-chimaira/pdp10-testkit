#!/usr/bin/env python3
import sys
MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('DXR host container length is not a word multiple')
    return [int.from_bytes(data[i:i + 8], 'little') & MASK
            for i in range(0, len(data), 8)]

def mem(op, ac, y):
    return ((op & 0o777) << 27) | ((ac & 0o17) << 23) | (y & HALF)

words = read_words(sys.argv[1])
image_words = words[1] >> 18
if image_words != 11:
    raise SystemExit('literal .set image size mismatch: got %d expected 11' %
                     image_words)
image = words[2:2 + image_words]
expected = [
    mem(0o200, 1, 7),
    mem(0o200, 2, 8),
    mem(0o200, 3, 8),
    mem(0o200, 4, 9),
    mem(0o200, 5, 10),
    mem(0o254, 4, 0),
    mem(0o254, 4, 0),
    1,
    2,
    5,
    6,
]
if image != expected:
    print('literal .set source-order mismatch', file=sys.stderr)
    print('expected:', ['%012o' % x for x in expected], file=sys.stderr)
    print('got:     ', ['%012o' % x for x in image], file=sys.stderr)
    raise SystemExit(1)
reloc = words[2 + image_words]
expected_reloc = 0
for off in (0, 1, 2, 3, 4, 9, 10):
    expected_reloc |= 1 << (35 - off)
if reloc != expected_reloc:
    raise SystemExit('literal .set relocation bitmap mismatch')
