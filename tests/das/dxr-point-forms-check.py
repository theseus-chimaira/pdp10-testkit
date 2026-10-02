#!/usr/bin/env python3
import sys
MASK=(1<<36)-1
HALF=(1<<18)-1

def six(s):
    w=0
    for ch in s:
        w=(w<<6)|(ord(ch)-32)
    return w&HALF

def word(lh,rh): return ((lh&HALF)<<18)|(rh&HALF)
def mem(op,ac,y,ind=0,xr=0): return ((op&0o777)<<27)|((ac&0o17)<<23)|((ind&1)<<22)|((xr&0o17)<<18)|(y&HALF)
def read_words(path):
    b=open(path,'rb').read()
    if len(b)%8: raise SystemExit('bad length')
    return [int.from_bytes(b[i:i+8],'little')&MASK for i in range(0,len(b),8)]
def rb(n, relocs):
    r=[0]*((n+35)//36)
    for off in relocs:
        r[off//36] |= 1 << (35-(off%36))
    return r

def point(size,y,pos,ind=0,xr=0):
    return (((35-pos)&0o77)<<30)|((size&0o77)<<24)|((ind&1)<<22)|((xr&0o17)<<18)|(y&HALF)

def owgbp(size,low,y):
    high=low+size-1
    return (((35-high)&0o77)<<30)|((size&0o77)<<24)|(y&HALF)

image_words=9
exp=[
    word(six('DXR'),0),
    word(image_words,0),
    mem(0o135,1,8),
    mem(0o135,2,3),
    mem(0o254,4,0),
    point(7,7,34,1,3),
    8,
    owgbp(6,0,7),
    owgbp(18,18,9),
    0,
    point(9,7,35,1,2),
]+rb(image_words,[0,1,3,4,5,6,8])
got=read_words(sys.argv[1])
if got!=exp:
    print('DXR POINT/GIW/OWGBP forms mismatch', file=sys.stderr)
    print('expected:', ['%012o'%x for x in exp], file=sys.stderr)
    print('got:     ', ['%012o'%x for x in got], file=sys.stderr)
    raise SystemExit(1)
