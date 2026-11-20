#!/usr/bin/env python3
"""Close original 991112 after real C-locale isprint and isspace runtime.

The two historical missing-isprint links remain preserved. The actual
unchanged 991112 and 980707 originals now PASS all six native PDP-6
profiles against a separately installed compiler-owned C-locale library.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v28.tsv"
FIRST = "tests/todo/generic/991112-1.c"
SECOND = "tests/todo/generic/980707-1.c"
COMPANION = "tests/semantic/regression/pdp10-ctype-c-locale-exhaustive-v1.c"
FIELDS = ("original_source", "original_sha256", "historical_disposition",
          "p1_state", "compiler_followup", "evidence_source",
          "gcc_pdp6_baseline", "kcc_pdp6_baseline", "p1_remaining_action")


def import_script(path, module_name):
    spec = importlib.util.spec_from_file_location(module_name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


PREVIOUS = import_script("tools/build-p1-semantic-resolution-v27.py",
                         "p10tk_p1_semantic_v27")
CTYPE = import_script("tools/test-p1-991112-c-locale-v1.py",
                      "p10tk_p1_991112_c_locale_v1")


def expected():
    rows = PREVIOUS.expected()
    CTYPE.audit()
    first = [r for r in rows if r["original_source"] == FIRST]
    second = [r for r in rows if r["original_source"] == SECOND]
    if (len(first) != 1 or len(second) != 1 or
            first[0]["p1_state"] != "blocked" or
            first[0]["historical_disposition"] != "libc-linkage" or
            second[0]["p1_state"] != "covered" or
            second[0]["compiler_followup"] != "hosted-isspace-target-ctype"):
        raise ValueError("P1 v27 isprint/isspace historical state changed")
    first[0]["p1_state"] = "covered"
    first[0]["compiler_followup"] = "none"
    first[0]["evidence_source"] = FIRST + ";" + COMPANION
    first[0]["p1_remaining_action"] = (
        "Real compiler-owned C-locale isprint and isspace are provided "
        "by the independent versioned libp10ctype-c-locale-v1.a. "
        "The original 991112-1.c is unchanged, including its indirect "
        "rl_character_len call, printable 'a' and nonprintable octal "
        "002 assertions. The two historical compiler-library "
        "link_fail on undefined isprint remain pinned as original "
        "pre-provider evidence. After installation, native PDP-6 "
        "KCC noopt/opt and GCC O0/O1/O2/Os guests all PASS. An "
        "independent oracle passes all six compiler profiles while "
        "checking the complete 0000..0777 unsigned 9-bit C-locale "
        "domain for both real functions, EOF and original inputs. "
        "The compiler C locale implementation is genuine, not an "
        "oracle-local function. Neither full Unicode/UTF-9 ctype "
        "nor untested target CPUs are claimed complete. "
        "P1 original-source construction and native PDP-6 execution "
        "are complete; full compiler/CPU sweep remains deferred.")
    second[0]["compiler_followup"] = "none"
    second[0]["evidence_source"] += ";" + COMPANION
    second[0]["p1_remaining_action"] = (
        "The unchanged 980707-1.c original now compiles, links and "
        "PASSes all six native PDP-6 KCC/GCC profiles with real "
        "installed compiler-owned isspace and genuine target "
        "ctype.h; no ASCII-only test substitute or DAIMOS libc is "
        "selected. Historical original missing-header/isspace "
        "failures and original optimized GCC strcpy byte-loss "
        "guest failures remain pinned. The GCC 9-bit STRING_CST "
        "optimizer repair is independently validated. The C-locale "
        "provider has full 9-bit domain/EOF verification by a "
        "separate real-call compiler test. Original P1 source "
        "construction and native PDP-6 execution are complete; "
        "other CPUs and UTF-9 character properties remain outside "
        "this verified scope.")
    counts = collections.Counter(row["p1_state"] for row in rows)
    if len(rows) != 67 or counts != {"covered": 55, "blocked": 12}:
        raise ValueError("P1 v28 must preserve 67 original identities")
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
            raise ValueError("P1 v28 ledger differs from real C-locale guest evidence")
    print("P1 semantic resolution v28: PASS (55 covered, 0 partial, "
          "12 blocked; 991112 and 980707 originals PASS on PDP-6)")


if __name__ == "__main__":
    main()
