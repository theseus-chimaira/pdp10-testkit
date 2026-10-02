#!/usr/bin/env python3
import sys
MASK = (1 << 36) - 1
HALF = (1 << 18) - 1
data = open(sys.argv[1], "rb").read()
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
image_words = (words[1] >> 18) & HALF
if image_words != 10:
    raise SystemExit("optimized image is %d words, expected 10" % image_words)
image = words[2:2 + image_words]
ops = [((w >> 27) & 0o777, (w >> 23) & 0o17) for w in image]
if ops[0] != (0o403, 1):
    raise SystemExit("accumulator zero store was not folded to SETZB")
if ops[1] != (0o201, 5) or ops[2] != (0o202, 5):
    raise SystemExit("faultable direct zero store was folded unsafely")
if ops[3] != (0o201, 2) or ops[4] != (0o202, 2):
    raise SystemExit("label barrier altered zero-store sequence")
if ops[5] != (0o201, 3) or ops[6] != (0o202, 3):
    raise SystemExit("indexed zero store was folded unsafely")
if ops[7] != (0o201, 4) or ops[8][0] != 0o202:
    raise SystemExit("current-location zero store was folded unsafely")
if ops[9][0] != 0o254:
    raise SystemExit("HALT encoding mismatch")
print("DAS zero-store SETZB safety contract passed")
