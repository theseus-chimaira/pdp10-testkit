#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
n = (words[1] >> 18) & HALF
image = words[2:2 + n]

if n != 5:
    raise SystemExit("MOVN overflow regression is %d words, expected 5" % n)

def op(i):
    return (image[i] >> 27) & 0o777

def ac(i):
    return (image[i] >> 23) & 0o17

# Memory MOVE/MOVN must remain separate so an overflow trap sees the loaded AC.
if (op(0), ac(0), op(1), ac(1)) != (0o200, 5, 0o210, 5):
    raise SystemExit("fault-visible MOVE/MOVN was folded")
# MOVEI supplies a small positive value, so MOVNI cannot overflow and is safe.
if (op(2), ac(2)) != (0o211, 6):
    raise SystemExit("safe MOVEI/MOVN fold was lost")
if op(3) != 0o254 or image[4] != 0o400000000000:
    raise SystemExit("MOVN regression tail mismatch")

print("DAS MOVN overflow-state regression passed")
