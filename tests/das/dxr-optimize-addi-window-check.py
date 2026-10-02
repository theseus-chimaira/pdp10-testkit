#!/usr/bin/env python3
import sys

MASK = (1 << 36) - 1
HALF = (1 << 18) - 1

def read_words(path):
    data = open(path, "rb").read()
    if len(data) % 8:
        raise SystemExit("partial host word")
    return [int.from_bytes(data[i:i + 8], "little") & MASK
            for i in range(0, len(data), 8)]

words = read_words(sys.argv[1])
image_words = (words[1] >> 18) & HALF
if image_words != 12:
    raise SystemExit("ADDI overflow-state image is %d words, expected 12" %
                     image_words)
image = words[2:2 + image_words]

def op(i):
    return (image[i] >> 27) & 0o777

def ac(i):
    return (image[i] >> 23) & 0o17

def y(i):
    return image[i] & HALF

# ADD can overflow before the following temporary overwrite.  The preceding
# MOVEI is therefore trap-visible and must not be folded into ADDI.
if (op(0), ac(0), op(1), ac(1), op(2), ac(2)) != \
        (0o201, 2, 0o270, 1, 0o201, 2):
    raise SystemExit("delayed MOVEI/ADD was folded across overflow state")
# A faultable overwrite is not proof that the temporary is dead either.
if (op(3), ac(3), op(4), ac(4), op(5), ac(5)) != \
        (0o201, 3, 0o270, 4, 0o200, 3):
    raise SystemExit("delayed MOVEI/ADD crossed a faultable overwrite")
# A control-flow boundary likewise leaves the original sequence intact.
if (op(6), ac(6), op(7), ac(7), op(8), ac(8)) != \
        (0o201, 5, 0o270, 6, 0o200, 5):
    raise SystemExit("delayed MOVEI/ADD crossed a control-flow boundary")
if op(9) != 0o254 or image[10] != 7 or image[11] != 11:
    raise SystemExit("ADDI overflow-state tail mismatch")

# The original MOVEI still references target and must retain relocation.
relmap = words[2 + image_words]
if (relmap & (1 << 35)) == 0:
    raise SystemExit("preserved MOVEI lost relocation")

print("DAS delayed ADDI overflow-state regression passed")
