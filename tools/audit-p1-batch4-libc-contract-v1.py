#!/usr/bin/env python3
"""Verify two exact P1 Batch 4 libc contracts without running the matrix.

The observed failure stages are historical snapshots, not success claims.
An optional bounded probe-result comparison checks real linker diagnostics
and the simulator's completed failing guest exit.
"""

import argparse
import csv
import hashlib
import os
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "manifests/PDP10-P1-BATCH4-LIBC-CONTRACT-20261120-v1.tsv"
EXPECTED = {
    ("tests/todo/generic/991112-1.c", "kcc"):
        ("kcc-pdp6-noopt", "link_fail", "isprint"),
    ("tests/todo/generic/991112-1.c", "gcc"):
        ("gcc-pdp6-o0", "link_fail", "isprint"),
    ("tests/semantic/upstream/pdp10/pdp10/conversion.c", "kcc"):
        ("kcc-pdp6-noopt", "run_fail", "-"),
    ("tests/semantic/upstream/pdp10/pdp10/conversion.c", "gcc"):
        ("gcc-pdp6-o0", "link_fail", "__fixunssfsi"),
}
FIELDS = ("source", "source_sha256", "compiler", "profile",
          "status", "missing_symbol")
EXPORT = re.compile(r"(?mi)^\s*\.glob(?:l|al)\s+([A-Za-z_][\w]*)\b")


def read(path):
    with path.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def installed_exports(prefix):
    """Only members actually selected by the semantic freestanding runner.

    This is not a statement about every possible hosted/third-party
    library or an unlinked target libgcc archive.
    """
    dirs = (
        prefix / "lib/kcc/freestanding",
        prefix / "lib/gcc-lib/pdp10-dec-none/3.2/freestanding",
        prefix / "lib/kcc",
    )
    exports = set()
    for directory in dirs:
        if not directory.is_dir():
            raise ValueError("missing installed runtime directory: " +
                             str(directory))
        sources = list(directory.glob("*.s"))
        if not sources:
            raise ValueError("empty installed runtime directory: " +
                             str(directory))
        for source in sources:
            exports.update(EXPORT.findall(source.read_text(
                encoding="ascii")))
    return exports


def validate(rows, exports):
    if len(rows) != 4 or not rows or tuple(rows[0]) != FIELDS:
        raise ValueError("four exact contract rows required")
    unique = {(row["source"], row["compiler"]) for row in rows}
    if unique != set(EXPECTED) or len(unique) != len(rows):
        raise ValueError("missing or duplicated source/compiler identity")
    for row in rows:
        path = row["source"]
        expected = EXPECTED[(path, row["compiler"])]
        if (row["profile"], row["status"], row["missing_symbol"]) != expected:
            raise ValueError("stale prerequisite classification: " + path)
        source = (ROOT / path).resolve()
        if not source.is_relative_to(ROOT / "tests") or not source.is_file():
            raise ValueError("missing or external original source: " + path)
        if hashlib.sha256(source.read_bytes()).hexdigest() != (
                row["source_sha256"]):
            raise ValueError("original source hash mismatch: " + path)
        missing = row["missing_symbol"]
        if missing != "-" and missing in exports:
            raise ValueError("previously absent symbol is now installed: " +
                             missing)
    if "isprint (" not in (ROOT / "tests/todo/generic/991112-1.c").read_text():
        raise ValueError("original isprint invocation changed")
    conversion = (ROOT / "tests/semantic/upstream/pdp10/pdp10/"
                  "conversion.c").read_text()
    if "f2u(float f)" not in conversion or "return (unsigned) f;" not in conversion:
        raise ValueError("original unsigned float conversion changed")


def check_results(rows, results_path):
    """Validate four actually executed cells, not merely their exit tags."""
    results = read(results_path)
    observed = {(r["source"], r["compiler"]): r for r in results}
    if len(results) != 4 or set(observed) != set(EXPECTED):
        raise ValueError("result probe lacks four exact PDP-6 cells")
    for row in rows:
        found = observed[(row["source"], row["compiler"])]
        if (found["cpu"] != "pdp6" or
                found["optimization"] !=
                ("-n" if row["compiler"] == "kcc" else "-O0") or
                found["status"] != row["status"]):
            raise ValueError("probe result disagrees with installed contract")
        report = Path(found["report"])
        if not report.is_file():
            raise ValueError("missing actual probe evidence: " + str(report))
        evidence = report.read_text(errors="replace")
        if row["status"] == "link_fail":
            if ("dlink: undefined symbol: " + row["missing_symbol"]
                    not in evidence or
                    "p10run: link failed" not in evidence):
                raise ValueError("no exact missing-symbol linker evidence")
        elif (row["status"] == "run_fail" and
              ("HALT instruction" not in evidence or
               "Step expired" in evidence or
               not re.search(r"__P10RUN_EXPECT__ __test_exit [^\n]+\n"
                             r"[^\n]+\t000000000001\b", evidence))):
            raise ValueError("no completed nonzero guest assertion")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--results", type=Path,
                        help="optional exact probe results-v1.tsv")
    args = parser.parse_args()
    prefix = os.environ.get("PDP10_PREFIX")
    if not prefix:
        parser.error("PDP10_PREFIX is needed for installed-source audit")
    records = read(MANIFEST)
    validate(records, installed_exports(Path(prefix)))
    if args.results:
        check_results(records, args.results)
    print("PASS: two source-pinned Batch 4 contracts, four PDP-6 cells, "
          "selected runtime exports" +
          (", execution evidence" if args.results else ""))


if __name__ == "__main__":
    main()
