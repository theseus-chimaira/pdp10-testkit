#!/usr/bin/env python3
"""Verify selected installed-header and executed P1 Batch 4 variadic facts.

Do not treat a KCC guest PASS as evidence that GCC has target stdio.h;
do not treat SIMH rc=124 as a failed guest assertion.  This is a frozen
six-cell prerequisite audit, never a compiler repair or a full sweep.
"""

import argparse
import csv
import hashlib
import os
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "docs/PDP10-P1-BATCH4-VARIADIC-CONTRACT-20261120-v1.tsv"
RESOLUTION = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v8.tsv"
FIELDS = ("source", "source_sha256", "compiler", "profile",
          "status", "diagnosis")
EXPECTED = {
    ("tests/todo/generic/20020412-1.c", "kcc"):
        ("kcc-pdp6-noopt", "compile_fail", "vla-source-rejection"),
    ("tests/todo/generic/20020412-1.c", "gcc"):
        ("gcc-pdp6-o0", "run_fail", "variadic-aggregate-guest-assertion"),
    ("tests/todo/generic/920501-8.c", "kcc"):
        ("kcc-pdp6-noopt", "timeout", "simh-wall-timeout"),
    ("tests/todo/generic/920501-8.c", "gcc"):
        ("gcc-pdp6-o0", "compile_fail", "missing-gcc-stdio-header"),
    ("tests/todo/generic/920726-1.c", "kcc"):
        ("kcc-pdp6-noopt", "pass", "guest-formatting-assertion-pass"),
    ("tests/todo/generic/920726-1.c", "gcc"):
        ("gcc-pdp6-o0", "compile_fail", "missing-gcc-stdio-header"),
}


def read(path):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def header_state(prefix):
    """Inspect only the installed target/compiler search roots."""
    gcc_headers = (
        ROOT / "support/gcc",
        ROOT / "support/common",
        ROOT / "support/include",
        prefix / "pdp10-dec-none/include",
        prefix / "lib/gcc-lib/pdp10-dec-none/3.2/include",
    )
    kcc = prefix / "lib/kcc/include"
    if not (kcc / "stdio.h").is_file() or not (kcc / "stdarg.h").is_file():
        raise ValueError("KCC's installed target stdio/stdarg headers changed")
    if not (gcc_headers[-1] / "stdarg.h").is_file():
        raise ValueError("GCC's installed stdarg header changed")
    return any((directory / "stdio.h").is_file()
               for directory in gcc_headers)


def validate(rows, gcc_stdio_available, resolution):
    if len(rows) != 6 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("expected exactly six ordered contract columns")
    entries = {(r["source"], r["compiler"]): r for r in rows}
    if len(entries) != 6 or set(entries) != set(EXPECTED):
        raise ValueError("missing/duplicate variadic source/compiler identity")
    if gcc_stdio_available:
        raise ValueError("GCC stdio.h is available; refresh actual probes")
    states = {r["original_source"]: r for r in resolution}
    for (source, compiler), row in entries.items():
        if (row["profile"], row["status"], row["diagnosis"]) != (
                EXPECTED[(source, compiler)]):
            raise ValueError("incorrect variadic stage: " + source +
                             " " + compiler)
        path = (ROOT / source).resolve()
        if not path.is_relative_to(ROOT / "tests") or not path.is_file():
            raise ValueError("missing/outside original: " + source)
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        if digest != row["source_sha256"]:
            raise ValueError("original source hash changed: " + source)
        old = states.get(source)
        if (old is None or old["p1_state"] != "blocked" or
                old["original_sha256"] != digest or
                old["historical_disposition"] != "varargs-abi"):
            raise ValueError("staged or KCC pass silently promoted P1: " +
                             source)


def verify_results(rows, results):
    """Optional source/profile-pinned assertion against real probe files."""
    if len(results) != 6:
        raise ValueError("six observed PDP-6 cells required")
    observed = {(r["source"], r["compiler"]): r for r in results}
    if len(observed) != 6 or set(observed) != set(EXPECTED):
        raise ValueError("duplicate or unexpected probe identity")
    for row in rows:
        key = (row["source"], row["compiler"])
        result = observed[key]
        if (result["cpu"] != "pdp6" or
                result["status"] != row["status"] or
                result["optimization"] !=
                ("-n" if row["compiler"] == "kcc" else "-O0")):
            raise ValueError("incorrect installed PDP-6 result: " +
                             repr(key))
        report = Path(result["report"])
        if not report.is_file():
            raise ValueError("missing PDP-6 report/log: " + str(report))
        content = report.read_text(errors="replace")
        tag = row["diagnosis"]
        if tag == "missing-gcc-stdio-header":
            if "stdio.h: No such file or directory" not in content:
                raise ValueError("GCC did not report missing target stdio.h")
        elif tag == "vla-source-rejection":
            if ("Flexible array member" not in content or
                    "errors detected" not in content):
                raise ValueError("KCC did not reject dynamic aggregates")
        elif tag == "simh-wall-timeout":
            if (not re.search(r"^rc=124$", content, flags=re.M) or
                    not re.search(r"^result=FAIL$", content, flags=re.M) or
                    "HALT instruction" in content):
                raise ValueError("SIMH timeout mistaken for executed abort")
        else:
            if (not re.search(r"^rc=0$", content, flags=re.M) or
                    "HALT instruction" not in content):
                raise ValueError("guest did not execute to HALT")
            if tag == "variadic-aggregate-guest-assertion":
                if (not re.search(r"^result=FAIL$", content, flags=re.M) or
                        not re.search(r"__P10RUN_EXPECT__ __test_exit "
                                      r"[^\n]+\n[^\n]*000000000001\b",
                                      content)):
                    raise ValueError("GCC guest abort evidence missing")
            elif tag == "guest-formatting-assertion-pass":
                if (not re.search(r"^result=PASS$", content, flags=re.M) or
                        not re.search(r"__P10RUN_EXPECT__ __test_exit "
                                      r"[^\n]+\n[^\n]*000000000000\b",
                                      content)):
                    raise ValueError("KCC formatting guest PASS not proven")
                symbols = report.with_suffix("").with_suffix(".map")
                # p10run names MAP after its execution name, not the report
                # suffix: tests_name.report.txt -> tests_name.map.
                symbols = report.parent / report.name.replace(".report.txt",
                                                              ".map")
                if not symbols.is_file():
                    raise ValueError("missing KCC linker symbol map")
                mapping = symbols.read_text(errors="replace")
                for symbol in ("sprintf", "strlen", "strcmp"):
                    if not re.search(r"^" + symbol + r"\s+[0-7]+\s*$",
                                     mapping, flags=re.M):
                        raise ValueError("KCC PASS did not link " + symbol)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results", type=Path,
                        help="optional actual six-cell results TSV")
    args = parser.parse_args()
    prefix = os.environ.get("PDP10_PREFIX")
    if not prefix:
        parser.error("PDP10_PREFIX must identify installed target headers")
    rows = read(MANIFEST)
    validate(rows, header_state(Path(prefix)), read(RESOLUTION))
    if args.results:
        verify_results(rows, read(args.results))
    print("PASS: P1 Batch 4 variadic prerequisites (3 SHA-pinned originals, "
          "6 cells, installed header contracts" +
          (", executed evidence" if args.results else "") + ")")


if __name__ == "__main__":
    main()
