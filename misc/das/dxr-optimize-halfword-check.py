#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
if len(data) % 8:
    raise SystemExit("partial host word")
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
image_words = (words[1] >> 18) & HALF
if image_words != 14:
    raise SystemExit("optimized image is %d words, expected 14" % image_words)
image = words[2:2 + image_words]
ops = [(w >> 27) & 0o777 for w in image]
acs = [(w >> 23) & 0o17 for w in image]
# main is a labeled execution entry and may be an XCT target.  Do not replace
# the labeled MOVE by a sequence-combined HLRZ.
if ops[0:2] != [0o200, 0o242] or acs[0:2] != [1, 1]:
    raise SystemExit("labeled MOVE/LSH sequence was folded")
if ops[2] != 0o514 or acs[2] != 2:
    raise SystemExit("MOVE/LSH 022 was not folded to HRLZ")
if ops[3:5] != [0o200, 0o242] or acs[3:5] != [3, 4]:
    raise SystemExit("different-AC near miss was folded")
if ops[5:7] != [0o200, 0o242] or acs[5:7] != [5, 5]:
    raise SystemExit("different-count near miss was folded")
if ops[7:9] != [0o200, 0o242] or acs[7:9] != [6, 6]:
    raise SystemExit("label barrier near miss was folded")
if ops[9] != 0o550 or acs[9] != 7:
    raise SystemExit("MOVE/ANDI 0777777 was not folded to HRRZ")
if ops[10:12] != [0o200, 0o405] or acs[10:12] != [0o10, 0o10]:
    raise SystemExit("ANDI mask near miss was folded")
if ops[12] != 0o254:
    raise SystemExit("HALT encoding mismatch")
print("DAS MOVE/halfword fold contract passed")
