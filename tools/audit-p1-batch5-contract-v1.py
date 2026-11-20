#!/usr/bin/env python3
"""Verify installed PDP-6 evidence for ten frozen Batch 5 originals.

Only targeted KCC-noopt and GCC-O0 results are accepted. No original
test or compiler is modified; statuses are not P1 closure decisions.
"""

import argparse
import collections
import csv
import hashlib
import os
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "docs/PDP10-P1-BATCH5-CONTRACT-20261120-v1.tsv"
FROZEN = ROOT / "docs/PDP10-P1-SOURCE-BATCHES-20261120-v7.tsv"
LIVE = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v8.tsv"
FIELDS = ("slot", "original_source", "source_sha256", "compiler",
          "profile", "status", "reason")
NAMES = ("930513-1.c", "941014-2.c", "960327-1.c", "960521-1.c",
         "980605-1.c", "980707-1.c", "980709-1.c", "990628-1.c",
         "990826-0.c", "builtin-noret-1.c")
STAGES = (
    ("pass", "compile_fail"),
    ("timeout", "compile_fail"),
    ("pass", "compile_fail"),
    ("timeout", "timeout"),
    ("pass", "compile_fail"),
    ("link_fail", "compile_fail"),
    ("compile_fail", "compile_fail"),
    ("timeout", "timeout"),
    ("compile_fail", "compile_fail"),
    ("compile_fail", "link_fail"),
)
REASONS = (
    ("guest-oracle-pass", "gcc-target-stdio-missing"),
    ("simh-wall-timeout", "gcc-target-stdio-missing"),
    ("guest-oracle-pass", "gcc-target-stdio-missing"),
    ("simh-wall-timeout", "simh-wall-timeout"),
    ("guest-oracle-pass", "gcc-target-stdio-missing"),
    ("dlink-duplicate-exit", "gcc-target-stdio-ctype-missing"),
    ("kcc-target-math-missing", "gcc-target-math-missing"),
    ("simh-wall-timeout", "simh-wall-timeout"),
    ("kcc-target-math-missing", "gcc-target-stdio-math-missing"),
    ("kcc-exit-conflicting-declaration", "gcc-eexit-unresolved"),
)
COUNT = {"pass": 3, "compile_fail": 10, "timeout": 5,
         "link_fail": 2}


def read(path):
    with path.open(newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def validate(rows, frozen, live):
    selected = [row for row in frozen if row["batch"] == "5"]
    if (len(selected) != 10 or
            [r["slot"] for r in selected] != [str(i) for i in range(1, 11)] or
            any(r["live_state"] != "blocked" for r in selected)):
        raise ValueError("frozen Batch 5 assignments or blocked state changed")
    if len(rows) != 20 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("expected 20 source/compiler Batch 5 entries")
    identities = set()
    current = {r["original_source"]: r for r in live}
    for i, name in enumerate(NAMES):
        source = "tests/todo/generic/" + name
        if selected[i]["original_source"] != source:
            raise ValueError("Batch 5 original changed at slot %d" % (i + 1))
        digest = hashlib.sha256((ROOT / source).read_bytes()).hexdigest()
        if (selected[i]["source_sha256"] != digest or
                current[source]["original_sha256"] != digest or
                current[source]["historical_disposition"] != "hosted-runtime" or
                current[source]["p1_state"] != "blocked"):
            raise ValueError("changed original or P1 closure: " + name)
        for j, compiler in enumerate(("kcc", "gcc")):
            row = rows[2 * i + j]
            expected = (str(i + 1), source, digest, compiler,
                        "kcc-pdp6-noopt" if compiler == "kcc"
                        else "gcc-pdp6-o0", STAGES[i][j], REASONS[i][j])
            if tuple(row[key] for key in FIELDS) != expected:
                raise ValueError("wrong source/profile/stage: " + repr(expected))
            identities.add((row["original_source"], row["compiler"]))
    if len(identities) != 20 or collections.Counter(
            r["status"] for r in rows) != COUNT:
        raise ValueError("duplicate Batch 5 row or changed outcome census")


def verify_evidence(rows, reports, prefix):
    observed = {}
    for file in reports:
        for row in read(file):
            key = (row["source"], row["compiler"])
            if key in observed:
                raise ValueError("duplicated actual probe result: " + repr(key))
            observed[key] = row
    if len(observed) != 20:
        raise ValueError("exactly twenty observed probe results required")

    for row in rows:
        key = row["original_source"], row["compiler"]
        if key not in observed:
            raise ValueError("missing actual probe result: " + repr(key))
        actual = observed[key]
        if (actual["cpu"] != "pdp6" or
                actual["optimization"] != ("-n" if row["compiler"] == "kcc"
                                           else "-O0") or
                actual["status"] != row["status"]):
            raise ValueError("wrong actual machine, opt or result: " + repr(key))
        path = Path(actual["report"])
        if not path.is_file():
            raise ValueError("missing current linker/simulator evidence")
        data = path.read_text(errors="replace")
        reason = row["reason"]
        if row["status"] == "pass":
            required = ("rc=0", "result=PASS", "HALT instruction",
                        "__P10RUN_EXPECT__ __test_exit")
            if (not all(text in data for text in required) or
                    not re.search(r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                                  r"[^\n]+\t000000000000\b", data)):
                raise ValueError("PASS lacks completed original guest exit")
            if (row["compiler"] == "kcc" and
                    row["slot"] in ("1", "3", "5")):
                link_map = path.parent / path.name.replace(".report.txt", ".map")
                if not link_map.is_file() or not re.search(
                        r"^sprintf\s+[0-7]+\s*$",
                        link_map.read_text(errors="replace"), re.M):
                    raise ValueError("KCC formatting PASS lacks sprintf linkage")
        elif row["status"] == "timeout":
            if (not re.search(r"^rc=124$", data, re.M) or
                    not re.search(r"^result=FAIL$", data, re.M) or
                    "HALT instruction" in data or
                    "__P10RUN_EXPECT__ __test_exit" in data):
                raise ValueError("incomplete SIMH execution became guest assertion")
        elif reason == "dlink-duplicate-exit":
            if ("dlink: duplicate global: exit" not in data or
                    "p10run: link failed" not in data):
                raise ValueError("KCC dlink collision evidence changed")
            objs = list((path.parent / "run").glob("*.dobj"))
            if not objs:
                raise ValueError("dlink collision object evidence absent")
            symbol_count = 0
            for obj in objs:
                output = subprocess.check_output(
                    [str(prefix / "bin/pdp10-objdump"), "-t", str(obj)],
                    text=True)
                symbol_count += len(re.findall(
                    r"^\s*\d+ DEF\s+.*\s+exit\s*$", output, re.M))
            if symbol_count != 1:
                raise ValueError("dlink collision not isolated to one DEF exit")
        elif reason == "gcc-eexit-unresolved":
            if ("dlink: undefined symbol: _eexit" not in data or
                    "p10run: link failed" not in data):
                raise ValueError("builtin-noret GCC link failure changed")
        elif reason == "kcc-exit-conflicting-declaration":
            if ("Symbol \"_exit\" previously declared" not in data or
                    not re.search(r"\? KCC - 1 error detected", data)):
                raise ValueError("KCC builtin-noret rejection changed")
        elif reason.endswith("-missing"):
            headers = []
            if "stdio" in reason:
                headers.append("stdio.h")
            if "ctype" in reason:
                headers.append("ctype.h")
            if "math" in reason:
                headers.append("math.h")
            for header in headers:
                if header not in data or ("No such file or directory" not in data
                                              and "Can't open include file" not in data):
                    raise ValueError("missing target header evidence: " + header)
        else:
            raise ValueError("unhandled Batch 5 evidence category: " + reason)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--results", action="append", type=Path, default=[],
                    help="two exact results-v1.tsv probe paths, if supplied")
    args = ap.parse_args()
    rows = read(MANIFEST)
    validate(rows, read(FROZEN), read(LIVE))
    if args.results:
        if len(args.results) != 2:
            ap.error("two disjoint five-source probe results are required")
        prefix = os.environ.get("PDP10_PREFIX")
        if not prefix:
            ap.error("PDP10_PREFIX is required for actual objdump evidence")
        verify_evidence(rows, args.results, Path(prefix))
    print("PASS: Batch 5 source-pinned prerequisites (10 originals, "
          "20 PDP-6 cells: 3 pass, 10 compile_fail, 5 timeout, 2 link_fail" +
          (", verified real logs/maps/objects" if args.results else "") + ")")


if __name__ == "__main__":
    main()
