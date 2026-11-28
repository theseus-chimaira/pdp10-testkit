#!/usr/bin/env python3
"""Independent rational oracle for the portable D-format runtime ABI."""
import os
import pathlib
import random
import subprocess
import tempfile
from fractions import Fraction

ROOT = pathlib.Path(__file__).resolve().parents[2]
PREFIX = pathlib.Path(os.environ["PDP10_PREFIX"])
MASK = (1 << 35) - 1
SIGN = 1 << 35

def encode(value):
    """Round an exact rational to canonical 62-bit D format."""
    if not value:
        return (0, 0)
    neg = value < 0
    value = abs(value)
    e = 128
    while value >= 1:
        value /= 2
        e += 1
    while value < Fraction(1, 2):
        value *= 2
        e -= 1
    scaled = value * (1 << 62)
    f = round(scaled)
    if f == 1 << 62:
        f >>= 1
        e += 1
    if not 1 <= e <= 255:
        return None
    bits = (e << 62) | f
    if neg:
        bits = (-bits) % (1 << 71)
    h, l = divmod(bits, SIGN)
    return h, l | (h & SIGN)

def value(f, e, neg=False):
    return Fraction(-f if neg else f, 1 << 62) * Fraction(2)**(e-128)

def cases():
    rng = random.Random(62001)
    one = Fraction(1)
    ulp = Fraction(1, 1 << 61)
    edge = [Fraction(0), one, one+ulp, one+2*ulp, 2-ulp,
            ulp, ulp/2, ulp/4, -one, -one-ulp, -2+ulp,
            Fraction(1, 1 << 100), Fraction(1 << 100)]
    pairs = [(a,b) for a in edge for b in edge]
    for _ in range(160):
        pairs.append(tuple(value(rng.randrange(1 << 61, 1 << 62),
                                 rng.randrange(48, 209), rng.randrange(2))
                           for i in range(2)))
    for a,b in pairs:
        for op, r in [("add", a+b), ("sub", a-b), ("mul", a*b),
                      ("div", a/b if b else None)]:
            if r is not None and encode(r) is not None:
                yield op, (*encode(a), *encode(b), *encode(r))

def main():
    rows = list(cases())
    asm = [".text", ".globl main", ".globl fail_id", "main:",
           " movem 17,saved_sp", " movei 15,cases", " movei 16,0765"]
    asm += [" movei %o,0%o" % (i, 0o700+i) for i in range(1,8)]
    asm += ["loop:", " aos fail_id", " movem 15,cursor",
            " move 12,0(15)", " move 10,1(15)", " move 11,2(15)",
            " move 13,3(15)", " move 14,4(15)", " pushj 17,0(12)",
            " came 15,cursor", " jrst failed",
            " caie 16,0765", " jrst failed",
            " came 17,saved_sp", " jrst failed",
            " came 10,5(15)", " jrst failed",
            " came 11,6(15)", " jrst failed"]
    for i in range(1,8):
        asm += [" caie %o,0%o" % (i,0o700+i), " jrst failed"]
    asm += [" addi 15,7", " caie 15,cases_end", " jrst loop",
            " setzm fail_id", " setz 1,", " popj 17,",
            "failed:", " movei 1,1", " popj 17,", ".data",
            "fail_id: .word 0", "saved_sp: .word 0", "cursor: .word 0",
            "cases:"]
    for op, words in rows:
        asm += [".word __kcc_df%s_rt_v62a" % op]
        asm += [".word 0%012o" % w for w in words]
    asm += ["cases_end:"]
    tmp = pathlib.Path(os.environ.get("TMPDIR", str(pathlib.Path.home()/"tmp")))
    tmp.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="df62-oracle-v62a.", dir=tmp) as path:
        d = pathlib.Path(path)
        src = d/"oracle.s"
        src.write_text("\n".join(asm)+"\n", encoding="ascii")
        files = [PREFIX/"lib/kcc"/("kccrt-df%s-v62a.s" % op)
                 for op in ("add","mul","div","core")]
        for cpu in ("pdp6","ka10","ki10","ks10"):
            subprocess.run([str(PREFIX/"bin/p10run"), "--machine", cpu,
                            "--mode", "deposit", "--exec-mode", "step",
                            "--step-limit", "100000000", "--timeout", "30",
                            "--workdir", str(d/cpu), "--name", "df62-oracle",
                            "--expect", "__test_exit=0", "--expect", "fail_id=0",
                            str(ROOT/"support/crt0-upstream-v1.s"), str(src),
                            *map(str, files)], check=True)
            print("%s: %d exact rational cases and ABI checks passed" % (cpu,len(rows)),flush=True)

if __name__ == "__main__":
    main()
