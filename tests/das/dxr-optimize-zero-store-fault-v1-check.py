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
    raise SystemExit("zero-store fault regression is %d words, expected 4" % n)

def op(i):
    return (image[i] >> 27) & 0o777

def ac(i):
    return (image[i] >> 23) & 0o17

def y(i):
    return image[i] & HALF

if (op(0), ac(0)) != (0o201, 1) or (op(1), ac(1)) != (0o202, 1):
    raise SystemExit("faultable MOVEI/MOVEM was folded to SETZB")
if (op(2), ac(2), y(2)) != (0o403, 2, 3):
    raise SystemExit("accumulator zero store was not safely folded")
if op(3) != 0o254:
    raise SystemExit("HALT encoding mismatch")

print("DAS zero-store fault-order regression passed")
