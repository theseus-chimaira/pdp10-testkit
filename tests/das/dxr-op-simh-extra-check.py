#!/usr/bin/env python3
import sys

MASK36 = (1 << 36) - 1
HALF18 = (1 << 18) - 1

def mem(op, ac, y):
    return ((op & 0o777) << 27) | ((ac & 0o17) << 23) | (y & HALF18)

normal = [
    (0o052, 0o1, 0o1), (0o053, 0o2, 0o2),
    (0o100, 0o3, 0o3), (0o102, 0o4, 0o4),
    (0o103, 0o5, 0o5), (0o104, 0o6, 0o6),
    (0o106, 0o7, 0o7), (0o107, 0o10, 0o10),
    (0o247, 0o11, 0o11),
]
fixed = [
    (0o254, 0o01, 0o12), (0o254, 0o02, 0o13),
    (0o254, 0o05, 0o14), (0o254, 0o06, 0o15),
    (0o254, 0o07, 0o16), (0o254, 0o12, 0o17),
    (0o254, 0o14, 0o20), (0o254, 0o15, 0o21),
    (0o255, 0o01, 0o22), (0o255, 0o02, 0o23),
    (0o255, 0o04, 0o24), (0o255, 0o06, 0o25),
    (0o255, 0o10, 0o26),
]
ks = [
    (0o700, 0o1, 0o27),
    (0o701, 0o00, 0o30), (0o701, 0o01, 0o31),
    (0o701, 0o02, 0o32), (0o701, 0o03, 0o33),
    (0o701, 0o04, 0o34), (0o701, 0o05, 0o35),
    (0o702, 0o00, 0o36), (0o702, 0o01, 0o37),
    (0o702, 0o02, 0o40), (0o702, 0o03, 0o41),
    (0o702, 0o04, 0o42), (0o702, 0o05, 0o43),
    (0o702, 0o06, 0o44), (0o702, 0o07, 0o45),
    (0o702, 0o10, 0o46), (0o702, 0o11, 0o47),
    (0o702, 0o12, 0o50), (0o702, 0o13, 0o51),
    (0o702, 0o14, 0o52), (0o702, 0o15, 0o53),
    (0o702, 0o16, 0o54), (0o702, 0o17, 0o55),
    (0o704, 0o2, 0o56), (0o705, 0o3, 0o57),
    (0o710, 0o4, 0o60), (0o711, 0o5, 0o61),
    (0o712, 0o6, 0o62), (0o713, 0o7, 0o63),
    (0o714, 0o10, 0o64), (0o715, 0o11, 0o65),
    (0o720, 0o12, 0o66), (0o721, 0o13, 0o67),
    (0o722, 0o14, 0o70), (0o723, 0o15, 0o71),
    (0o724, 0o16, 0o72), (0o725, 0o17, 0o73),
]
expected = [mem(*x) for x in normal + fixed + ks]
data = open(sys.argv[1], 'rb').read()
if len(data) % 8:
    raise SystemExit('bad DXR length')
words = [int.from_bytes(data[i:i + 8], 'little') & MASK36
         for i in range(0, len(data), 8)]
if len(words) < 2 + len(expected) or (words[1] >> 18) != len(expected):
    raise SystemExit('unexpected image size')
if words[2:2 + len(expected)] != expected:
    for i, (got, want) in enumerate(zip(words[2:], expected)):
        if got != want:
            raise SystemExit('SIMH opcode mismatch at %d: %012o != %012o' %
                             (i, got, want))
    raise SystemExit('SIMH opcode mismatch')
print('DAS SIMH extra opcode contract passed')
