#!/usr/bin/env python3
"""Close 990628 native record-copy compiler oracle, preserve malloc timeout.

The historic 101-int record, 9-bit memset and SQL fetch loop are
asserted by six genuine companion compiler/guest executions. Original
malloc-dependent PDP-6 noopt/O0 cells remain real timeouts.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v20.tsv"
ORIGINAL = "tests/todo/generic/990628-1.c"
COMPANION = "tests/semantic/regression/pdp10-record-fetch-copy-v1.c"
FIELDS = ("original_source", "original_sha256", "historical_disposition",
          "p1_state", "compiler_followup", "evidence_source",
          "gcc_pdp6_baseline", "kcc_pdp6_baseline", "p1_remaining_action")


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load_module("p10tk_resolution_v19", "tools/build-p1-semantic-resolution-v19.py")
GATE = load_module("p10tk_record_990628_gate_v1",
                   "tools/audit-p1-990628-record-v1.py")


def expected():
    rows = BASE.expected()
    GATE.audit()
    selected = [row for row in rows if row["original_source"] == ORIGINAL]
    if (len(selected) != 1 or selected[0]["p1_state"] != "blocked" or
            selected[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("990628 original still must be hosted-runtime blocked")
    row = selected[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "hosted-malloc-original-runtime"
    row["evidence_source"] = ORIGINAL + ";" + COMPANION
    row["p1_remaining_action"] = (
        "Six real native KCC/GCC PDP-6 guest PASS profiles cover "
        "real linked memset of 9-bit 0x55 bytes to 101 36-bit int "
        "record words, struct assignment through incremented pointer, "
        "two fetches, single store, sqlcode loop termination, every "
        "copied word and destination guards. The unchanged historical "
        "original still links real malloc and memset but times out "
        "under KCC noopt and GCC O0. Compiler oracle is constructed; "
        "hosted malloc/original execution remains unresolved. No "
        "fake allocator or cross-CPU success is claimed.")
    count = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or count != {"covered": 49, "blocked": 18}:
        raise ValueError("unreviewed historical P1 source status changed")
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
            raise ValueError("live P1 v20 ledger differs from original guest evidence")
    print("P1 semantic resolution v20: PASS (49 covered, 0 partial, "
          "18 blocked; full sweep deferred)")


if __name__ == "__main__":
    main()
