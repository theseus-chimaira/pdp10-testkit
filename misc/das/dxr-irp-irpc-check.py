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
def six(ch):
    return (ord(ch) - 32) << 30

expected = [1, 2, 3, 4, 5, 6, 7,
            1, 3, 4, 1, 2, 3, 4, 2,
            5, 6, 5, 6, 11, 12,
            six('8'), six(','), six('9'), 10, 1, 2]
if payload != expected:
    raise SystemExit('DAS .irp/.irpc output mismatch: %r' % payload)
print('DAS bounded .irp/.irpc expansion contract passed')
