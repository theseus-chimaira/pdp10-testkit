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
if image_words != 6:
    raise SystemExit("optimized image is %d words, expected 6" % image_words)
image = words[2:2 + image_words]
expected = [
    0o201040000005,
    0o201100000005,
    0o201040000006,
    0o201040000006,
]
if image[:4] != expected:
    raise SystemExit("MOVEI value peephole mismatch: %r" % image[:4])
if ((image[4] >> 27) & 0o777) != 0o201:
    raise SystemExit("symbolic MOVEI near-miss was altered")
if image[5] != 0o7:
    raise SystemExit("trailing data mismatch")
print("DAS MOVEI value peephole contract passed")
