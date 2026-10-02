#!/usr/bin/env python3
import sys
MASK=(1<<36)-1
HALF=(1<<18)-1

def word(lh,rh): return ((lh&HALF)<<18)|(rh&HALF)
def read_words(path):
    data=open(path,'rb').read()
    if len(data)%8: raise SystemExit('bad host container length')
    return [int.from_bytes(data[i:i+8],'little')&MASK for i in range(0,len(data),8)]
def reloc_bitmap(image_words, relocs):
    out=[0]*((image_words+35)//36)
    for off in relocs:
        out[off//36] |= 1 << (35-(off%36))
    return out
image_words=37
exp=[word(0o447062,0), word(image_words,0), 36, 37, 36, *([0]*34)]
exp += reloc_bitmap(image_words,[0,1])
got=read_words(sys.argv[1])
if got != exp:
    print('DXR word-address relocation mismatch', file=sys.stderr)
    print('expected:', ['%012o'%x for x in exp], file=sys.stderr)
    print('got:     ', ['%012o'%x for x in got], file=sys.stderr)
    raise SystemExit(1)
