#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
n = (words[1] >> 18) & HALF
image = words[2:2 + n]

if n != 4:
    raise SystemExit("access-kind regression is %d words, expected 4" % n)
ops = [((w >> 27) & 0o777) for w in image]
if ops != [0o200, 0o202, 0o254, 0o000]:
    raise SystemExit("MOVE/MOVEM access kinds were collapsed: %r" % ops)
print("DAS memory access-kind regression passed")
