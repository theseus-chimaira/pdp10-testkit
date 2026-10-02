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
if n != 9:
    raise SystemExit("EA audit image is %d words, expected 9" % n)
image = words[2:2 + n]
relmap = words[2 + n]

def op(i):
    return (image[i] >> 27) & 0o777

def ac(i):
    return (image[i] >> 23) & 0o17

def ind(i):
    return (image[i] >> 22) & 1

def xr(i):
    return (image[i] >> 18) & 0o17

# MOVE 1,FOO(1) / HRRZ 1,1 may fold because the folded instruction evaluates
# the identical indexed EA once, before writing AC1.  Relocation and index must
# survive the opcode rewrite.
if (op(0), ac(0), ind(0), xr(0)) != (0o550, 1, 0, 1):
    raise SystemExit("indexed MOVE/HRRZ fold lost EA fields")
if (relmap & (1 << 35)) == 0:
    raise SystemExit("indexed MOVE/HRRZ fold lost relocation")

# Repeated indirect access may auto-index, so both evaluations are required.
if [(op(i), ac(i), ind(i), xr(i)) for i in (1, 2)] != \
        [(0o200, 2, 1, 0), (0o200, 2, 1, 0)]:
    raise SystemExit("repeated indirect MOVE was eliminated")

# If the destination AC is also the index register, the first MOVE changes the
# EA used by the second.  Both words must remain.
if [(op(i), ac(i), xr(i)) for i in (3, 4)] != \
        [(0o200, 3, 3), (0o200, 3, 3)]:
    raise SystemExit("self-indexed repeated MOVE was eliminated")

# Each dot denotes that instruction's own address.  Textual equality is not EA
# equality, so both accesses must remain.
if [op(5), op(6), op(7)] != [0o200, 0o200, 0o254]:
    raise SystemExit("current-location access was optimized unsafely")
if (image[5] & HALF) == (image[6] & HALF):
    raise SystemExit("current-location operands unexpectedly match")

print("DAS indexed/indirect/current-location optimizer contract passed")
