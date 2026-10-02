#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('bad DXR length')
    return [int.from_bytes(data[i:i + 8], 'little') & MASK
            for i in range(0, len(data), 8)]

words = read_words(sys.argv[1])
if len(words) < 6:
    raise SystemExit('short DXR')
image_words = (words[1] >> 18) & HALF
if image_words != 4:
    raise SystemExit('literal dedup failed: expected 4 image words, got %d' % image_words)
image = words[2:2 + image_words]
if (image[0] & HALF) != 3 or (image[1] & HALF) != 3:
    raise SystemExit('literal references do not share one pool entry')
if image[3] != 0o12345:
    raise SystemExit('literal value mismatch')
