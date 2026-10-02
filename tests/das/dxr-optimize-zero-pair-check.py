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


def opcode(word):
    return (word >> 27) & 0o777


def ac(word):
    return (word >> 23) & 0o17


words = read_words(sys.argv[1])
image_words = (words[1] >> 18) & HALF
if image_words != 9:
    raise SystemExit('optimized zero-pair image is %d words, expected 9' %
                     image_words)
image = words[2:2 + image_words]

# MOVEI/MOVEI, SETZ/SETZ, MOVEI/SETZ, and SETZ/MOVEI all fold.
expected = [(1, 2), (3, 4), (5, 6), (7, 0o10)]
for i, pair in enumerate(expected):
    if opcode(image[i]) != 0o403 or ac(image[i]) != pair[0] or \
            (image[i] & HALF) != pair[1]:
        raise SystemExit('zero pair %d was not folded to SETZB' % i)

# A label on the second zeroing instruction is a barrier: SETZ 11, remains.
if opcode(image[4]) != 0o400 or ac(image[4]) != 0o11:
    raise SystemExit('pre-label SETZ was unexpectedly folded')

# A label on the first instruction is also a hard entry barrier.  XCT L1
# executes only SETZ 12, in the original program, so that word must not be
# rewritten by absorbing the following SETZ.
if opcode(image[5]) != 0o400 or ac(image[5]) != 0o12:
    raise SystemExit('labelled-first SETZ was rewritten')

# The following unlabeled SETZ 13, / SETZ 14, pair may still fold.  The final
# repeated SETZ 14, remains because rewriting SETZB 13,14 with it would not be
# the same two-instruction rule.
if opcode(image[6]) != 0o403 or ac(image[6]) != 0o13 or \
        (image[6] & HALF) != 0o14:
    raise SystemExit('post-label zero pair did not fold')
if opcode(image[7]) != 0o400 or ac(image[7]) != 0o14:
    raise SystemExit('final SETZ 14, changed unexpectedly')
if opcode(image[8]) != 0o254:
    raise SystemExit('HALT encoding mismatch')

print('DAS adjacent zero SETZB contract passed')
