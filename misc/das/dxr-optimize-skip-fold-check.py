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
# Plain SKIP (0330) never skips, so the first two MOVE/SKIP pairs can fold.
if n != 20:
    raise SystemExit("optimized image is %d words, expected 20" % n)
if (op(0),ac(0)) != (0o330,1) or (op(1),ac(1)) != (0o331,2):
    raise SystemExit("safe MOVE/SKIP folds missing")
# SKIPL and the remaining conditional SKIP forms can skip the following MOVE;
# those following MOVE/SKIP pairs must therefore remain separate.
want=[
    (0o200,3),(0o332,3),(0o200,4),(0o333,4),
    (0o200,5),(0o334,5),(0o200,6),(0o335,6),
    (0o200,7),(0o336,7),(0o200,0o10),(0o337,0o10),
    (0o200,0o11),(0o330,0o11),(0o200,0o12),(0o261,0o17),
    (0o200,0o13),(0o254,4)
]
for i,(wo,wa) in enumerate(want,2):
    if (op(i),ac(i)) != (wo,wa):
        raise SystemExit("skip barrier or tail safety mismatch at %d" % i)
print("DAS MOVE/SKIP folding and skip-barrier contract passed")
