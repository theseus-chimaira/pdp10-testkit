#!/usr/bin/env python3
import sys
MASK = (1 << 36) - 1
raw = open(sys.argv[1], 'rb').read()
if len(raw) % 8:
    raise SystemExit('bad DXR length')
words = [int.from_bytes(raw[i:i + 8], 'little') & MASK
         for i in range(0, len(raw), 8)]
count = words[1] >> 18
image = words[2:2 + count]
expected = [0o322040000002, 0o201100000001,
            0o321140000004, 0o254000000005,
            0o201200000002, 0]
if image != expected:
    raise SystemExit('DAS JUMP/JRST fold mismatch: %r' % image)
print('DAS conditional JUMP/JRST fold and labeled-entry barrier contract passed')
