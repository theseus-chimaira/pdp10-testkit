#!/usr/bin/env python3
"""Admit 941014 volatile-short compiler oracle without hiding GCC failures.

The untouched original needs hosted malloc/printf; the independent
C89 compiler oracle preserves volatile halfwords and all three address
expressions.  A compiler-failure result is still a constructed oracle.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v21.tsv"
ORIGINAL = "tests/todo/generic/941014-2.c"
COMPANION = "tests/semantic/regression/pdp10-volatile-short-offset-v1.c"
FIELDS = ("original_source", "original_sha256", "historical_disposition",
          "p1_state", "compiler_followup", "evidence_source",
          "gcc_pdp6_baseline", "kcc_pdp6_baseline", "p1_remaining_action")


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    value = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(value)
    return value


PREVIOUS = load("p10tk_p1_resolution_v20", "tools/build-p1-semantic-resolution-v20.py")
EVIDENCE = load("p10tk_p1_941014_real_guest_v1",
                "tools/test-p1-941014-volatile-v1.py")


def expected():
    rows = PREVIOUS.expected()
    EVIDENCE.audit()
    original = [r for r in rows if r["original_source"] == ORIGINAL]
    if (len(original) != 1 or original[0]["p1_state"] != "blocked" or
            original[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("941014 must remain original hosted-runtime blocker")
    row = original[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "hosted-malloc-printf-and-gcc-pointer-cast-opt"
    row["evidence_source"] = ORIGINAL + ";" + COMPANION
    row["p1_remaining_action"] = (
        "Original unmodified 941014 source has two genuine compiler-stdlib "
        "link_fail results: KCC noopt unresolved printf, GCC O0 unresolved "
        "malloc. Independent registered C89 PDP-6 oracle checks the two "
        "18-bit volatile shorts in a 36-bit word, writes/reads back b, "
        "both canaries, exactly three a1 pointer-to-unsigned-long offset "
        "expressions and the +2 versus -30 integer delta. KCC noopt/opt "
        "and GCC O0 guest PASS. GCC O1 guest run_fail at fail_id 11; GCC "
        "O2 and Os guest run_fail at fail_id 16. These real optimized "
        "compiler regression failures must be repaired, not waived. "
        "The original hosted malloc/printf and exact execution remain "
        "unresolved; no synthetic allocator, console or CPU sweep passed.")
    counts = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or counts != {"covered": 50, "blocked": 17}:
        raise ValueError("unreviewed changes to historical P1 construction")
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = expected()
    if args.write:
        with OUT.open("w", encoding="utf-8", newline="") as stream:
            writer = csv.DictWriter(stream, fieldnames=FIELDS,
                                    delimiter="\t", lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
    else:
        with OUT.open(encoding="utf-8", newline="") as stream:
            actual = list(csv.DictReader(stream, delimiter="\t"))
        if actual != rows or tuple(actual[0]) != FIELDS:
            raise ValueError("live P1 v21 does not match native source evidence")
    print("P1 semantic resolution v21: PASS (50 covered, 0 partial, "
          "17 blocked; 3 GCC optimization guest failures retained)")


if __name__ == "__main__":
    main()
