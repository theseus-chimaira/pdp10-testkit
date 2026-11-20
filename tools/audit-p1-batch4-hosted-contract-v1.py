#!/usr/bin/env python3
"""Audit two exact P1 Batch 4 hosted-source prerequisites.

The audit preserves historical deferred classifications and current P1
blockers.  It does not execute a compiler sweep or infer that linked
hosted service symbols provide correct runtime semantics.
"""

import argparse
import csv
import hashlib
import os
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "docs/PDP10-P1-BATCH4-HOSTED-CONTRACT-20261120-v1.tsv"
RESOLUTION = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v8.tsv"
BATCHES = ROOT / "docs/PDP10-P1-SOURCE-BATCHES-20261120-v7.tsv"
FIELDS = ("source", "source_sha256", "compiler", "profile",
          "status", "diagnosis")
FIRST = "tests/todo/generic/20020406-1.c"
SECOND = "tests/todo/generic/920810-1.c"
EXPECTED = {
    (FIRST, "kcc"): ("kcc-pdp6-noopt", "timeout", "simh-wall-timeout"),
    (FIRST, "gcc"): ("gcc-pdp6-o0", "timeout", "simh-wall-timeout"),
    (SECOND, "kcc"): ("kcc-pdp6-noopt", "timeout", "simh-wall-timeout"),
    (SECOND, "gcc"): ("gcc-pdp6-o0", "compile_fail",
                      "missing-gcc-stdio-header"),
}
RESOLVED = {
    FIRST: ("malloc", "calloc", "printf"),
    SECOND: ("malloc", "memcpy", "memset"),
}


def read(path):
    with path.open(newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def gcc_stdio_available(prefix):
    """Limit assertions to the target include roots used by this runner."""
    if not (prefix / "lib/kcc/include/stdio.h").is_file():
        raise ValueError("installed KCC target stdio.h disappeared")
    roots = (
        ROOT / "support/gcc",
        ROOT / "support/common",
        ROOT / "support/include",
        prefix / "pdp10-dec-none/include",
        prefix / "lib/gcc-lib/pdp10-dec-none/3.2/include",
    )
    return any((root / "stdio.h").is_file() for root in roots)


def validate(rows, resolution, batches, have_gcc_stdio):
    if len(rows) != 4 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("expected four hosted source/profile records")
    identities = {(r["source"], r["compiler"]): r for r in rows}
    if len(identities) != 4 or set(identities) != set(EXPECTED):
        raise ValueError("missing/duplicate hosted source/compiler")
    if have_gcc_stdio:
        raise ValueError("GCC stdio.h available; refresh installed probes")
    live = {r["original_source"]: r for r in resolution}
    batch = [r for r in batches if r["batch"] == "4"]
    if (len(batch) != 10 or
            [r["slot"] for r in batch] != [str(i) for i in range(1, 11)] or
            [r["live_state"] for r in batch] !=
            ["partial"] + ["blocked"] * 9):
        raise ValueError("P1 Batch 4 membership/progress changed")
    if batch[8]["original_source"] != FIRST or (
            batch[9]["original_source"] != SECOND):
        raise ValueError("hosted original moved from frozen batch slot")
    for row in rows:
        key = row["source"], row["compiler"]
        if ((row["profile"], row["status"], row["diagnosis"])
                != EXPECTED[key]):
            raise ValueError("incorrect installed hosted outcome: " +
                             repr(key))
        path = (ROOT / row["source"]).resolve()
        if not path.is_relative_to(ROOT / "tests") or not path.is_file():
            raise ValueError("missing or external original source")
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        source = row["source"]
        if row["source_sha256"] != digest:
            raise ValueError("original hosted source hash changed")
        live_row = live.get(source)
        if (live_row is None or live_row["p1_state"] != "blocked" or
                live_row["original_sha256"] != digest or
                live_row["historical_disposition"] != "hosted-runtime"):
            raise ValueError("original hosted P1 state/provenance changed")
        frozen = batch[8] if source == FIRST else batch[9]
        if frozen["source_sha256"] != digest:
            raise ValueError("frozen batch source SHA changed")
    first_source = (ROOT / FIRST).read_text(encoding="ascii")
    second_source = (ROOT / SECOND).read_text(encoding="ascii")
    if not all(item in first_source for item in (
            "__SIZE_TYPE__", "malloc(", "calloc(", "printf(",
            "DUPFFexgcd(")):
        raise ValueError("hosted polynomial original contract changed")
    if not all(item in second_source for item in (
            "#include <stdio.h>", "malloc(", "memcpy(", "memset(",
            "bar->super!=&foo", "abort();")):
        raise ValueError("hosted allocation original oracle changed")


def check_results(rows, results):
    observed = {(r["source"], r["compiler"]): r for r in results}
    if len(results) != 4 or len(observed) != 4 or (
            set(observed) != set(EXPECTED)):
        raise ValueError("four exact PDP-6 results required")
    for row in rows:
        key = (row["source"], row["compiler"])
        result = observed[key]
        if (result["cpu"] != "pdp6" or
                result["optimization"] !=
                ("-n" if row["compiler"] == "kcc" else "-O0") or
                result["status"] != row["status"]):
            raise ValueError("unexpected actual PDP-6 source outcome")
        report = Path(result["report"])
        if not report.is_file():
            raise ValueError("actual simulator/compiler record missing")
        evidence = report.read_text(errors="replace")
        if row["status"] == "compile_fail":
            if "stdio.h: No such file or directory" not in evidence:
                raise ValueError("GCC target header failure not observed")
            continue
        if (not re.search(r"^rc=124$", evidence, flags=re.M) or
                not re.search(r"^result=FAIL$", evidence, flags=re.M) or
                "HALT instruction" in evidence or
                "__P10RUN_EXPECT__ __test_exit" in evidence):
            raise ValueError("timeout mistaken for an executed guest result")
        link_map = report.parent / report.name.replace(".report.txt", ".map")
        if not link_map.is_file():
            raise ValueError("missing successful target linker map")
        symbols = link_map.read_text(errors="replace")
        for name in RESOLVED[row["source"]]:
            if not re.search(r"^" + name + r"\s+[0-7]+\s*$",
                             symbols, flags=re.M):
                raise ValueError("unresolved actual symbol: " + name)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--results", type=Path,
                    help="optional exact four-cell probe TSV")
    args = ap.parse_args()
    prefix = os.environ.get("PDP10_PREFIX")
    if not prefix:
        ap.error("PDP10_PREFIX must identify the installed target toolchain")
    rows = read(MANIFEST)
    validate(rows, read(RESOLUTION), read(BATCHES),
             gcc_stdio_available(Path(prefix)))
    if args.results:
        check_results(rows, read(args.results))
    print("PASS: P1 Batch 4 hosted contracts (2 SHA-pinned originals, "
          "4 cells, frozen Batch 4 membership" +
          (", actual linker/simulator evidence" if args.results else "") +
          ")")


if __name__ == "__main__":
    main()
