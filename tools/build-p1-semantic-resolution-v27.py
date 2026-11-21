#!/usr/bin/env python3
"""Record the GCC 9-bit string builtin repair without changing P1 counts.

The unchanged 980707 original still requires hosted ctype/isspace.
The original optimizer failures are immutable and the separate native
post-repair evidence establishes GCC PDP-6 O0/O1/O2/Os correctness.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v27.tsv"
ORIGINAL = "tests/todo/generic/980707-1.c"
FIELDS = ("original_source", "original_sha256", "historical_disposition",
          "p1_state", "compiler_followup", "evidence_source",
          "gcc_pdp6_baseline", "kcc_pdp6_baseline", "p1_remaining_action")


def load(path, module_name):
    spec = importlib.util.spec_from_file_location(module_name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


PREVIOUS = load("tools/build-p1-semantic-resolution-v26.py",
                "p10tk_p1_semantic_v26")
REPAIR = load("tools/test-gcc-string9-fold-repair-v1.py",
              "p10tk_gcc_string9_repair_v1")


def expected():
    rows = PREVIOUS.expected()
    REPAIR.audit()
    matches = [r for r in rows if r["original_source"] == ORIGINAL]
    if (len(matches) != 1 or matches[0]["p1_state"] != "covered" or
            matches[0]["compiler_followup"] !=
            "gcc-optimized-strcpy-literal-and-hosted-ctype"):
        raise ValueError("original 980707 P1 v26 GCC follow-up changed")
    row = matches[0]
    row["compiler_followup"] = "hosted-isspace-target-ctype"
    row["p1_remaining_action"] = (
        "The unchanged original 980707-1.c still cannot execute "
        "with compiler-only libc: historical KCC PDP-6 noopt "
        "link_fail missing isspace; GCC PDP-6 O0 compile_fail "
        "missing target ctype.h. Its C89 9-bit token-scanner "
        "companion preserves nested loops, delimiter NUL stores, "
        "pointer slots and real strcpy/strcmp, but deliberately "
        "uses ASCII space only, not an isspace implementation. "
        "The independent literal strcpy oracle and scanner each "
        "previously had 3 GCC O1/O2/Os genuine native run_fail "
        "because GCC c_strlen read the two-host-byte 9-bit constant "
        "through host strlen and treated the leading zero as the "
        "string terminator. That historical evidence is immutable. "
        "The owning gcc-pdp10 builtin code was corrected to count "
        "logical 9-bit units, decline invalid raw-host-string folds "
        "and retain target-aware short constant copy expansion. "
        "Installed cc1 SHA256 "
        "0c33d1e7e93dd372e8b503aabf167c3299acdd830b289199c679ca07a7529b8a "
        "now PASSes all 4 native PDP-6 GCC profiles for each "
        "of the independent strcpy and token scanner oracles. "
        "A new separate string9 constant test also has 4 GCC "
        "PDP-6 PASS against 4 pre-repair GCC run_fail at ID 1; "
        "two KCC run_fail ID 6 for a high 9-bit octal escape "
        "are independently retained, not an original 980707 "
        "regression. Original hosted isspace/ctype remains open, "
        "as do other CPUs and the complete hosted runtime. "
        "Construction is covered only; original is not a guest PASS.")
    counts = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or counts != {"covered": 54, "blocked": 13}:
        raise ValueError("P1 v27 must preserve 67 original identities")
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = expected()
    if args.write:
        with OUT.open("w", encoding="ascii", newline="") as stream:
            writer = csv.DictWriter(stream, fieldnames=FIELDS, delimiter="\t",
                                    lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
    else:
        with OUT.open(encoding="ascii", newline="") as stream:
            actual = list(csv.DictReader(stream, delimiter="\t"))
        if actual != rows or tuple(actual[0]) != FIELDS:
            raise ValueError("P1 v27 ledger contradicts raw GCC repair evidence")
    print("P1 semantic resolution v27: PASS (54 covered, 0 partial, "
          "13 blocked; GCC string9 repaired, hosted ctype unresolved)")


if __name__ == "__main__":
    main()
