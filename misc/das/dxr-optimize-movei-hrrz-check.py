#!/usr/bin/env python3
import sys
MASK = (1 << 36) - 1
HALF = (1 << 18) - 1
data = open(sys.argv[1], "rb").read()
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
n = (words[1] >> 18) & HALF
image = words[2:2 + n]
ops = [((w >> 27) & 0o777, (w >> 23) & 0o17) for w in image]
expected = [(0o201,1),(0o201,2),(0o201,3),(0o201,4),(0o550,4),(0o254,4),(0,0)]
if n != len(expected):
    raise SystemExit("optimized image is %d words, expected %d" % (n, len(expected)))
for i, pair in enumerate(expected):
    if ops[i] != pair:
        raise SystemExit("word %d opcode/ac %o/%o, expected %o/%o" %
                         (i, ops[i][0], ops[i][1], pair[0], pair[1]))
print("DAS MOVEI/HRRZ redundancy contract passed")
