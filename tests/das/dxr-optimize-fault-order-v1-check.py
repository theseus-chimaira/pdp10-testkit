#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
n = (words[1] >> 18) & HALF
image = words[2:2 + n]

if n != 13:
    raise SystemExit("fault-order regression is %d words, expected 13" % n)

def op(i):
    return (image[i] >> 27) & 0o777

def ac(i):
    return (image[i] >> 23) & 0o17

# A faulting overwrite cannot erase the preceding trap-visible assignment.
if (op(0), ac(0), op(1), ac(1)) != (0o201, 1, 0o200, 1):
    raise SystemExit("dead-write fold crossed a faultable MOVE")
# Delayed PUSH forwarding cannot erase the temporary before a faulting overwrite.
if (op(2), ac(2), op(3), ac(3), op(4), ac(4)) != \
        (0o200, 2, 0o261, 0o17, 0o200, 2):
    raise SystemExit("PUSH forwarding crossed a faultable overwrite")
# Delayed MOVEI/ADD elimination has the same trap-visible-state requirement.
if (op(5), ac(5), op(6), ac(6), op(7), ac(7)) != \
        (0o201, 3, 0o270, 4, 0o200, 3):
    raise SystemExit("ADDI folding crossed a faultable overwrite")
if op(8) != 0o254:
    raise SystemExit("HALT encoding mismatch")

print("DAS optimizer fault-order regression passed")
