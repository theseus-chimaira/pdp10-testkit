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
def xr(i): return (image[i]>>18)&0o17
def y(i): return image[i]&HALF
# Only nonfaulting register/immediate overwrites may delete predecessors.
if n != 16:
    raise SystemExit("optimized image is %d words, expected 16" % n)
expected=[
    (0o201,1,0,2),       # second MOVEI replaces first
    (0o201,2,0,3),       # retain assignment before faultable memory MOVE
    (0o200,2,0,0o17),    # MOVE 2,FOO
    (0o201,3,0,5),       # MOVEI replaces register copy
    (0o201,4,0,7),       # MOVE 4,4 must not kill incoming value
    (0o201,5,0,1),       # predecessor label is a barrier
    (0o201,5,0,2),
    (0o201,6,0,1),       # current label is a barrier
    (0o201,6,0,2),
    (0o201,7,0,1),       # faultable/indexed overwrite: no fold
    (0o200,7,7,0o17),
    (0o200,0o10,0,0o17), # memory predecessor has observable read
    (0o201,0o10,0,1),
    (0o201,0o11,0,3),    # register-copy predecessor is removable
    (0o254,4,0,0),
    (0o000,0,0,0o12345),
]
for i,e in enumerate(expected):
    got=(op(i),ac(i),xr(i),y(i))
    if got != e:
        raise SystemExit("word %d mismatch: %r != %r" % (i,got,e))
print("DAS dead overwrite contract passed")
