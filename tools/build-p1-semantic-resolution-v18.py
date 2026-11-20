#!/usr/bin/env python3
"""Close 920501-8 test construction without hiding hosted/varargs failures.

The original source's printf path is not usable freestanding.  The separate
source-linked registered companion tests all original va_arg slots and the
exact sprintf result; it FAILs with a real guest checkpoint 41.  The P1
test oracle is complete, but compiler/runtime correctness is NOT claimed.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v18.tsv"
ORIGINAL = "tests/todo/generic/920501-8.c"
COMPANION = "tests/semantic/regression/pdp10-variadic-manyargs-sprintf-v1.c"


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load_module("p10tk_resolution_v17", "tools/build-p1-semantic-resolution-v17.py")
GATE = load_module("p10tk_manyargs_920501_gate_v1",
                   "tools/audit-p1-920501-manyargs-v1.py")


def expected():
    rows = BASE.expected()
    GATE.audit()
    matched = [r for r in rows if r["original_source"] == ORIGINAL]
    if (len(matched) != 1 or matched[0]["p1_state"] != "blocked" or
            matched[0]["historical_disposition"] != "varargs-abi"):
        raise ValueError("source no longer has expected blocked variadic state")
    row = matched[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "sprintf-floating-format-and-varargs-abi"
    row["evidence_source"] = ORIGINAL + ";" + COMPANION
    row["p1_remaining_action"] = (
        "P1 construction complete: exact 16-field original sprintf and "
        "thirteen integer va_arg values checked by a native 9-bit C89 "
        "companion. All six KCC/GCC PDP-6 profiles reach real exit 41 "
        "(negative sprintf at default-precision %f), not a PASS. The "
        "unchanged original still has a KCC SIMH timeout and GCC "
        "dlink duplicate global vsprintf; compiler/runtime and real hosted "
        "printf remain open without stubs or weakened assertions.")
    counts = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or counts != {"covered": 47, "blocked": 20}:
        raise ValueError("unreviewed original-source P1 closure")
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = expected()
    if args.write:
        with OUT.open("w", encoding="utf-8", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=BASE.BASE.BASE.BASE.FIELDS,
                                    delimiter="\t", lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
    else:
        with OUT.open(encoding="utf-8", newline="") as handle:
            actual = list(csv.DictReader(handle, delimiter="\t"))
        if (actual != rows or
                tuple(actual[0]) != BASE.BASE.BASE.BASE.FIELDS):
            raise ValueError("published P1 v18 ledger does not match evidence")
    print("P1 semantic resolution v18: PASS "
          "(47 covered, 0 partial, 20 blocked; sweep deferred)")


if __name__ == "__main__":
    main()
