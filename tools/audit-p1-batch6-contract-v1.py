#!/usr/bin/env python3
"""Audit source-pinned P1 Batch 6 PDP-6 prerequisite evidence, not P1 closure.

Reads the frozen 9-original assignment and two bounded KCC/GCC probes.
Never executes a compiler or substitutes a target hosted runtime.
"""

import argparse
import collections
import csv
import hashlib
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "docs/PDP10-P1-BATCH6-CONTRACT-20261120-v1.tsv"
FROZEN = ROOT / "docs/PDP10-P1-SOURCE-BATCHES-20261120-v7.tsv"
LIVE = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v8.tsv"
FIELDS = ("slot", "original_source", "source_sha256", "compiler",
          "profile", "status", "reason")
ORIGINALS = (
    "tests/todo/generic/comp-goto-1.c",
    "tests/todo/generic/gofast.c",
    "tests/semantic/upstream/extensions/old.tort.c",
    "tests/todo/generic/pdp10/strct-varg-1b.c",
    "tests/semantic/upstream/extensions/stdio-opt-1.c",
    "tests/semantic/upstream/extensions/stdio-opt-2.c",
    "tests/semantic/upstream/extensions/stdio-opt-3.c",
    "tests/todo/generic/generic/struct-ret-1.c",
    "tests/semantic/upstream/extensions/va-arg-21.c",
)
STAGES = (
    ("compile_fail", "timeout"),
    ("link_fail", "compile_fail"),
    ("compile_fail", "run_fail"),
    ("timeout", "timeout"),
    ("link_fail", "compile_fail"),
    ("link_fail", "link_fail"),
    ("compile_fail", "compile_fail"),
    ("timeout", "compile_fail"),
    ("timeout", "compile_fail"),
)
REASONS = (
    ("kcc-computed-goto-rejection", "simh-wall-timeout"),
    ("missing-stderr", "missing-gcc-stdio-header"),
    ("kcc-packed-pointer-rejection", "non-tops20-guest-abort"),
    ("simh-wall-timeout", "simh-wall-timeout"),
    ("missing-stdout", "missing-gcc-stdio-header"),
    ("missing-builtin-printf", "missing-putchar"),
    ("kcc-fprintf-prototype-conflict", "missing-gcc-stdio-header"),
    ("simh-wall-timeout", "missing-gcc-stdio-header"),
    ("simh-wall-timeout", "missing-gcc-stdio-header"),
)
COUNTS = {"compile_fail": 8, "link_fail": 4, "timeout": 5,
          "run_fail": 1}
REQUIRED_MESSAGES = {
    "kcc-computed-goto-rejection":
        ("Pointer operand for + or - must point to valid object",
         "? KCC - 4 errors detected"),
    "kcc-packed-pointer-rejection":
        ("exact-width packed pointer requires representation-preserving",
         "? KCC - 3 errors detected"),
    "kcc-fprintf-prototype-conflict":
        ("Type of parameter #2 conflicts with prior prototype",
         "? KCC - 1 error detected"),
    "missing-gcc-stdio-header":
        ("stdio.h: No such file or directory",),
    "missing-stderr": ("dlink: undefined symbol: stderr",),
    "missing-stdout": ("dlink: undefined symbol: stdout",),
    "missing-builtin-printf":
        ("dlink: undefined symbol: __builtin_printf",),
    "missing-putchar": ("dlink: undefined symbol: putchar",),
}


def read(path):
    with path.open(newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def validate(rows, frozen, live):
    if len(rows) != 18 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("exactly 18 Batch 6 source/profile rows required")
    assigned = [r for r in frozen if r["batch"] == "6"]
    if (len(assigned) != 9 or
            [r["slot"] for r in assigned] != list(map(str, range(1, 10))) or
            any(r["live_state"] != "blocked" for r in assigned)):
        raise ValueError("frozen Batch 6 source slots or states changed")
    live_map = {r["original_source"]: r for r in live}
    seen = set()
    for i, original in enumerate(ORIGINALS):
        source = (ROOT / original).resolve()
        if (not source.is_relative_to(ROOT / "tests") or
                not source.is_file() or
                assigned[i]["original_source"] != original):
            raise ValueError("Batch 6 source moved or missing")
        sha = hashlib.sha256(source.read_bytes()).hexdigest()
        if (assigned[i]["source_sha256"] != sha or
                live_map[original]["original_sha256"] != sha or
                live_map[original]["p1_state"] != "blocked" or
                live_map[original]["historical_disposition"] !=
                "hosted-runtime"):
            raise ValueError("original source/P1 evidence was changed")
        for j, compiler in enumerate(("kcc", "gcc")):
            row = rows[i * 2 + j]
            expected = (str(i + 1), original, sha, compiler,
                        "kcc-pdp6-noopt" if compiler == "kcc"
                        else "gcc-pdp6-o0", STAGES[i][j], REASONS[i][j])
            if tuple(row[k] for k in FIELDS) != expected:
                raise ValueError("source/profile/evidence changed: " +
                                 repr(expected))
            if (original, compiler) in seen:
                raise ValueError("duplicate source/compiler")
            seen.add((original, compiler))
    if collections.Counter(r["status"] for r in rows) != COUNTS:
        raise ValueError("Batch 6 status distribution changed")


def verify_evidence(rows, report_files):
    observed = {}
    for path in report_files:
        for row in read(path):
            key = (row["source"], row["compiler"])
            if key in observed:
                raise ValueError("duplicate actual probe cell: " + repr(key))
            observed[key] = row
    required = {(r["original_source"], r["compiler"]) for r in rows}
    if len(observed) != 18 or set(observed) != required:
        raise ValueError("exactly eighteen source-pinned probe cells required")

    for row in rows:
        key = (row["original_source"], row["compiler"])
        observed_row = observed[key]
        if (observed_row["cpu"] != "pdp6" or
                observed_row["optimization"] !=
                ("-n" if row["compiler"] == "kcc" else "-O0") or
                observed_row["status"] != row["status"]):
            raise ValueError("wrong observed source/profile/stage: " + repr(key))
        path = Path(observed_row["report"])
        if not path.is_file():
            raise ValueError("missing actual compiler/link/guest evidence")
        report = path.read_text(errors="replace")
        reason = row["reason"]
        if reason == "simh-wall-timeout":
            if (not re.search(r"^rc=124$", report, re.M) or
                    not re.search(r"^result=FAIL$", report, re.M) or
                    "HALT instruction" in report or
                    "__P10RUN_EXPECT__ __test_exit" in report):
                raise ValueError("timeout was misclassified as a guest result")
        elif reason == "non-tops20-guest-abort":
            if (not re.search(r"^rc=0$", report, re.M) or
                    not re.search(r"^result=FAIL$", report, re.M) or
                    "HALT instruction" not in report or
                    not re.search(r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                                  r"[^\n]*\t000000000327\b", report)):
                raise ValueError("actual old.tort guest abort not preserved")
            old = (ROOT / row["original_source"]).read_text()
            if ("#ifdef TOPS20" not in old or
                    "exit(256);" not in old):
                raise ValueError("non-TOPS20 end-of-test policy changed")
        elif reason in REQUIRED_MESSAGES:
            for message in REQUIRED_MESSAGES[reason]:
                if message not in report:
                    raise ValueError("missing exact error message: " + message)
            if row["status"] == "link_fail" and (
                    "p10run: link failed" not in report):
                raise ValueError("linker error did not come from dlink")
        else:
            raise ValueError("unknown Batch 6 diagnosis: " + reason)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--results", action="append", type=Path, default=[],
                    help="two disjoint bounded five/four-source probe TSVs")
    args = ap.parse_args()
    rows = read(MANIFEST)
    validate(rows, read(FROZEN), read(LIVE))
    if args.results:
        if len(args.results) != 2:
            ap.error("exactly two bounded probe results are required")
        verify_evidence(rows, args.results)
    print("PASS: P1 Batch 6 (9 pinned originals, 18 PDP-6 cells: "
          "8 compile_fail, 4 link_fail, 5 timeout, 1 run_fail" +
          (", actual diagnostic/guest evidence" if args.results else "") +
          ")")


if __name__ == "__main__":
    main()
