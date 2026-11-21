#!/usr/bin/env python3
"""Close 920810 child-copy compiler oracle, retaining original malloc gap.

The six native KCC/GCC guests use the installed compiler C library's
real memcpy and memset.  Hosted malloc is not supplied or emulated.
"""

import argparse
import collections
import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v22.tsv"
ORIGINAL = "tests/todo/generic/920810-1.c"
COMPANION = "tests/semantic/regression/pdp10-memcpy-child-inheritance-v1.c"
FIELDS = ("original_source", "original_sha256", "historical_disposition",
          "p1_state", "compiler_followup", "evidence_source",
          "gcc_pdp6_baseline", "kcc_pdp6_baseline", "p1_remaining_action")


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


PREVIOUS = module("p10tk_p1_resolution_v21", "tools/build-p1-semantic-resolution-v21.py")
EVIDENCE = module("p10tk_p1_920810_child_v1", "tools/test-p1-920810-child-copy-v1.py")


def expected():
    rows = PREVIOUS.expected()
    EVIDENCE.audit()
    matching = [r for r in rows if r["original_source"] == ORIGINAL]
    if (len(matching) != 1 or matching[0]["p1_state"] != "blocked" or
            matching[0]["historical_disposition"] != "hosted-runtime"):
        raise ValueError("920810 original hosted runtime requirement disappeared")
    row = matching[0]
    row["p1_state"] = "covered"
    row["compiler_followup"] = "hosted-malloc-original-runtime"
    row["evidence_source"] = ORIGINAL + ";" + COMPANION
    row["p1_remaining_action"] = (
        "Original 920810 linked using compiler stdlib: genuine KCC noopt "
        "and GCC O0 link_fail on missing malloc, not guest runtime. "
        "Six real native PDP-6 KCC/GCC guests using static child storage "
        "and the real compiler C library memcpy and memset PASS. The "
        "oracle checks exact three-word struct size, 9-bit byte memset "
        "pattern, the three-field copy before fixups, assigned parent "
        "pointer, cleared name and final size, source preservation, "
        "single copy and both guard words. No allocator stub or DAIMOS "
        "libc was used. The original hosted malloc path and other CPU "
        "profiles remain unresolved; this is compiler-oracle "
        "construction, not evidence the hosted program passed.")
    count = collections.Counter(r["p1_state"] for r in rows)
    if len(rows) != 67 or count != {"covered": 51, "blocked": 16}:
        raise ValueError("unexpected P1 construction state change")
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
            raise ValueError("P1 v22 ledger differs from real compiler evidence")
    print("P1 semantic resolution v22: PASS (51 covered, 0 partial, "
          "16 blocked; hosted malloc unresolved)")


if __name__ == "__main__":
    main()
