#!/usr/bin/env python3
import sys
data=open(sys.argv[1],"rb").read()
if len(data)%8: raise SystemExit("partial host word")
w=[int.from_bytes(data[i:i+8],"little") & ((1<<36)-1) for i in range(0,len(data),8)]
if len(w)<5: raise SystemExit("short DXR")
image=(w[1]>>18)&0o777777
if image != 6: raise SystemExit("optimized image is %d words, expected 6" % image)
if w[2] != 0o200040000001:
    raise SystemExit("labeled entry instruction was rewritten")
print("DAS base peephole contract passed")
