#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
n = (words[1] >> 18) & HALF
image = words[2:2 + n]
if n != 11:
    raise SystemExit("skip-state image is %d words, expected 11" % n)

def insn(i):
    w = image[i]
    return ((w >> 27) & 0o777, (w >> 23) & 0o17, w & HALF)

# A guarded MOVE must not seed value-identity state that later deletes MOVE 3,2.
if insn(4) != (0o200, 0o3, 0o2):
    raise SystemExit("guarded MOVE polluted value-identity state")
# A label-only/.globl source boundary must not consume a pending hardware skip.
if insn(9) != (0o200, 0o10, 0o7):
    raise SystemExit("zero-word source structure consumed skip barrier")
print("DAS guarded-value skip-state contract passed")
