#!/usr/bin/env python3
"""Preserve P1 construction counts; update va-arg-21 KCC repair state.

The unchanged original still needs hosted malloc/vprintf. Retain the
historical failing KCC stdarg evidence, and append the separately
verified installed-header native PASS evidence from the owning fix.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v26.tsv"
ORIGINAL = "tests/semantic/upstream/extensions/va-arg-21.c"
FIELDS = ("original_source", "original_sha256", "historical_disposition",
          "p1_state", "compiler_followup", "evidence_source",
          "gcc_pdp6_baseline", "kcc_pdp6_baseline", "p1_remaining_action")


def import_script(path, name):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


PREVIOUS = import_script("tools/build-p1-semantic-resolution-v25.py",
                         "p10tk_p1_semantic_v25")
REPAIR = import_script("tools/test-kcc-vaend-repair-v1.py",
                       "p10tk_kcc_vaend_repair_v1")


def expected():
    rows = PREVIOUS.expected()
    REPAIR.audit()
    match = [row for row in rows if row["original_source"] == ORIGINAL]
    if (len(match) != 1 or match[0]["p1_state"] != "covered" or
            match[0]["compiler_followup"] !=
            "kcc-stdarg-va_end-sideeffect-and-hosted-malloc-vprintf"):
        raise ValueError("P1 va-arg-21 v25 baseline not preserved")
    row = match[0]
    row["compiler_followup"] = "hosted-malloc-vprintf-and-other-cpu-varargs"
    row["p1_remaining_action"] = (
        "The unchanged va-arg-21 original still links unsuccessfully "
        "with compiler C library: historical KCC PDP-6 noopt "
        "undefined vprintf; GCC PDP-6 O0 undefined malloc. "
        "The C89 independent oracle uses actual va_list and "
        "va_end(**ap_ptr++) then ap_ptr++ over a NULL sentinel, "
        "checks two integer variadic reads and slot identities. "
        "Historical installed KCC stdarg.h (SHA256 "
        "99d3e321cd11dc44db2545be9c5b12f0336dcb12e002b0b504904a7e3723de42) "
        "defined va_end(ap) as ((void)0), causing 2 real KCC native "
        "run_fail at ID 4, while 4 GCC profiles PASS. The owning "
        "KCC repository commit 5fa3510 fixes va_end to ((void)(ap)) "
        "and the corrected header SHA256 "
        "f966aa2588b7d59dbf2bf704ffd87fb67097673455ee77fe86d8a75232f23e7f "
        "was installed into PDP10_PREFIX. Fresh native guest replays "
        "without KCC_INCLUDE_DIR override PASS all 6 va_end profiles "
        "and both KCC noopt/opt variadic-return ABI profiles; "
        "41 SHA256-pinned fixed-version artifacts and 10 negative "
        "controls preserve the repair. Original hosted malloc/vprintf, "
        "other CPUs and full variadic ABI coverage remain unresolved. "
        "Do not relabel the original source as an executed PASS.")
    counts = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or counts != {"covered": 54, "blocked": 13}:
        raise ValueError("P1 v26 must keep historical construction totals")
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rows = expected()
    if args.write:
        with OUT.open("w", encoding="ascii", newline="") as file:
            writer = csv.DictWriter(file, fieldnames=FIELDS, delimiter="\t",
                                    lineterminator="\n")
            writer.writeheader()
            writer.writerows(rows)
    else:
        with OUT.open(encoding="ascii", newline="") as file:
            actual = list(csv.DictReader(file, delimiter="\t"))
        if actual != rows or tuple(actual[0]) != FIELDS:
            raise ValueError("P1 v26 ledger contradicts installed KCC repair")
    print("P1 semantic resolution v26: PASS (54 covered, 0 partial, "
          "13 blocked; KCC va_end fixed, hosted libc unresolved)")


if __name__ == "__main__":
    main()
