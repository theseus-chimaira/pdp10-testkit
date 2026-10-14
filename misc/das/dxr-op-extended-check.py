#!/usr/bin/env python3
import sys

MASK36 = (1 << 36) - 1
HALF18 = (1 << 18) - 1

def mem(op, ac, y):
    return ((op & 0o777) << 27) | ((ac & 0o17) << 23) | (y & HALF18)

data = open(sys.argv[1], 'rb').read()
if len(data) % 8:
    raise SystemExit('bad DXR length')
words = [int.from_bytes(data[i:i + 8], 'little') & MASK36
         for i in range(0, len(data), 8)]
if len(words) < 4 or (words[1] >> 18) != 2:
    raise SystemExit('expected two image words')
expected = [mem(0o123, 1, 2), mem(0o257, 2, 3)]
if words[2:4] != expected:
    raise SystemExit('extended opcode mismatch: %r' %
                     ['%012o' % x for x in words[2:4]])
print('DAS EXTEND/MAP opcode contract passed')
