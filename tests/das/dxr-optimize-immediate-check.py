#!/usr/bin/env python3
import sys
MASK=(1<<36)-1
HALF=(1<<18)-1
data=open(sys.argv[1],"rb").read()
words=[int.from_bytes(data[i:i+8],"little") & MASK for i in range(0,len(data),8)]
n=(words[1]>>18)&HALF
image=words[2:2+n]
# Four flag-safe folds remove five instructions total, including chained ADDI/ANDI.
if n != 19:
    raise SystemExit("optimized image is %d words, expected 19" % n)
def op(i): return (image[i]>>27)&0o777
def ac(i): return (image[i]>>23)&0o17
def y(i): return image[i]&HALF
expected=[(0o201,1,7),(0o201,2,7),(0o275,2,2),(0o201,3,2),(0o201,4,0o13),(0o201,5,0),(0o201,6,0o25)]
for i,e in enumerate(expected):
    got=(op(i),ac(i),y(i))
    if got != e:
        raise SystemExit("fold %d mismatch: %r != %r" % (i,got,e))
if (op(7),ac(7),y(7)) != (0o211,0o12,5):
    raise SystemExit("MOVEI/MOVN was not folded to MOVNI")
# Labels and overflowing/underflowing operations remain as two instructions.
if op(8) != 0o201 or op(10) != 0o201 or op(12) != 0o201 or op(14) != 0o201 or op(16) != 0o201:
    raise SystemExit("near-miss MOVEI instructions were altered")
if op(18) != 0o254:
    raise SystemExit("HALT encoding mismatch")
print("DAS immediate folding contract passed")
