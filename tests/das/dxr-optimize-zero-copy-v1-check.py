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
if n != 8:
    raise SystemExit("optimized image is %d words, expected 8" % n)
if (op(0),ac(0),y(0)) != (0o403,2,1):
    raise SystemExit("SETZ/MOVE was not folded to SETZB")
if (op(1),ac(1),y(1)) != (0o403,3,4):
    raise SystemExit("MOVEI-zero/MOVE was not folded to SETZB")
if op(2) != 0o400 or op(3) != 0o200:
    raise SystemExit("labeled MOVE sequence was folded")
if op(4) != 0o302 or op(5) != 0o400 or op(6) != 0o200:
    raise SystemExit("skip-guarded zero-copy sequence was folded")
if op(7) != 0o254:
    raise SystemExit("HALT mismatch")
print("DAS zero-copy SETZB contract passed")
