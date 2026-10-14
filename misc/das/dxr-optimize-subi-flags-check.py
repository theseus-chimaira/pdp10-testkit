#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

data = open(sys.argv[1], "rb").read()
words = [int.from_bytes(data[i:i + 8], "little") & MASK
         for i in range(0, len(data), 8)]
n = (words[1] >> 18) & HALF
image = words[2:2 + n]

if n != 5:
    raise SystemExit("SUBI flag regression image is %d words, expected 5" % n)

def op(i):
    return (image[i] >> 27) & 0o777

def ac(i):
    return (image[i] >> 23) & 0o17

def y(i):
    return image[i] & HALF

expected = [
    (0o201, 1, 7),
    (0o275, 1, 2),
    (0o201, 2, 2),
    (0o275, 2, 2),
    (0o254, 4, 0),
]
for i, want in enumerate(expected):
    got = (op(i), ac(i), y(i))
    if got != want:
        raise SystemExit("SUBI flag regression word %d: %r != %r" %
                         (i, got, want))

print("DAS SUBI architectural-flags regression passed")
