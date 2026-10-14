#!/usr/bin/env python3
import sys

raw = open(sys.argv[1], "rb").read()
if len(raw) % 8:
    raise SystemExit("partial host word")
words = [int.from_bytes(raw[i:i + 8], "little") & ((1 << 36) - 1)
         for i in range(0, len(raw), 8)]
if len(words) < 5:
    raise SystemExit("short DXR")
image = (words[1] >> 18) & 0o777777
if image != 6:
    raise SystemExit("optimized image is %d words, expected 6" % image)
print("DAS six-instruction register peephole contract passed")
