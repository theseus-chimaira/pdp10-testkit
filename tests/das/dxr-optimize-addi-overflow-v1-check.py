#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
if len(data) % 8:
    raise SystemExit("partial host word")
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
n = (words[1] >> 18) & HALF
image = words[2:2 + n]
if n != 4:
    raise SystemExit("ADDI overflow regression is %d words, expected 4" % n)

def op(i):
    return (image[i] >> 27) & 0o777

def ac(i):
    return (image[i] >> 23) & 0o17

def y(i):
    return image[i] & HALF

# ADD may overflow before the following MOVEI executes.  In the original
# stream AC2 already contains 1 at that trap point, so MOVEI/ADD cannot be
# replaced by ADDI merely because AC2 is overwritten afterward.
if (op(0), ac(0), y(0)) != (0o201, 2, 1):
    raise SystemExit("trap-visible MOVEI was removed")
if (op(1), ac(1), y(1)) != (0o270, 1, 2):
    raise SystemExit("overflow-capable ADD was rewritten")
if (op(2), ac(2), y(2)) != (0o201, 2, 0) or op(3) != 0o254:
    raise SystemExit("ADDI overflow regression tail mismatch")

print("DAS ADD overflow-state regression passed")
