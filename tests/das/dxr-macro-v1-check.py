#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1

raw = open(sys.argv[1], 'rb').read()
if len(raw) % 8:
    raise SystemExit('bad DXR length')
words = [int.from_bytes(raw[i:i + 8], 'little') & MASK
         for i in range(0, len(raw), 8)]
count = words[1] >> 18
payload = words[2:2 + count]
expected = [
    1, 1, 2, 2,
    3, 3, 37, 6,
    4, 4, 47, 10,
    5, 5, 6, 6,
    5, 5, 6, 6,
    11, 0, 13,
]
if payload != expected:
    raise SystemExit('DAS .macro expansion mismatch: %r' % payload)
print('DAS bounded GAS-style macro expansion contract passed')
