#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

def read_words(path):
    raw = open(path, 'rb').read()
    if len(raw) % 8:
        raise SystemExit('bad DXR length')
    return [int.from_bytes(raw[i:i + 8], 'little') & MASK
            for i in range(0, len(raw), 8)]

words = read_words(sys.argv[1])
if (words[1] >> 18) != 12 or (words[1] & HALF) != 5:
    raise SystemExit('unexpected .org image/BSS size')
if words[2:14] != [1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 4]:
    print(['%012o' % x for x in words[2:14]], file=sys.stderr)
    raise SystemExit('DAS .org zero-fill mismatch')
print('DAS .org/.p2align/.zero location contract passed')
