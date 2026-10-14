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

def read_labels(path):
    out = {}
    for line in open(path):
        fields = line.split()
        if len(fields) == 2:
            out[fields[0]] = int(fields[1], 8)
    return out

words = read_words(sys.argv[1])
labels = read_labels(sys.argv[2])
n = (words[1] >> 18) & HALF
image = words[2:2 + n]

def op(addr):
    return (image[addr] >> 27) & 0o777

def ac(addr):
    return (image[addr] >> 23) & 0o17

def ea(addr):
    return image[addr] & HALF

for name in ("LMOVE", "LIMMED", "LZERO", "LSELF", "LRET", "LBRANCH",
             "LBT", "LBE", "FOO"):
    if name not in labels:
        raise SystemExit("missing label %s" % name)

p = labels["LMOVE"]
if (op(p), ac(p), op(p + 1), ac(p + 1)) != (0o200, 1, 0o550, 1):
    raise SystemExit("labeled MOVE/unary sequence was rewritten")

p = labels["LIMMED"]
if (op(p), ac(p), ea(p), op(p + 1), ac(p + 1), ea(p + 1)) != \
        (0o201, 2, 3, 0o271, 2, 4):
    raise SystemExit("labeled MOVEI/ADDI sequence was folded")

p = labels["LZERO"]
if (op(p), ac(p), op(p + 1), ac(p + 1), ea(p + 1)) != \
        (0o201, 3, 0o202, 3, 4):
    raise SystemExit("labeled zero/store sequence was folded")

p = labels["LSELF"]
if (op(p), ac(p), ea(p)) != (0o200, 5, 5):
    raise SystemExit("labeled self-MOVE was deleted")

p = labels["LRET"]
if (op(p), ac(p), op(p + 1), ac(p + 1), ea(p + 1), op(p + 2), ac(p + 2)) != \
        (0o201, 7, 0o200, 0o10, 7, 0o201, 7):
    raise SystemExit("labeled temporary-forward sequence was retargeted")

p = labels["LBRANCH"]
if (op(p), ac(p), ea(p), op(p + 1), ea(p + 1)) != \
        (0o326, 0o11, labels["LBT"], 0o254, labels["LBE"]):
    raise SystemExit("labeled conditional JUMP/JRST sequence was folded")

print("DAS labeled XCT-entry optimizer contract passed")
