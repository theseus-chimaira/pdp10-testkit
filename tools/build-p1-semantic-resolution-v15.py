#!/usr/bin/env python3
"""Append verified original 930513-1.c coverage to the frozen v14 P1 ledger.

The v14 generator retains ownership of all earlier source-specific gates.
This version adds one independently archived original-source guest gate;
the historical v14 TSV and original source are not modified.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v15.tsv"
ORIGINAL = "tests/todo/generic/930513-1.c"


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load_module("p10tk_resolution_v14", "tools/build-p1-semantic-resolution-v14.py")
GATE = load_module("p10tk_930513_gate_v1", "tools/audit-p1-930513-original-v1.py")


def expected():
    rows = BASE.resolution_rows()
    GATE.audit()
    matches = [r for r in rows if r["original_source"] == ORIGINAL]
    if (len(matches) != 1 or matches[0]["p1_state"] != "blocked" or
            matches[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("original P1 source no longer has the expected status")
    row = matches[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "none"
    row["evidence_source"] = ORIGINAL
    row["p1_remaining_action"] = (
        "Original source-pinned floating sprintf function-pointer oracle "
        "now PASSes six PDP-6 native KCC/GCC profiles with real formatter "
        "linkage. Original checks both output byte and NUL terminator. "
        "Unexecuted KA10/KI10/KS10 cells and full compiler sweep remain "
        "pending, not implied PASSes.")
    counts = collections.Counter(r["p1_state"] for r in rows)
    if (len(rows) != 67 or counts !=
            {"covered": 44, "blocked": 23}):
        raise ValueError("unexpected v15 source-specific P1 closure counts")
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = expected()
    if args.write:
        with OUT.open("w", encoding="utf-8", newline="") as stream:
            writer = csv.DictWriter(stream, fieldnames=BASE.FIELDS,
                                    delimiter="\t", lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
    else:
        with OUT.open(encoding="utf-8", newline="") as stream:
            actual = list(csv.DictReader(stream, delimiter="\t"))
        if actual != rows or tuple(actual[0]) != BASE.FIELDS:
            raise ValueError("published v15 ledger differs from live gates")
    print("P1 semantic resolution v15: PASS (44 covered, 0 partial, "
          "23 blocked; full sweep deferred)")


if __name__ == "__main__":
    main()
