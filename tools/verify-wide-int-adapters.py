#!/usr/bin/env python3
"""Verify the frozen 71-bit/72-bit representation adapters and arithmetic vectors."""

MASK36 = (1 << 36) - 1
MASK72 = (1 << 72) - 1
SIGN36 = 1 << 35
LOW35 = SIGN36 - 1


def words71_to_raw(hi, lo):
    return (((hi >> 1) | (hi & SIGN36)) & MASK36,
            (((hi & 1) << 35) | (lo & LOW35)) & MASK36)


def raw_to_words71(hi, lo):
    top = (hi >> 34) & 3
    if top not in (0, 3):
        return None
    sign = hi & SIGN36
    return (((hi << 1) | (lo >> 35)) & MASK36,
            sign | (lo & LOW35))


def pair(value):
    value &= MASK72
    return ((value >> 36) & MASK36, value & MASK36)


def value(p):
    return ((p[0] & MASK36) << 36) | (p[1] & MASK36)


def trunc_div(a, b):
    q = abs(a) // abs(b)
    return -q if (a < 0) != (b < 0) else q


def signed(v):
    return v - (1 << 72) if v & (1 << 71) else v


normalized = [
    (0, 0),
    (0, 1),
    (0, LOW35),
    (1, 0),
    (SIGN36 - 1, LOW35),
    (SIGN36, SIGN36),
    (MASK36, MASK36),
]
for original in normalized:
    raw = words71_to_raw(*original)
    restored = raw_to_words71(*raw)
    if restored != original:
        raise SystemExit("71/72 adapter round trip failed: %r -> %r -> %r" %
                         (original, raw, restored))

for raw in [(1 << 34, 0), ((1 << 35) | 0, 0)]:
    if raw_to_words71(*raw) is not None:
        raise SystemExit("out-of-range raw72 accepted: %r" % (raw,))

vectors = [0, 1, 2, (1 << 35) - 1, 1 << 35, (1 << 36) - 1,
           1 << 36, (1 << 70) - 1, 1 << 70, (1 << 71) - 1,
           1 << 71, MASK72]
for a in vectors:
    for b in vectors:
        if value(pair(a + b)) != ((a + b) & MASK72):
            raise SystemExit("raw72 add vector failed")
        if value(pair(a * b)) != ((a * b) & MASK72):
            raise SystemExit("raw72 multiply vector failed")
        if b:
            q, r = divmod(a, b)
            if q * b + r != a or r >= b:
                raise SystemExit("raw72 unsigned division vector failed")
            sa = signed(a)
            sb = signed(b)
            if sb:
                sq = trunc_div(sa, sb)
                sr = sa - sq * sb
                if ((sq * sb + sr) & MASK72) != (a & MASK72):
                    raise SystemExit("raw72 signed division vector failed")

print("wide integer adapter and arithmetic vectors: PASS")
