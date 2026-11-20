#!/usr/bin/env python3
"""Close 980605 source intent only after its full-frame companion is proven.

V16 remains immutable.  Nine actual PDP-6 original/companion guest reports,
the intact historical source, and registered compiler profiles are required.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v17.tsv"
ORIGINAL = "tests/todo/generic/980605-1.c"
COMPANION = "tests/semantic/regression/pdp10-stack-tenargs-fp-frame-v1.c"


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load_module("p10tk_resolution_v16", "tools/build-p1-semantic-resolution-v16.py")
GATE = load_module("p10tk_stack_980605_gate_v1",
                   "tools/audit-p1-980605-stack-v1.py")


def expected():
    entries = BASE.expected()
    GATE.audit()
    matches = [r for r in entries if r["original_source"] == ORIGINAL]
    if (len(matches) != 1 or matches[0]["p1_state"] != "blocked" or
            matches[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("unexpected frozen 980605 source disposition")
    row = matches[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "none"
    row["evidence_source"] = ORIGINAL + ";" + COMPANION
    row["p1_remaining_action"] = (
        "P1 original intent covered: unchanged 980605 arithmetic assertion "
        "has three native PDP-6 KCC/GCC PASS executions. An independent "
        "C89 companion tests the original exact 100000-byte/25000-word "
        "live 9-bit stack frame across calls, twenty sequential arguments, "
        "double-to-unsigned-short conversion, and actual sprintf bytes. "
        "Six companion KCC/GCC PDP-6 profiles PASS. Other native CPU "
        "profiles remain pending, never inferred PASS.")
    count = collections.Counter(r["p1_state"] for r in entries)
    if len(entries) != 67 or count != {"covered": 46, "blocked": 21}:
        raise ValueError("unreviewed P1 disposition changes")
    return entries


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--write", action="store_true")
    args = ap.parse_args()
    entries = expected()
    if args.write:
        with OUT.open("w", encoding="utf-8", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=BASE.BASE.BASE.FIELDS,
                                    delimiter="\t", lineterminator="\n")
            writer.writeheader()
            writer.writerows(entries)
    else:
        with OUT.open(encoding="utf-8", newline="") as handle:
            recorded = list(csv.DictReader(handle, delimiter="\t"))
        if (recorded != entries or
                tuple(recorded[0]) != BASE.BASE.BASE.FIELDS):
            raise ValueError("v17 ledger differs from audited source evidence")
    print("P1 semantic resolution v17: PASS "
          "(46 covered, 0 partial, 21 blocked; full sweep deferred)")


if __name__ == "__main__":
    main()
