#!/usr/bin/env python3
import sys
MASK=(1<<36)-1
HALF=(1<<18)-1
def six(s):
    w=0
    for ch in s: w=(w<<6)|(ord(ch)-32)
    return w&HALF
def word(lh,rh): return ((lh&HALF)<<18)|(rh&HALF)
def read_words(path):
    b=open(path,'rb').read()
    if len(b)%8: raise SystemExit('bad length')
    return [int.from_bytes(b[i:i+8],'little')&MASK for i in range(0,len(b),8)]
exp=[
    word(six('DXR'),0),
    word(2,0),
    (0o44<<30)|(7<<24)|1,
    (0o254<<27)|(4<<23),
    1<<35,
]
got=read_words(sys.argv[1])
if got!=exp:
    print('DXR default POINT position mismatch', file=sys.stderr)
    print('expected:', ['%012o'%x for x in exp], file=sys.stderr)
    print('got:     ', ['%012o'%x for x in got], file=sys.stderr)
    raise SystemExit(1)
print('DAS two-operand POINT contract passed')
