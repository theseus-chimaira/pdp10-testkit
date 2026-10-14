#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1


def six(s):
    w = 0
    for ch in s:
        w = (w << 6) | (ord(ch) - 32)
    return w & HALF


def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('DXR host container length is not a word multiple')
    return [int.from_bytes(data[i:i + 8], 'little') & MASK
            for i in range(0, len(data), 8)]


if len(sys.argv) != 2:
    raise SystemExit('usage: dxr-gcc-kl10-data-check.py file')
words = read_words(sys.argv[1])
if len(words) < 9:
    raise SystemExit('DXR too short')
magic = words[0] >> 18
image_words = words[1] >> 18
reloc_words = (image_words + 35) // 36
if magic != six('DXR'):
    raise SystemExit('bad DXR magic')
if image_words != 6:
    raise SystemExit('image word count mismatch: got %o expected 6' % image_words)
image = words[2:2 + image_words]
expected = [
    (1 << 34) | (2 << 30) | int('123456701', 8),
    1,
    0,
    int('010040000000', 8),
    5,
    0,
]
if image != expected:
    print('KL10 GCC data image mismatch', file=sys.stderr)
    print('expected:', ['%012o' % x for x in expected], file=sys.stderr)
    print('got:     ', ['%012o' % x for x in image], file=sys.stderr)
    raise SystemExit(1)
reloc = words[2 + image_words:]
if len(reloc) != reloc_words or reloc != [1 << (35 - 4)]:
    raise SystemExit('GIW relocation bitmap mismatch')
print('DAS KL10 GCC data syntax contract passed')
