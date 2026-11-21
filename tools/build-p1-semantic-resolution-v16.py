#!/usr/bin/env python3
"""Close struct-ret test construction with original and companion evidence.

The original executes real sprintf/strcmp side effects, but does not check
returned X bytes. The existing freestanding companion asserts both direct
and indirect aggregate-return data. Original/compiler failures remain live.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v16.tsv"
ORIGINAL = "tests/todo/generic/generic/struct-ret-1.c"
COMPANION = "tests/semantic/regression/pdp10-large-struct-return-v1.c"


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load_module("p10tk_resolution_v15", "tools/build-p1-semantic-resolution-v15.py")
GATE = load_module("p10tk_structret_hosted_gate_v1",
                   "tools/audit-p1-structret-hosted-v1.py")


def expected():
    rows = BASE.expected()
    GATE.audit()
    selected = [r for r in rows if r["original_source"] == ORIGINAL]
    if (len(selected) != 1 or selected[0]["p1_state"] != "blocked" or
            selected[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("struct-return P1 historical status mismatch")
    row = selected[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "gcc-aggregate-return-abi"
    row["evidence_source"] = ORIGINAL + ";" + COMPANION
    row["p1_remaining_action"] = (
        "Test construction complete: unchanged original uses real sprintf, "
        "strcpy, strcmp and direct/indirect struct-return calls in four "
        "GCC PDP-6 PASS runs. Freestanding companion independently "
        "asserts B arguments and returned X bytes: GCC O0 run_fail "
        "at argument check 3, GCC O1/O2/Os PASS, KCC two SIMH timeouts. "
        "Retain these failures; further cross-CPU/ABI repair is deferred.")
    counts = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or counts != {"covered": 45, "blocked": 22}:
        raise ValueError("unreviewed P1 coverage transition")
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = expected()
    if args.write:
        with OUT.open("w", encoding="utf-8", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=BASE.BASE.FIELDS,
                                    delimiter="\t", lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
    else:
        with OUT.open(encoding="utf-8", newline="") as handle:
            actual = list(csv.DictReader(handle, delimiter="\t"))
        if actual != rows or tuple(actual[0]) != BASE.BASE.FIELDS:
            raise ValueError("v16 ledger does not match verified sources")
    print("P1 semantic resolution v16: PASS "
          "(45 covered, 0 partial, 22 blocked; sweep deferred)")


if __name__ == "__main__":
    main()
