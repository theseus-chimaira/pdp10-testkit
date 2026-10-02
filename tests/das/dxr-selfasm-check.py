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

words = read_words(sys.argv[1])
if len(words) < 4:
    raise SystemExit('DXR is too short')
magic = words[0] >> 18
entry = words[0] & HALF
image_words = words[1] >> 18
bss_words = words[1] & HALF
reloc_words = (image_words + 35) // 36
if magic != six('DXR'):
    raise SystemExit('bad DXR magic')
if image_words == 0:
    raise SystemExit('empty image')
if entry >= image_words:
    raise SystemExit('entry outside image')
if len(words) != 2 + image_words + reloc_words:
    raise SystemExit('wrong DXR word count')
if bss_words != 0:
    raise SystemExit('unexpected bss in KCC self-assembly smoke')
reloc = words[2 + image_words:]
if not any(reloc):
    raise SystemExit('KCC self-assembly DXR has no relocations')
