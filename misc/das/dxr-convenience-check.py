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
    for off in relocs: r[off//36] |= 1 << (35-(off%36))
    return r

def ascii_word(s):
    w=0; used=0
    for ch in s:
        w |= (ord(ch)&0o177) << (36-used-7)
        used += 7
    return w&MASK
# Layout: text statements 0..5 plus one literal at 6.
image_words=7
# OWGBP 70,ptr: selector 70 -> size 9 low 0 high 8 => P field 35-high=27.
owgbp_70_ptr=(27<<30)|(9<<24)|3
exp=[
    word(six('DXR'),0),
    word(image_words,0),
    mem(0o201,1,3),
    mem(0o201,2,6),
    mem(0o254,4,0),
    4,
    ascii_word('HELLO'),
    ascii_word('A\0'),
    owgbp_70_ptr,
]+rb(image_words,[0,1,3,8-2]) # image relocation offsets 0,1,3,6
# Fix comment: offset 6 is literal, header-adjusted index 8 in exp.
exp=[
    word(six('DXR'),0),
    word(image_words,0),
    mem(0o201,1,3),
    mem(0o201,2,6),
    mem(0o254,4,0),
    4,
    ascii_word('HELLO'),
    ascii_word('A\0'),
    owgbp_70_ptr,
]+rb(image_words,[0,1,3,6])
got=read_words(sys.argv[1])
if got!=exp:
    print('DXR convenience mismatch', file=sys.stderr)
    print('expected:', ['%012o'%x for x in exp], file=sys.stderr)
    print('got:     ', ['%012o'%x for x in got], file=sys.stderr)
    raise SystemExit(1)
