#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1

def read_words(path):
    raw = open(path, 'rb').read()
    if len(raw) % 8:
        raise SystemExit('bad DXR length')
    return [int.from_bytes(raw[i:i + 8], 'little') & MASK
            for i in range(0, len(raw), 8)]

words = read_words(sys.argv[1])
if (words[1] >> 18) != 3 or words[2:5] != [1, 2, 3]:
    raise SystemExit('DAS conditional assembly output mismatch')
print('DAS bounded .if/.else/.endif contract passed')
