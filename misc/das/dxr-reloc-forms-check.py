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
    data=open(path,'rb').read()
    if len(data)%8: raise SystemExit('bad host container length')
    return [int.from_bytes(data[i:i+8],'little')&MASK for i in range(0,len(data),8)]
def reloc_bitmap(image_words, relocs):
    out=[0]*((image_words+35)//36)
    for off in relocs:
        out[off//36] |= 1 << (35-(off%36))
    return out
image_words=42
target=41
done=40
exp=[
    word(six('DXR'),0),
    word(image_words,0),
    mem(0o201,1,target+1),
    mem(0o200,2,target,xr=5),
    mem(0o200,3,target,ind=1),
    mem(0o200,4,target,ind=1,xr=6),
    mem(0o200,5,target,ind=1,xr=7),
    word(0,target),
    done,
    7,
    0,
    target-done,
    (done-target)&MASK,
]
exp += [0]*(37-11)
exp += [
    mem(0o201,5,target),
    mem(0o201,6,target),
    mem(0o201,7,target),
    mem(0o254,4,0),
    0,
]
exp = exp[:2+image_words] + reloc_bitmap(image_words, [0,1,2,3,4,5,37,38,39])
got=read_words(sys.argv[1])
if got != exp:
    print('DXR reloc-form word mismatch', file=sys.stderr)
    print('expected:', ['%012o'%x for x in exp], file=sys.stderr)
    print('got:     ', ['%012o'%x for x in got], file=sys.stderr)
    raise SystemExit(1)
