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
if n != 11:
    raise SystemExit("optimized image is %d words, expected 11" % n)
want=[(0o554,1),(0o550,2),(0o570,3),(0o510,4)]
for i,e in enumerate(want):
    if (op(i),ac(i)) != e:
        raise SystemExit("unary MOVE fold %d mismatch" % i)
if (op(4),ac(4),op(5),ac(5)) != (0o200,5,0o210,5):
    raise SystemExit("MOVE/MOVN overflow-sensitive sequence was folded")
if (op(6),ac(6)) != (0o204,6) or (op(7),ac(7)) != (0o460,7):
    raise SystemExit("remaining unary folds mismatch")
if [op(8),op(9),op(10)] != [0o200,0o554,0o254]:
    raise SystemExit("label barrier or HALT mismatch")
print("DAS MOVE/unary folding contract passed")
