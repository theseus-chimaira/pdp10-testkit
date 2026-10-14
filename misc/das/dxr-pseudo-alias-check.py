#!/usr/bin/env python3
import sys
MASK=(1<<36)-1
HALF=(1<<18)-1

def six(s):
    w=0
    for ch in s:
        w=(w<<6)|(ord(ch)-32)
    return w&HALF

def sixword(s):
    w=0
    s=s.upper()
    for i in range(6):
        c=0
        if i < len(s):
            o=ord(s[i])
            if 32 <= o <= 95: c=o-32
        w=(w<<6)|(c&0o77)
    return w&MASK

def word(lh,rh): return ((lh&HALF)<<18)|(rh&HALF)
def mem(op,ac,y,ind=0,xr=0): return ((op&0o777)<<27)|((ac&0o17)<<23)|((ind&1)<<22)|((xr&0o17)<<18)|(y&HALF)
def read_words(path):
    b=open(path,'rb').read()
    if len(b)%8: raise SystemExit('bad length')
    return [int.from_bytes(b[i:i+8],'little')&MASK for i in range(0,len(b),8)]
def rb(n, relocs):
    r=[0]*((n+35)//36)
    for off in relocs: r[off//36] |= 1 << (35-(off%36))
    return r

image_words=4
exp=[
    word(six('DXR'),0),
    word(image_words,3),
    mem(0o201,1,3),
    mem(0o254,0,2),
    mem(0o254,4,0),
    sixword('OK'),
]+rb(image_words,[0,1])
got=read_words(sys.argv[1])
if got!=exp:
    print('DXR pseudo alias mismatch', file=sys.stderr)
    print('expected:', ['%012o'%x for x in exp], file=sys.stderr)
    print('got:     ', ['%012o'%x for x in got], file=sys.stderr)
    raise SystemExit(1)
