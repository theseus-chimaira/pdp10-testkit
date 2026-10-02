#!/usr/bin/env python3
import sys
MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

def six(s):
    w = 0
    for ch in s:
        w = (w << 6) | (ord(ch) - 32)
    return w & HALF

def word(lh, rh):
    return ((lh & HALF) << 18) | (rh & HALF)

def mem(op, ac, y, ind=0, xr=0):
    return ((op & 0o777) << 27) | ((ac & 0o17) << 23) | ((ind & 1) << 22) | ((xr & 0o17) << 18) | (y & HALF)

def io(dev, fn, y, ind=0, xr=0):
    return (0o7 << 33) | (((dev >> 2) & 0o177) << 26) | ((fn & 7) << 23) | ((ind & 1) << 22) | ((xr & 0o17) << 18) | (y & HALF)

def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('DXR host container length is not a word multiple')
    return [int.from_bytes(data[i:i+8], 'little') & MASK for i in range(0, len(data), 8)]

def reloc_bitmap(image_words, relocs):
    words = [0] * ((image_words + 35) // 36)
    for off in relocs:
        words[off // 36] |= 1 << (35 - (off % 36))
    return words

# Layout: five text words, two byte-data words, three bss words.
image_words = 7
exp = [
    word(six('DXR'), 0),
    word(image_words, 3),
    io(0o200, 4, 5),          # CONO 200,foo
    mem(0o561, 2, 6),         # HRROI 2,foo+1
    mem(0o326, 2, 4),         # JUMPN 2,done
    mem(0o474, 3, 0),         # SETO 3,
    mem(0o254, 4, 0),         # HALT (JRST 4)
    0o010203040506,
    0o070000000000,
] + reloc_bitmap(image_words, [0, 1, 2])

got = read_words(sys.argv[1])
if got != exp:
    print('DXR word mismatch', file=sys.stderr)
    print('expected:', ['%012o' % x for x in exp], file=sys.stderr)
    print('got:     ', ['%012o' % x for x in got], file=sys.stderr)
    raise SystemExit(1)
