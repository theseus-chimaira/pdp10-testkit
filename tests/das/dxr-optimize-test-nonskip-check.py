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
if n != 12:
    raise SystemExit("optimized image is %d words, expected 12" % n)
# First three tests are provably non-skipping and must disappear.
for i,a in enumerate((1,2,3)):
    if op(i) != 0o201 or ac(i) != a:
        raise SystemExit("non-skip fold %d mismatch" % i)
# The remaining skip-capable tests must remain as instruction pairs.
if op(3) != 0o201 or op(5) != 0o201 or op(7) != 0o201 or op(9) != 0o201:
    raise SystemExit("MOVEI near-miss missing")
if op(11) != 0o254:
    raise SystemExit("HALT mismatch")
print("DAS MOVEI non-skipping test elimination contract passed")
