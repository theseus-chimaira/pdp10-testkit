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
    raise SystemExit("PUSH fault regression is %d words, expected 7" % n)

def op(i):
    return (image[i] >> 27) & 0o777

def ac(i):
    return (image[i] >> 23) & 0o17

def y(i):
    return image[i] & HALF

# Memory MOVE/PUSH must remain separate: PUSH can fault after temp is loaded.
if (op(0), ac(0), op(1), ac(1), y(1)) != (0o200, 1, 0o261, 0o17, 1):
    raise SystemExit("fault-visible MOVE/PUSH was folded")
if (op(2), ac(2), y(2)) != (0o201, 1, 3):
    raise SystemExit("post-PUSH overwrite moved incorrectly")
# Nonfaulting MOVEI/register forwarding remains safe and profitable.
if (op(3), ac(3), y(3)) != (0o201, 3, 7):
    raise SystemExit("safe MOVEI forwarding was lost")
if (op(4), ac(4), y(4)) != (0o201, 2, 0):
    raise SystemExit("safe overwrite moved incorrectly")
if op(5) != 0o254 or image[6] != 0o12345:
    raise SystemExit("PUSH regression tail mismatch")

print("DAS PUSH fault-order regression passed")
