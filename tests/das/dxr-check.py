#!/usr/bin/env python3
import sys
MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

def six(s):
    w = 0
    for ch in s:
        w = (w << 6) | (ord(ch) - 32)
    return w & HALF

def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('DXR host container length is not a word multiple')
    return [int.from_bytes(data[i:i+8], 'little') & MASK
            for i in range(0, len(data), 8)]

if len(sys.argv) != 6:
    raise SystemExit('usage: dxr-check.py file image_words bss_words entry reloc_csv')
path = sys.argv[1]
exp_image = int(sys.argv[2], 0)
exp_bss = int(sys.argv[3], 0)
exp_entry = int(sys.argv[4], 0)
relocs = [] if sys.argv[5] == '-' else [int(x, 0) for x in sys.argv[5].split(',') if x]
words = read_words(path)
if len(words) < 3:
    raise SystemExit('DXR too short')
magic = words[0] >> 18
entry = words[0] & HALF
image_words = words[1] >> 18
bss_words = words[1] & HALF
reloc_words = (image_words + 35) // 36
if magic != six('DXR'):
    raise SystemExit('bad DXR magic')
if entry != exp_entry:
    raise SystemExit('entry mismatch: got %o expected %o' % (entry, exp_entry))
if image_words != exp_image:
    raise SystemExit('image_words mismatch: got %o expected %o' % (image_words, exp_image))
if bss_words != exp_bss:
    raise SystemExit('bss_words mismatch: got %o expected %o' % (bss_words, exp_bss))
if len(words) != 2 + image_words + reloc_words:
    raise SystemExit('wrong DXR word count: got %d expected %d' % (len(words), 2 + image_words + reloc_words))
expected = [0] * reloc_words
for off in relocs:
    if off < 0 or off >= image_words:
        raise SystemExit('bad expected relocation offset %o' % off)
    expected[off // 36] |= 1 << (35 - (off % 36))
got = words[2 + image_words:]
if got != expected:
    print('relocation bitmap mismatch', file=sys.stderr)
    print('expected:', ['%012o' % x for x in expected], file=sys.stderr)
    print('got:     ', ['%012o' % x for x in got], file=sys.stderr)
    raise SystemExit(1)
