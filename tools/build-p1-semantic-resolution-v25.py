#!/usr/bin/env python3
"""Close the va-arg-21 compiler-oracle construction, not hosted runtime.

Original malloc/vprintf links fail with the compiler C library.
An independent native compiler test retains KCC's real va_end macro
side-effect failure and four genuine GCC compiler guest passes.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v25.tsv"
ORIGINAL = "tests/semantic/upstream/extensions/va-arg-21.c"
COMPANION = "tests/semantic/regression/pdp10-vaend-pointer-sideeffect-v1.c"
FIELDS = ("original_source", "original_sha256", "historical_disposition",
          "p1_state", "compiler_followup", "evidence_source",
          "gcc_pdp6_baseline", "kcc_pdp6_baseline", "p1_remaining_action")


def import_script(path, name):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


PREVIOUS = import_script("tools/build-p1-semantic-resolution-v24.py",
                         "p10tk_p1_semantic_v24")
EVIDENCE = import_script("tools/test-p1-vaarg21-vaend-v1.py",
                         "p10tk_vaarg21_vaend_v1")


def expected():
    rows = PREVIOUS.expected()
    EVIDENCE.audit()
    matches = [row for row in rows if row["original_source"] == ORIGINAL]
    if (len(matches) != 1 or matches[0]["p1_state"] != "blocked" or
            matches[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("upstream va-arg-21 hosted obligation changed")
    row = matches[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "kcc-stdarg-va_end-sideeffect-and-hosted-malloc-vprintf"
    row["evidence_source"] = ORIGINAL + ";" + COMPANION
    row["p1_remaining_action"] = (
        "The unchanged va-arg-21 original still cannot link with "
        "the compiler-owned C archive: KCC PDP-6 noopt link_fail "
        "on missing vprintf; GCC PDP-6 O0 link_fail on missing malloc. "
        "The native C89 compiler-only companion retains two real "
        "va_list objects, va_start/va_arg, the exact original "
        "va_end(**ap_ptr++) expression, a second ap_ptr++ skipping "
        "the NULL sentinel, a second va_start/va_arg/va_end, two "
        "numeric varargs checks and guard preservation, without "
        "fake malloc, vprintf or va_end. Four genuine GCC PDP-6 "
        "O0/O1/O2/Os guest PASS; both native KCC noopt/opt guests "
        "run_fail at fail_id=4: ap_ptr does not advance at va_end. "
        "The installed KCC stdarg.h defines va_end(ap) as ((void)0), "
        "discarding evaluation of the argument expression, unlike "
        "GCC builtin va_end. This isolates a KCC compiler-header "
        "semantic defect, not an original hosted runtime PASS. "
        "Original printf/heap behavior, KCC repair and other CPUs "
        "remain unverified; the frozen original source is intact.")
    totals = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or totals != {"covered": 54, "blocked": 13}:
        raise ValueError("P1 v25 must preserve all 67 historical source IDs")
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
            raise ValueError("P1 v25 semantic ledger differs from raw guest results")
    print("P1 semantic resolution v25: PASS (54 covered, 0 partial, "
          "13 blocked; native KCC va_end failures preserved)")


if __name__ == "__main__":
    main()
