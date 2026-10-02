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
expected=[(0o201,1,0o4),(0o201,2,0o2),(0o201,3,0)]
for i,e in enumerate(expected):
    got=(op(i),ac(i),y(i))
    if got != e:
        raise SystemExit("shift fold %d mismatch: %r != %r" % (i,got,e))
# Labeled and left-shift cases must remain two instructions each.
if op(3) != 0o201 or op(4) != 0o240:
    raise SystemExit("labeled ASH was folded")
if op(5) != 0o201 or op(6) != 0o240:
    raise SystemExit("left ASH was folded")
if op(7) != 0o254:
    raise SystemExit("HALT mismatch")
print("DAS MOVEI right-shift folding contract passed")
