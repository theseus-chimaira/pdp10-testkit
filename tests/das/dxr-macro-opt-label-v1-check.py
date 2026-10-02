#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1

def read_words(path):
    data = open(path, 'rb').read()
    if len(data) % 8:
        raise SystemExit('bad DXR length')
    return [int.from_bytes(data[i:i + 8], 'little') & MASK
            for i in range(0, len(data), 8)]

words = read_words(sys.argv[1])
count = words[1] >> 18
payload = words[2:2 + count]
if count != 5:
    raise SystemExit('labeled macro expansion changed word count: %d' % count)
if ((payload[1] >> 27) & 0o777) != 0o200:
    raise SystemExit('labeled macro first MOVE was rewritten')
if ((payload[2] >> 27) & 0o777) != 0o550:
    raise SystemExit('labeled macro second HRRZ missing')
labels = {}
for line in open(sys.argv[2], encoding='ascii'):
    fields = line.split()
    if len(fields) >= 2:
        labels[fields[0]] = int(fields[1], 8)
if labels.get('target') != 1 or labels.get('after') != 3:
    raise SystemExit('labeled macro entry locations changed: %r' % labels)
print('DAS labeled macro XCT-entry optimizer contract passed')
