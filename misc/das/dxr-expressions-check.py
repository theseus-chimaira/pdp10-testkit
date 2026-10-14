#!/usr/bin/env python3
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: dxr-expressions-check.py file.dxr')
raw = open(sys.argv[1], 'rb').read()
if len(raw) % 8:
    raise SystemExit('bad DXR byte length')
mask = (1 << 36) - 1
words = [int.from_bytes(raw[i:i+8], 'little') & mask
         for i in range(0, len(raw), 8)]
expected = [0o16, 0o24, 0o100, 0o33, 0o33, mask,
            mask - 1, mask, mask, 0, 5]
if words[2:2 + len(expected)] != expected:
    print('DAS expression precedence mismatch', file=sys.stderr)
    print('got:', ' '.join('%012o' % w for w in words[2:2+len(expected)]), file=sys.stderr)
    raise SystemExit(1)
print('DAS expression precedence contract passed')
