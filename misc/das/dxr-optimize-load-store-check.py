#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
n = (words[1] >> 18) & HALF
image = words[2:2 + n]

if n != 18:
    raise SystemExit("optimized image is %d words, expected 18" % n)

def op(i):
    return (image[i] >> 27) & 0o777

# Cross-kind MOVE/MOVEM pairs remain: a read can succeed where a write faults.
if [op(i) for i in range(4)] != [0o200, 0o202, 0o200, 0o202]:
    raise SystemExit("cross-kind load/store pair was eliminated")
# Dot, different-address, indexed, and indirect pairs remain unchanged.
if [op(i) for i in range(4, 12)] != [0o200, 0o202] * 4:
    raise SystemExit("unsafe load/store near-miss was altered")
# Same-kind repeated accesses are still eliminated.
if op(12) != 0o200 or op(13) != 0o202 or op(14) != 0o254:
    raise SystemExit("same-kind redundant access optimization was lost")
if [image[15] & HALF, image[16] & HALF, image[17] & HALF] != [1, 2, 3]:
    raise SystemExit("data tail mismatch")
print("DAS redundant load/store access-kind contract passed")
