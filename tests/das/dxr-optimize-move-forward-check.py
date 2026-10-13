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
    raise SystemExit('MOVE forwarding image is %d words, expected 7' %
                     image_words)
image = words[2:2 + image_words]
first = image[0]
if ((first >> 27) & 0o777) != 0o200 or ((first >> 23) & 0o17) != 6:
    raise SystemExit('dead temporary MOVE was not forwarded to destination AC')
if ((first >> 18) & 0o17) != 4:
    raise SystemExit('forwarded MOVE lost indexed effective address')
# The second sequence must remain three instructions: its overwrite uses the
# temporary as an index, so eliminating the temporary would change the EA.
if ((image[2] >> 23) & 0o17) != 5 or ((image[3] >> 23) & 0o17) != 7:
    raise SystemExit('unsafe MOVE forwarding changed protected sequence')
if ((image[4] >> 23) & 0o17) != 5 or ((image[4] >> 18) & 0o17) != 5:
    raise SystemExit('self-indexed overwrite was unexpectedly folded')
relmap = words[2 + image_words]
if (relmap & (1 << 35)) == 0:
    raise SystemExit('forwarded indexed MOVE lost relocation')
print('DAS delayed MOVE forwarding contract passed')
