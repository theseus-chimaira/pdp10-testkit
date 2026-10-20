#!/usr/bin/env python3
"""Independent DEC 166 EMNF normalization model for PDP-6 FP case 9.

The normalization sequence follows FD-D-166-0-EMNF, preserved at
refs/hardware/dec166-emnf-normalize-return-v1.pdf.  It is intentionally
separate from the AAP emulator and does not rewrite the failing 24-case
mathematical regression.  Optionally check the recorded AAP -t pulse log.
"""

import re
import sys
from pathlib import Path


WORD_MASK = (1 << 36) - 1
SIGN = 1 << 35
BIT_1 = 1 << 34
BIT_9 = 1 << 26
SCALE_MASK = 0o777


def shift_right(ar, mq):
    """EMNF NRT0: sign-preserving AR/MQ right shift, AR35 into MQ1."""
    return ((ar >> 1) | (ar & SIGN),
            (mq >> 1) | (ar & SIGN) | ((ar & 1) << 34))


def shift_left(ar, mq):
    """EMNF NRT2: MQ1 enters AR35; zero enters MQ35."""
    return (((ar << 1) & WORD_MASK) | (ar & SIGN) |
            ((mq & BIT_1) >> 34),
            ((mq << 1) & WORD_MASK) | (ar & SIGN))


def ar_fp_half(ar):
    return not (ar & 0o377777777) and bool(ar & BIT_9)


def normalized(ar):
    return ar_fp_half(ar) or bool(ar & BIT_9) != bool(ar & SIGN)


def fat_entry():
    """Case-9 FAD alignment per DEC FDAS: 27 right shifts, then add.

    The negative operand's stored exponent is complemented; the smaller
    positive fraction is moved into AR/MQ, while the larger operand is
    sign-extended into MB. This is intentionally limited to case 9.
    """
    large_negative = 0o543400000000
    small_positive = 0o201400000000
    fraction_mask = (1 << 27) - 1
    sc = (~(large_negative >> 27)) & 0o377
    small_exponent = (small_positive >> 27) & 0o377
    shifts = sc - small_exponent
    if shifts != 27:
        raise AssertionError("Unexpected FAT alignment shift count")
    ar = small_positive & fraction_mask
    mq = 0
    for _ in range(shifts):
        ar, mq = shift_right(ar, mq)
    mb = (large_negative & fraction_mask) | (0o777 << 27)
    ar = (ar + mb) & WORD_MASK
    return ar, mq, sc


def model():
    ar, mq, sc = fat_entry()
    if (ar, mq, sc) != (0o777400000000, 0o200000000000, 0o234):
        raise AssertionError("FAT entry value differs from original trace")
    nrf3 = False
    rounded_instruction = True
    checkpoints = []

    def record(pulse):
        checkpoints.append((pulse, ar, mq, sc))

    for _ in range(4):
        # EMNF NRT0: SC+1 and AR/MQ right shift.
        sc = (sc + 1) & SCALE_MASK
        ar, mq = shift_right(ar, mq)
        record("nrt0")
        if ar == 0 and not (mq & BIT_1):
            raise AssertionError("Unexpected zero result in case 9")

        # NRT1: SC complement; NRT1 decision selects NRT2 or NRT3.
        sc = (~sc) & SCALE_MASK
        record("nrt1")
        for _ in range(36):
            if normalized(ar):
                break
            sc = (sc + 1) & SCALE_MASK
            ar, mq = shift_left(ar, mq)
            record("nrt2")
        else:
            raise AssertionError("Normalization did not terminate")

        # EMNF NRT3: conditional scale complement and rounding branch.
        do_round = rounded_instruction and bool(mq & BIT_1) and not nrf3
        if not (ar & SIGN) or do_round:
            sc = (~sc) & SCALE_MASK
        record("nrt3")
        if do_round:
            # NRT5: AR+1. NRT5A: set NRF3, repeat normalization.
            ar = (ar + 1) & WORD_MASK
            nrf3 = True
            record("nrt5")
            continue

        # NRT4: replace exponent with SC1-8, preserving sign/fraction.
        ar = (ar & 0o400777777777) | ((sc & 0o377) << 27)
        record("nrt4")
        return ar, checkpoints
    raise AssertionError("Too many normalization passes")


STATE_RE = re.compile(
    r"((?:  pulse [a-z0-9_]+\n)+)"
    r"  AR/([0-7]{12}) MQ/([0-7]{12})\.[01] "
    r"MB/[0-7]{12} MA/[0-7]{6} SC/([0-7]{3})")


def check_trace(path, checkpoints):
    text = path.read_text(encoding="ascii", errors="replace")
    blocks = []
    for match in STATE_RE.finditer(text):
        pulses = re.findall(r"  pulse ([a-z0-9_]+)", match.group(1))
        values = tuple(int(part, 8) for part in match.groups()[1:])
        blocks.append((pulses, values))

    start = [i for i, (pulses, _) in enumerate(blocks)
             if "fat10" in pulses]
    if not start:
        raise AssertionError("No FAT10 in pulse trace")
    if blocks[start[-1]][1] != fat_entry():
        raise AssertionError("AAP FAT10 entry differs from DEC FDAS model")
    print("PASS: AAP FAT10 entry matches DEC FDAS alignment model")
    observed = []
    for pulses, values in blocks[start[-1] + 1:]:
        for pulse in pulses:
            if pulse in ("nrt0", "nrt1", "nrt2", "nrt3", "nrt5", "nrt4"):
                observed.append((pulse,) + values)
        if "nrt6" in pulses:
            break
    if observed != checkpoints:
        for i, (expected, actual) in enumerate(zip(checkpoints, observed)):
            if expected != actual:
                raise AssertionError("Pulse %d: DEC model %r, AAP %r" %
                                     (i, expected, actual))
        raise AssertionError("Different pulse lengths: model %d, AAP %d" %
                             (len(checkpoints), len(observed)))
    print("PASS: AAP pulse sequence matches DEC EMNF model (%d states)" %
          len(checkpoints))


def main():
    word, checkpoints = model()
    if word != 0o544000000003:
        raise AssertionError("DEC model result %012o" % word)
    print("PASS: DEC FDAS/EMNF case 9 yields %012o" % word)
    if len(sys.argv) == 2:
        check_trace(Path(sys.argv[1]), checkpoints)
    elif len(sys.argv) != 1:
        raise SystemExit("usage: analyze-aap-pdp6-emnf-case9-v1.py [trace-log]")


if __name__ == "__main__":
    main()
