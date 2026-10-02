#!/usr/bin/env python3
import sys
MASK=(1<<36)-1
HALF=(1<<18)-1
data=open(sys.argv[1],"rb").read()
words=[int.from_bytes(data[i:i+8],"little") & MASK for i in range(0,len(data),8)]
n=(words[1]>>18)&HALF
image=words[2:2+n]
def op(i): return (image[i]>>27)&0o777
def ac(i): return (image[i]>>23)&0o17
def y(i): return image[i]&HALF
if n != 12:
    raise SystemExit("optimized image is %d words, expected 12" % n)
# The first two masks cover every bit that can remain after the logical shift.
if (op(0),ac(0),y(0)) != (0o242,1,((-0o33)&HALF)):
    raise SystemExit("first LSH mismatch")
if (op(1),ac(1),y(1)) != (0o242,2,((-0o43)&HALF)):
    raise SystemExit("second LSH mismatch")
# Narrow masks and shifts leaving more than 18 possible bits must remain.
if op(2) != 0o242 or op(3) != 0o405:
    raise SystemExit("narrow mask was removed")
if op(4) != 0o242 or op(5) != 0o405:
    raise SystemExit("short-shift mask was removed")
# A label on ANDI is a hard barrier.
if op(6) != 0o242 or op(7) != 0o405:
    raise SystemExit("labeled mask was removed")
# A conditionally skipped LSH must not seed the fold.
if op(8) != 0o302 or op(9) != 0o242 or op(10) != 0o405 or op(11) != 0o254:
    raise SystemExit("skip-guarded mask sequence was folded")
print("DAS redundant post-LSH mask contract passed")
