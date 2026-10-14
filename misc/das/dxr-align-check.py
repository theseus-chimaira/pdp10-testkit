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
# text: 1, pad, 2 = 3 words. Data begins at its own location 0; after
# one data word, .align 4 pads its section location to four words. BSS
# similarly aligns its section location independently.
if (words[1] >> 18) != 8 or (words[1] & HALF) != 3:
    raise SystemExit('unexpected aligned image/BSS size')
if words[2:10] != [1, 0, 2, 3, 0, 0, 0, 4]:
    print(['%012o' % x for x in words[2:10]], file=sys.stderr)
    raise SystemExit('DAS .align padding mismatch')
print('DAS .align power-of-two byte alignment contract passed')
