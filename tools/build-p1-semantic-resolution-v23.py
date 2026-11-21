#!/usr/bin/env python3
"""Cover 20020406 reachable recursion while preserving hosted blockers.

The original still lacks compiler-libc malloc/calloc and printf.
The new C89 companion exercises the real swapped-output recursion in
six native compiler profiles; no runtime provider is substituted.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v23.tsv"
ORIGINAL = "tests/todo/generic/20020406-1.c"
COMPANION = "tests/semantic/regression/pdp10-duptree-recursive-pointer-swap-v1.c"
FIELDS = ("original_source", "original_sha256", "historical_disposition",
          "p1_state", "compiler_followup", "evidence_source",
          "gcc_pdp6_baseline", "kcc_pdp6_baseline", "p1_remaining_action")


def import_from(path, name):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    loaded = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(loaded)
    return loaded


PREVIOUS = import_from("tools/build-p1-semantic-resolution-v22.py",
                       "p10tk_p1_resolution_v22")
EVIDENCE = import_from("tools/test-p1-20020406-recursive-swap-v1.py",
                       "p10tk_20020406_recursive_v1")


def expected():
    rows = PREVIOUS.expected()
    EVIDENCE.audit()
    old = [row for row in rows if row["original_source"] == ORIGINAL]
    if (len(old) != 1 or old[0]["p1_state"] != "blocked" or
            old[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("original 20020406 hosted dependency must be blocked")
    row = old[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "hosted-malloc-calloc-printf-original-runtime"
    row["evidence_source"] = ORIGINAL + ";" + COMPANION
    row["p1_remaining_action"] = (
        "The unmodified original 20020406 is still link_fail with "
        "KCC PDP-6 noopt and GCC PDP-6 O0 against compiler stdlib: "
        "dlink undefined malloc; the original also requires hosted "
        "calloc and printf. Separate C89 compiler "
        "oracle uses static original-degree/coefficients structures "
        "and preserves the reachable exact four-argument recursive "
        "DUPFFexgcd(gcofac, fcofac, g, f) expression and early "
        "return on f->coeffs[0]==0. The two invocations, reversed "
        "output-slot pointer addresses, swapped data inputs, return "
        "identity, untouched cofactor sentinels and coefficient "
        "arrays are explicitly asserted. Six real KCC/GCC PDP-6 "
        "native guest profiles PASS. The historical unreachable "
        "algebra, original malloc/calloc/printf execution and other "
        "CPUs remain untested; no stubs or DAIMOS libc were linked.")
    counter = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or counter != {"covered": 52, "blocked": 15}:
        raise ValueError("unexpected historical P1 construction count")
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = expected()
    if args.write:
        with OUT.open("w", encoding="utf-8", newline="") as output:
            writer = csv.DictWriter(output, fieldnames=FIELDS,
                                    delimiter="\t", lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
    else:
        with OUT.open(encoding="utf-8", newline="") as stream:
            actual = list(csv.DictReader(stream, delimiter="\t"))
        if actual != rows or tuple(actual[0]) != FIELDS:
            raise ValueError("P1 v23 ledger disagrees with authentic guest evidence")
    print("P1 semantic resolution v23: PASS (52 covered, 0 partial, "
          "15 blocked; hosted services remain unresolved)")


if __name__ == "__main__":
    main()
