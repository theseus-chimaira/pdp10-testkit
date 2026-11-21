#!/usr/bin/env python3
"""Host-only positive and negative checks of later P1 matrix admissions."""

import csv
from pathlib import Path

from p1_matrix_admissions_v1 import admitted_sources


ROOT = Path(__file__).resolve().parents[1]


def read_tsv(name, comments=False):
    with (ROOT / name).open(encoding="utf8", newline="") as stream:
        return list(csv.DictReader(
            (line for line in stream
             if not comments or not line.startswith("#")), delimiter="\t"))


def check():
    upstream = read_tsv(
        "manifests/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv")
    matrix = read_tsv("COMPILER_MATRIX.tsv", comments=True)
    problems = []
    admitted = admitted_sources(upstream, matrix, problems)
    if problems or len(admitted) != 28:
        raise AssertionError("original 28-source admission is not valid: " +
                             repr(problems))

    victim = "tests/todo/generic/gofast.c"
    for failure_kind in ("disabled-cell", "wrong-owner", "missing-source"):
        # Copy just the row being modified; thousands of unaffected matrix
        # entries can be shared safely by this read-only audit.
        changed = [dict(row) if row["test"] == victim else row
                   for row in matrix]
        if failure_kind == "missing-source":
            changed = [r for r in changed if r["test"] != victim]
        else:
            row = next(r for r in changed if r["test"] == victim)
            if failure_kind == "disabled-cell":
                row["pdp6_gcc_o0"] = "no_test"
            else:
                row["group"] = "codegen"
        found = []
        admitted_sources(upstream, changed, found)
        if not found:
            raise AssertionError("admission validator missed " + failure_kind)

    changed_upstream = [
        dict(row) if row["classified_path"] == victim else row
        for row in upstream]
    next(r for r in changed_upstream
         if r["classified_path"] == victim)["activation"] = "removed"
    found = []
    admitted_sources(changed_upstream, matrix, found)
    if not found:
        raise AssertionError("admission validator missed altered provenance")

    print("P1 admission guard: PASS (28 admitted C sources, 4 negative controls)")


if __name__ == "__main__":
    check()
