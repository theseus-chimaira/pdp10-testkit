#!/usr/bin/env python3
"""Close the unchanged original conversion.c after all six PDP-6 PASS.

The previous 67 original identities, historical classifications and
old genuine compiler failures remain frozen.  Only the verified
conversion.c live construction state advances from blocked to covered.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261121-v29.tsv"
SOURCE = "tests/semantic/upstream/pdp10/pdp10/conversion.c"
COMPANIONS = (
    "tests/semantic/regression/pdp10-libgcc-di-float-abi-v1.c",
    "tests/semantic/regression/pdp10-conversion-original-line-v1.c",
    "tests/semantic/regression/pdp10-conversion-gnu71-stages-v1.c",
    "tests/semantic/regression/pdp10-conversion-gnu71-fixstage-v1.c",
)
FIELDS = ("original_source", "original_sha256", "historical_disposition",
          "p1_state", "compiler_followup", "evidence_source",
          "gcc_pdp6_baseline", "kcc_pdp6_baseline", "p1_remaining_action")


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


PREVIOUS = load_module("p10tk_p1_semantic_v28",
                       "tools/build-p1-semantic-resolution-v28.py")
EVIDENCE = load_module("p10tk_p1_conversion_full_v1",
                       "tools/build-p1-conversion-full-v1.py")


def expected():
    rows = PREVIOUS.expected()
    native = EVIDENCE.audit()
    full = [r for r in native if r["role"] == "original-full"]
    if (len(full) != 6 or
            {r["profile"] for r in full} != set(EVIDENCE.PROFILES) or
            any(r["status"] != "pass" or r["source"] != SOURCE
                for r in full)):
        raise ValueError("unchanged original six-profile PASS not authenticated")
    target = [row for row in rows if row["original_source"] == SOURCE]
    if (len(target) != 1 or target[0]["p1_state"] != "blocked" or
            target[0]["historical_disposition"] != "libc-linkage" or
            target[0]["original_sha256"] != EVIDENCE.SOURCES[SOURCE] or
            target[0]["gcc_pdp6_baseline"] != "link_fail" or
            target[0]["kcc_pdp6_baseline"] != "run_fail"):
        raise ValueError("immutable original conversion.c historical identity lost")
    target[0]["p1_state"] = "covered"
    target[0]["compiler_followup"] = "none"
    target[0]["evidence_source"] = ";".join((SOURCE,) + COMPANIONS)
    target[0]["p1_remaining_action"] = (
        "The unchanged historical GNU conversion.c source, including "
        "its full signed/unsigned 36-bit and GNU 71-bit SF/DF cast "
        "assertions, compiles, links and PASSes all six native PDP-6 "
        "KCC noopt/opt and GCC O0/O1/O2/Os guest profiles with the "
        "real compiler-owned libc/libgcc ABI. The KCC target-width "
        "folding, D-format literals and exact signed 36-bit SI/DF "
        "runtime are corrected. GCC's six genuine 71-bit libgcc1 "
        "conversion members now provide complete native PDP-6 "
        "signed/unsigned integer/float and double directions; direct "
        "71-bit-to-SF rounding uses nearest/ties-to-even with the full "
        "71-bit guard/sticky input. The unchanged original, unchanged "
        "assertion-line diagnostic, C89 raw helper ABI oracle and both "
        "original GNU 71-bit sections have 24 actual PDP-6 guest PASS "
        "with source/installed compiler hashes, linker maps and SIMH "
        "HALTs authenticated by the versioned 129-artifact archive "
        "and 17 negative controls. All eight previous conversion "
        "companions still PASS all six profiles (48 further native "
        "guest PASS). The old genuine GCC missing-symbol and guest "
        "run_fail/timeout results, as well as earlier KCC failures, "
        "remain independently pinned and are not relabeled. This "
        "closes P1 original-source construction for PDP-6 only; other "
        "CPUs and the full compiler/CPU optimization sweep remain "
        "unverified until all other P1 sources are constructed.")
    states = collections.Counter(row["p1_state"] for row in rows)
    if len(rows) != 67 or states != {"covered": 56, "blocked": 11}:
        raise ValueError("P1 v29 may close only one original source")
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = expected()
    if args.write:
        with OUT.open("w", encoding="ascii", newline="") as f:
            writer = csv.DictWriter(f, fieldnames=FIELDS, delimiter="\t",
                                    lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
    else:
        with OUT.open(encoding="ascii", newline="") as f:
            actual = list(csv.DictReader(f, delimiter="\t"))
        if actual != rows or tuple(actual[0]) != FIELDS:
            raise ValueError("P1 conversion.c closure ledger differs from guest evidence")
    print("P1 semantic resolution v29: PASS (56 covered, 0 partial, "
          "11 blocked; unchanged conversion.c six native PDP-6 PASS)")


if __name__ == "__main__":
    main()
