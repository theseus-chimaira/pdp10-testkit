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
expected = [1, 2, 3, 4, 5, 6, 7, 7, 7, 8, 8, 9, 8, 8, 9, 10]
if payload != expected:
    raise SystemExit('DAS .ifdef/.ifndef/.rept output mismatch: %r' % payload)
print('DAS source-order conditional and bounded repetition contract passed')
