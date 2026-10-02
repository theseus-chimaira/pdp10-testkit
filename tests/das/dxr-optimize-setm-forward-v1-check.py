#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('partial host word')
    return [int.from_bytes(data[i:i + 8], 'little') & MASK
            for i in range(0, len(data), 8)]

words = read_words(sys.argv[1])
image_words = (words[1] >> 18) & HALF
if image_words != 13:
    raise SystemExit('SETM forwarding image is %d words, expected 13' %
                     image_words)
image = words[2:2 + image_words]

# LDB can fault before overwriting the temporary.  Therefore all three
# SETM/MOVE/LDB sequences must retain the temporary's trap-visible value.
for base, temp, dst, src in ((0, 2, 7, 4), (3, 3, 1, 7), (6, 5, 4, 6)):
    if ((image[base] >> 27) & 0o777) != 0o414 or \
       ((image[base] >> 23) & 0o17) != temp or \
       (image[base] & HALF) != src:
        raise SystemExit('SETM sequence %d changed unexpectedly' % base)
    if ((image[base + 1] >> 27) & 0o777) != 0o200 or \
       ((image[base + 1] >> 23) & 0o17) != dst or \
       (image[base + 1] & HALF) != temp:
        raise SystemExit('SETM sequence %d lost register MOVE' % base)
    if ((image[base + 2] >> 27) & 0o777) != 0o135:
        raise SystemExit('SETM sequence %d lost LDB' % base)

# A label remains an independent forwarding barrier as well.
if ((image[9] >> 27) & 0o777) != 0o414 or ((image[9] >> 23) & 0o17) != 2:
    raise SystemExit('labeled SETM was unexpectedly retargeted')
if ((image[10] >> 27) & 0o777) != 0o200 or ((image[10] >> 23) & 0o17) != 7:
    raise SystemExit('labeled SETM sequence lost MOVE')
if ((image[11] >> 27) & 0o777) != 0o135 or ((image[12] >> 27) & 0o777) != 0o254:
    raise SystemExit('SETM tail encoding mismatch')
print('DAS delayed SETM fault-order contract passed')
