#!/usr/bin/env python3
import sys
MASK=(1<<36)-1
HALF=(1<<18)-1
data=open(sys.argv[1],"rb").read()
words=[int.from_bytes(data[i:i+8],"little") & MASK for i in range(0,len(data),8)]
n=(words[1]>>18)&HALF
image=words[2:2+n]
ops=[(w>>27)&0o777 for w in image]
if 0o403 in ops:
    raise SystemExit("peephole crossed a potentially skipped instruction")
if n != 17:
    raise SystemExit("skip-barrier image is %d words, expected 17" % n)
print("DAS skip-barrier optimizer contract passed")
