#!/usr/bin/env python3
"""Record the 980707 compiler-oracle construction, not hosted success.

The unchanged original needs target ctype.h and isspace. The native
token scanner and independent literal strcpy oracle preserve three
genuine optimized GCC guest failures each; no synthetic runtime.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v24.tsv"
ORIGINAL = "tests/todo/generic/980707-1.c"
SCANNER = "tests/semantic/regression/pdp10-space-token-pointer-v1.c"
STRCPY = "tests/semantic/regression/pdp10-strcpy-space-literal-v1.c"
FIELDS = ("original_source", "original_sha256", "historical_disposition",
          "p1_state", "compiler_followup", "evidence_source",
          "gcc_pdp6_baseline", "kcc_pdp6_baseline", "p1_remaining_action")


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


PREVIOUS = load("tools/build-p1-semantic-resolution-v23.py",
                "p10tk_p1_resolution_v23")
EVIDENCE = load("tools/test-p1-980707-space-token-v1.py",
                "p10tk_980707_space_token_v1")


def expected():
    rows = PREVIOUS.expected()
    EVIDENCE.audit()
    matches = [row for row in rows if row["original_source"] == ORIGINAL]
    if (len(matches) != 1 or matches[0]["p1_state"] != "blocked" or
            matches[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("original 980707 isspace/header obligation was changed")
    row = matches[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "gcc-optimized-strcpy-literal-and-hosted-ctype"
    row["evidence_source"] = ORIGINAL + ";" + SCANNER + ";" + STRCPY
    row["p1_remaining_action"] = (
        "Unchanged 980707 original under compiler stdlib: KCC PDP-6 "
        "noopt link_fail on real missing isspace; GCC PDP-6 O0 "
        "compile_fail because target ctype.h is missing. The C89 "
        "compiler-only 9-bit token/char-pointer companion preserves "
        "the original two nested scans, arglist pointer stores, "
        "delimiter NUL writes and real compiler strcpy/strcmp, but "
        "recognizes only ASCII space of the historical input, not "
        "the complete isspace predicate. Six native KCC/GCC PDP-6 "
        "guest profiles: KCC noopt/opt and GCC O0 PASS, GCC O1/O2/Os "
        "run_fail at fail_id=8 (first token pointer). An independent "
        "volatile-read compiler-only strcpy literal oracle has the "
        "same 3 PASS/3 GCC run_fail, at fail_id=3 (missing second "
        "character). The three optimized GCC assembly files emit a "
        "single byte store instead of the full literal copy; no "
        "strcpy call. This is a real optimized GCC source-specific "
        "compiler regression, not an isspace or guard failure. "
        "Real hosted ctype contract, original execution, optimized "
        "GCC compiler repair and other CPUs remain unresolved. "
        "Construction covered only; no compiler PASS for failures.")
    count = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or count != {"covered": 53, "blocked": 14}:
        raise ValueError("P1 v24 counts must preserve 67 original identities")
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
            raise ValueError("P1 v24 ledger contradicts real 980707 evidence")
    print("P1 semantic resolution v24: PASS (53 covered, 0 partial, "
          "14 blocked; 3 optimized GCC strcpy failures retained)")


if __name__ == "__main__":
    main()
