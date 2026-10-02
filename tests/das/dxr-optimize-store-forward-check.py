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
# START names the first MOVEM as a control-flow/XCT entry.  The following
# load must therefore remain memory-based: execution may enter at that load
# without executing the store first.
if (op(0),ac(0),op(1),ac(1),y(0),y(1)) != \
        (0o202,1,0o200,2,y(0),y(0)):
    raise SystemExit("labeled-entry store/load pair was rewritten")
if op(3) != 0o200 or ac(3) != 4:
    raise SystemExit("different-address MOVE was altered incorrectly")
# MOVEM 5,FOO / MOVE 5,FOO is reduced to the single store.  Existing
# store forwarding already made the reload a MOVE 5,5; the residual rule
# removes only that non-faulting register self-copy.
if op(4) != 0o202 or ac(4) != 5:
    raise SystemExit("same-AC store/reload was not reduced")
if [op(i) for i in range(5,9)] != [0o202,0o200,0o202,0o200]:
    raise SystemExit("indexed or indirect store-forward was altered")
# A label is an XCT/control-flow entry barrier, so the labeled reload stays.
if (op(9),ac(9),op(10),ac(10)) != (0o202,0o13,0o200,0o13):
    raise SystemExit("labeled same-AC reload was altered")
if n != 15 or op(11) != 0o254:
    raise SystemExit("store-forward image shape mismatch")
print("DAS store-forwarding contract passed")
