#!/usr/bin/env python3
"""Close 960521 compiler pointer oracle without claiming malloc correctness.

The immutable original times out under two installed native PDP-6
profiles. Six actual companion profiles check the shifted-array stores.
This changes P1 *test construction*, not historical runtime results.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v19.tsv"
ORIGINAL = "tests/todo/generic/960521-1.c"
COMPANION = "tests/semantic/regression/pdp10-shifted-array-boundary-v1.c"


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load_module("p10tk_resolution_v18", "tools/build-p1-semantic-resolution-v18.py")
GATE = load_module("p10tk_shifted_960521_gate_v1",
                   "tools/audit-p1-960521-shifted-array-v1.py")


def expected():
    rows = BASE.expected()
    GATE.audit()
    selected = [row for row in rows if row["original_source"] == ORIGINAL]
    if (len(selected) != 1 or selected[0]["p1_state"] != "blocked" or
            selected[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("unchanged original 960521 P1 status mismatch")
    row = selected[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "hosted-malloc-and-large-memory-contract"
    row["evidence_source"] = ORIGINAL + ";" + COMPANION
    row["p1_remaining_action"] = (
        "Compiler test construction complete for shifted array/pointer "
        "semantics: six actual KCC/GCC PDP-6 PASS executions check the "
        "bounded 4096-word native arrays, *b++ zero, b[-1], both "
        "end guards and every array element. Unchanged original "
        "requires two 32768-word malloc allocations (65536 words "
        "before program overhead) and still times out in both native "
        "PDP-6 noopt/O0 profiles. Real malloc, the full memory contract "
        "and other CPUs are not validated. No allocator stub was used.")
    counts = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or counts != {"covered": 48, "blocked": 19}:
        raise ValueError("unreviewed original P1 source status change")
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = expected()
    fields = BASE.BASE.BASE.BASE.BASE.FIELDS
    if args.write:
        with OUT.open("w", encoding="utf-8", newline="") as stream:
            writer = csv.DictWriter(stream, fieldnames=fields,
                                    delimiter="\t", lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
    else:
        with OUT.open(encoding="utf-8", newline="") as stream:
            actual = list(csv.DictReader(stream, delimiter="\t"))
        if actual != rows or tuple(actual[0]) != fields:
            raise ValueError("live v19 ledger is not supported by exact evidence")
    print("P1 semantic resolution v19: PASS (48 covered, 0 partial, "
          "19 blocked; full sweep deferred)")


if __name__ == "__main__":
    main()
