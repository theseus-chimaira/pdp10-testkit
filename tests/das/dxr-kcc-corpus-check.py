#!/usr/bin/env python3
import sys
MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

EXPECT = {
    'basic': [
        {'entry': 4, 'image': 13, 'bss': 0, 'relocs': [4, 5, 6, 7]},
        {'entry': 7, 'image': 11, 'bss': 0, 'relocs': [10]},
        {'entry': 5, 'image': 9, 'bss': 0, 'relocs': [8]},
    ],
    'data': [
        {'entry': 2, 'image': 4, 'bss': 0, 'relocs': [0, 2]},
    ],
    'branch': [
        {'entry': 12, 'image': 17, 'bss': 0, 'relocs': [5, 8, 12, 13]},
        {'entry': 16, 'image': 18, 'bss': 0, 'relocs': [8, 11, 17]},
        {'entry': 18, 'image': 20, 'bss': 0, 'relocs': [8, 13, 19]},
    ],
}

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

def reloc_bits(words, image_words):
    out = []
    rel = words[2 + image_words:]
    for i, rw in enumerate(rel):
        for j in range(36):
            if rw & (1 << (35 - j)):
                out.append(i * 36 + j)
    return out

if len(sys.argv) != 3:
    raise SystemExit('usage: dxr-kcc-corpus-check.py name file.dxr')
name = sys.argv[1]
if name not in EXPECT:
    raise SystemExit('unknown corpus case: ' + name)
words = read_words(sys.argv[2])
if len(words) < 3:
    raise SystemExit(name + ': DXR too short')
magic = words[0] >> 18
entry = words[0] & HALF
image_words = words[1] >> 18
bss_words = words[1] & HALF
reloc_words = (image_words + 35) // 36
if magic != six('DXR'):
    raise SystemExit(name + ': bad DXR magic')
if len(words) != 2 + image_words + reloc_words:
    raise SystemExit(name + ': wrong DXR word count')
bits = reloc_bits(words, image_words)
got = {
    'entry': entry,
    'image': image_words,
    'bss': bss_words,
    'relocs': bits,
}
if got not in EXPECT[name]:
    raise SystemExit('%s: unrecognized compiler-output profile %r' %
                     (name, got))
