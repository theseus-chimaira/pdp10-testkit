#!/usr/bin/env python3
import sys

if len(sys.argv) != 2:
    raise SystemExit('usage: dxr-byte-expr-check.py file.dxr')

raw = open(sys.argv[1], 'rb').read()
if len(raw) % 8:
    raise SystemExit('bad DXR byte length')
words = [int.from_bytes(raw[i:i+8], 'little') & ((1 << 36) - 1)
         for i in range(0, len(raw), 8)]
if len(words) < 4:
    raise SystemExit('short DXR')
# 6-bit 3, 6-bit 4, 12-bit 0776, then zero fill.
w0 = (3 << 30) | (4 << 24) | (0o776 << 12)
# Whitespace-separated fields must retain the historical accepted form while
# allowing spaces around the expression operator.
w1 = (3 << 30) | (4 << 24)
if words[2] != w0 or words[3] != w1:
    print('DXR BYTE expression packing mismatch', file=sys.stderr)
    print('%012o %012o' % (words[2], words[3]), file=sys.stderr)
    raise SystemExit(1)
print('DAS BYTE expression spacing contract passed')
