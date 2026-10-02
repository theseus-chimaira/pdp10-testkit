#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
n = (words[1] >> 18) & HALF
image = words[2:2 + n]
if n != 4:
    raise SystemExit("AC0 SKIP image is %d words, expected 4" % n)
if ((image[0] >> 27) & 0o777) != 0o200 or ((image[0] >> 23) & 0o17) != 0:
    raise SystemExit("MOVE 0,EA was incorrectly folded into SKIP")
if ((image[1] >> 27) & 0o777) != 0o332 or ((image[1] >> 23) & 0o17) != 0:
    raise SystemExit("SKIPE 0,0 was not preserved")
print("DAS SKIP AC0 destination-write contract passed")
