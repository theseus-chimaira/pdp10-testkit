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
if n != 9:
    raise SystemExit("optimized image is %d words, expected 9" % n)
if (op(0),ac(0),op(1),ac(1)) != (0o200,1,0o306,1):
    raise SystemExit("PDP-6 flag-producing MOVE/CAIN pair was folded")
# CAIN can skip the following MOVE, so that MOVE/CAIE pair must remain split.
if (op(2),ac(2),op(3),ac(3)) != (0o200,2,0o302,2):
    raise SystemExit("CAI skip barrier was ignored")
if [op(i) for i in range(4,9)] != [0o200,0o306,0o200,0o306,0o254]:
    raise SystemExit("label, accumulator, or HALT barrier mismatch")
print("DAS MOVE/CAI PDP-6 flags and skip-barrier contract passed")
