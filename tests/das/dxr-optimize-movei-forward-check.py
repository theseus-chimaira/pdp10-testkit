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
if image_words != 7:
    raise SystemExit('MOVEI forwarding image is %d words, expected 7' %
                     image_words)
image = words[2:2 + image_words]
first = image[0]
if ((first >> 27) & 0o777) != 0o201 or ((first >> 23) & 0o17) != 6:
    raise SystemExit('dead temporary MOVEI was not forwarded to destination AC')
if (first & HALF) != 6:
    raise SystemExit('forwarded MOVEI lost target address')
# A label on the overwrite is a control-flow barrier, so this sequence must
# remain MOVEI 3,TARGET / MOVE 7,3 / MOVE 3,1.
if ((image[2] >> 27) & 0o777) != 0o201 or ((image[2] >> 23) & 0o17) != 3:
    raise SystemExit('label-barrier MOVEI sequence was unexpectedly changed')
if ((image[3] >> 27) & 0o777) != 0o200 or ((image[3] >> 23) & 0o17) != 7:
    raise SystemExit('label-barrier register MOVE was unexpectedly changed')
relmap = words[2 + image_words]
if (relmap & (1 << 35)) == 0:
    raise SystemExit('forwarded MOVEI lost relocation')
print('DAS delayed MOVEI forwarding contract passed')
