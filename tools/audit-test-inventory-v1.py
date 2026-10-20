#!/usr/bin/env python3
"""Validate testkit test ownership and upstream semantic classifications.

This is a static inventory check, not execution evidence.  Source existence,
one-owner registration, and upstream classification/matrix consistency are
checked without modifying any test or running a compiler.
"""

import argparse
import collections
import csv
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
MATRIX = ROOT / "COMPILER_MATRIX.tsv"
SPECIAL = ROOT / "SPECIAL_TESTS.tsv"
CLASSIFIED = (ROOT / "docs" /
              "SEMANTIC-UPSTREAM-CLASSIFICATION-20261014-v2.tsv")
REQUIRED_ACTIVATIONS = frozenset(("active", "deferred", "removed",
                                  "stress-nonportable"))

# These are companion translation units or standalone assembler fixtures
# executed by an owning registered script/source; they must not be scheduled
# as independent main programs.  Keep this map strict so new orphans fail.
SUPPORT_SOURCE_OWNERS = {
    "tests/semantic/kcc-dimode-float-pdp6-v1.c":
        "misc/validation/test-kcc-dimode-float-pdp6-v1.sh",
    "tests/semantic/kcc-dimode-local-load-v1.c":
        "misc/validation/test-kcc-dimode-storage-v1.sh",
    "tests/semantic/kcc-dformat-negative-v1.c":
        "misc/validation/test-kcc-dimode-storage-v1.sh",
    "tests/semantic/freestanding-search-benchmark-v1.c":
        "tools/benchmark-freestanding-search-v1.py",
    "tests/semantic/validation-gcc/gcc-addressof-pdp6-ice-v1.c":
        "misc/validation/test-gcc-addressof-pdp6-ice-v1.sh",
    "tests/semantic/freestanding-search-v1.c":
        "misc/compat/test-freestanding-search-v1.sh",
    "tests/semantic/freestanding-search-reference-v1.c":
        "misc/compat/test-freestanding-search-v1.sh",
    "tests/semantic/validation-gcc/pdp10-9bit-data-section-v1.c":
        "misc/validation/test-gcc-9bit-data-section-v1.sh",
    "tests/semantic/p10-byte-pointer-widths-v2.s":
        "misc/compat/test-p10byte-widths-v2.sh",
    "tests/semantic/p10-byte-blt-v3.s":
        "misc/compat/test-p10byte-blt-v3.sh",
    "tests/semantic/p10-byte-blt-fill-v3.s":
        "misc/compat/test-p10byte-blt-v3.sh",
    "tests/semantic/utf9-codec-pdp6-v1.c":
        "misc/compat/test-utf9-pdp6-runtime-v1.sh",
    "tests/semantic/utf9-codec-pdp6-v2.c":
        "misc/compat/test-utf9-pdp6-runtime-v1.sh",
    "tests/semantic/validation-gcc/bare-runtime/badl-tables.c":
        "misc/validation/test-badl-tables.sh",
    "tests/semantic/validation-gcc/byteptr2/no-xkl2-byte-extend.c":
        "misc/validation/test-no-xkl2-byte-extend.sh",
    "tests/semantic/imported/gcc/pdp10-gcc-multidim-char-20261012.c":
        "tests/semantic/imported/gcc/pdp10-gcc-multidim-char-20261012.sh",
}
for _test in ("daimos-kcc-indexed-call-pdp6",
              "daimos-kcc-local-word-array-pdp6",
              "daimos-kcc-loop-return-pdp6",
              "daimos-kcc-pointer-scan-pdp6-20261009",
              "daimos-kcc-sixarg-char-pdp6"):
    _folder = "tests/semantic/imported/target/" + _test + "/"
    SUPPORT_SOURCE_OWNERS[_folder + "test.c"] = _folder + "matrix-semantic.c"


def rows(path, comments=False):
    with path.open(encoding="utf-8", newline="") as stream:
        lines = (line for line in stream
                 if line.strip() and (not comments or
                                      not line.startswith("#")))
        yield from csv.DictReader(lines, delimiter="\t")


def duplicates(values):
    return sorted(key for key, count in collections.Counter(values).items()
                  if count > 1)


def audit():
    problems = []
    matrix = list(rows(MATRIX, comments=True))
    special = list(rows(SPECIAL))
    upstream = list(rows(CLASSIFIED))
    matrix_paths = set(row["test"] for row in matrix)
    special_paths = set(row["path"] for row in special)

    for label, keys in (("matrix source", [r["test"] for r in matrix]),
                        ("special ID", [r["id"] for r in special]),
                        ("special script", [r["path"] for r in special]),
                        ("upstream original", [r["previous_path"]
                                               for r in upstream]),
                        ("upstream destination", [r["classified_path"]
                                                  for r in upstream])):
        for key in duplicates(keys):
            problems.append("duplicate %s: %s" % (label, key))

    for label, paths in (("matrix", matrix_paths),
                         ("special", special_paths)):
        for rel in sorted(paths):
            # Refuse paths leaving the testkit, including traversal.
            full = (ROOT / rel).resolve()
            if not full.is_relative_to(ROOT) or not full.is_file():
                problems.append("invalid %s source: %s" % (label, rel))

    for rel in sorted(matrix_paths & special_paths):
        problems.append("matrix/special double ownership: %s" % rel)

    counts = collections.Counter()
    for row in upstream:
        activation = row["activation"]
        rel = row["classified_path"]
        full = (ROOT / rel).resolve()
        counts[activation] += 1
        if activation not in REQUIRED_ACTIVATIONS:
            problems.append("unknown activation: %s: %s" % (rel, activation))
        exists = full.is_relative_to(ROOT) and full.is_file()
        registered = rel in matrix_paths
        if activation == "removed":
            if exists or registered:
                problems.append("removed source still present/registered: %s" % rel)
        else:
            if not exists:
                problems.append("missing retained upstream source: %s" % rel)
            if registered != (activation == "active"):
                problems.append("upstream registration mismatch: %s (%s)" %
                                (rel, activation))
        if rel in special_paths:
            problems.append("upstream source registered as special: %s" % rel)

    source_files = set(str(path.relative_to(ROOT)) for path in
                       (ROOT / "tests").rglob("*")
                       if path.is_file() and path.suffix in (".c", ".s", ".S"))
    known_deferred = set(r["classified_path"] for r in upstream
                         if r["activation"] in ("deferred", "stress-nonportable"))
    unowned = (source_files - matrix_paths - special_paths - known_deferred -
               set(SUPPORT_SOURCE_OWNERS))
    for source, owner in sorted(SUPPORT_SOURCE_OWNERS.items()):
        if source not in source_files:
            problems.append("missing declared companion: " + source)
        if owner not in matrix_paths and owner not in special_paths:
            problems.append("unregistered companion owner: %s (%s)" %
                            (source, owner))
    for source in sorted(unowned):
        problems.append("unowned test source: " + source)
    print("matrix_sources=%d special_entries=%d special_unique_ids=%d" %
          (len(matrix), len(special), len(set(r["id"] for r in special))))
    print("upstream_classified=%d %s" %
          (len(upstream), " ".join("%s=%d" % (key, counts[key])
                                   for key in sorted(counts))))
    print("owned_companion_sources=%d unowned_test_sources=%d" %
          (len(SUPPORT_SOURCE_OWNERS), len(unowned)))

    for problem in problems:
        print("ERROR: " + problem, file=sys.stderr)
    print("inventory: %s (%d error(s))" %
          ("FAIL" if problems else "PASS", len(problems)))
    return int(bool(problems))


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description=__doc__)
    ap.parse_args()
    sys.exit(audit())
