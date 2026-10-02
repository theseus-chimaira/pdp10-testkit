#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
n = (words[1] >> 18) & HALF
image = words[2:2 + n]

if n != 7:
    raise SystemExit("CAI flag regression is %d words, expected 7" % n)
ops = [((w >> 27) & 0o777) for w in image]
if ops[:5] != [0o200, 0o306, 0o200, 0o302, 0o254]:
    raise SystemExit("PDP-6 CAI flag-producing operations were folded: %r" % ops[:5])
print("DAS PDP-6 CAI flags regression passed")
