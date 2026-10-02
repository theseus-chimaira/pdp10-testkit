#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
if len(data) % 8:
    raise SystemExit("partial host word")
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
if len(words) < 6:
    raise SystemExit("short DXR")
image_words = (words[1] >> 18) & HALF
if image_words != 4:
    raise SystemExit("optimized image is %d words, expected 4" % image_words)
image = words[2:2 + image_words]
if ((image[0] >> 27) & 0o777) != 0o201:
    raise SystemExit("18-bit literal MOVE was not folded to MOVEI")
if ((image[0] >> 23) & 0o17) != 1 or (image[0] & HALF) != 0o12345:
    raise SystemExit("folded MOVEI operand mismatch")
if ((image[1] >> 27) & 0o777) != 0o200:
    raise SystemExit("wide literal MOVE was folded incorrectly")
if image[3] != 0o1000000:
    raise SystemExit("wide literal pool value mismatch")
print("DAS absolute literal-to-MOVEI contract passed")
