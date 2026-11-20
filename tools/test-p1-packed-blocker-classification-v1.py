#!/usr/bin/env python3
"""Fail closed on the P1 packed aggregate compiler-blocker reclassification.

Historical classifications and source identities are immutable.  Current
toolchain failures and staged compiler success are different observations;
neither may turn a blocked original into a P1 pass.
"""

import collections
import csv
import hashlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = "tests/semantic/upstream/extensions/20010518-2.c"
OLD = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v7.tsv"
NEW = ROOT / "docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v8.tsv"
OLD_BATCH = ROOT / "docs/PDP10-P1-SOURCE-BATCHES-20261119-v6.tsv"
NEW_BATCH = ROOT / "docs/PDP10-P1-SOURCE-BATCHES-20261120-v7.tsv"


def read(path):
    with path.open(newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def validate(old, new, old_batch, new_batch):
    if len(old) != 67 or len(new) != 67:
        raise ValueError("P1 resolution no longer has 67 originals")
    source_old = {r["original_source"]: r for r in old}
    source_new = {r["original_source"]: r for r in new}
    if len(source_old) != 67 or set(source_old) != set(source_new):
        raise ValueError("source identity or uniqueness changed")
    if len(old_batch) != 59 or len(new_batch) != 59:
        raise ValueError("frozen 59-source batch inventory changed")
    for name in source_old:
        a = source_old[name]
        b = source_new[name]
        if name == SOURCE:
            if any(a[k] != b[k] for k in a
                   if k not in ("compiler_followup",
                                "p1_remaining_action")):
                raise ValueError("packed original immutable fields changed")
        elif a != b:
            raise ValueError("unrelated P1 resolution changed: " + name)

    a = source_old[SOURCE]
    b = source_new[SOURCE]
    if (a["historical_disposition"] != "libc-linkage" or
            b["historical_disposition"] != "libc-linkage" or
            a["p1_state"] != "blocked" or b["p1_state"] != "blocked" or
            b["compiler_followup"] != "packed-aggregate-compiler" or
            b["gcc_pdp6_baseline"] != "run_fail" or
            b["kcc_pdp6_baseline"] != "run_fail" or
            "NOT installed" not in b["p1_remaining_action"] or
            "Keep original blocked" not in b["p1_remaining_action"]):
        raise ValueError("incorrect packed compiler blocker classification")
    if hashlib.sha256((ROOT / SOURCE).read_bytes()).hexdigest() != (
            b["original_sha256"]):
        raise ValueError("original packed source changed")

    for before, after in zip(old_batch, new_batch):
        if before["original_source"] != after["original_source"]:
            raise ValueError("P1 batch assignment changed")
        if before["original_source"] == SOURCE:
            if any(before[k] != after[k] for k in before
                   if k != "remaining_action"):
                raise ValueError("packed batch identity/state changed")
            if after["remaining_action"] != b["p1_remaining_action"]:
                raise ValueError("batch lacks latest packed blocker action")
            if after["batch"] != "4" or after["slot"] != "2":
                raise ValueError("packed original moved from frozen batch")
        elif before != after:
            raise ValueError("unrelated batch record changed")

    states = collections.Counter(row["p1_state"] for row in new)
    if states != {"covered": 38, "partial": 1, "blocked": 28}:
        raise ValueError("unexpected P1 closure change")


def rejected(old, new, old_batch, new_batch):
    try:
        validate(old, new, old_batch, new_batch)
    except ValueError:
        return
    raise AssertionError("invalid reclassification accepted")


def main():
    old = read(OLD)
    new = read(NEW)
    old_batch = read(OLD_BATCH)
    new_batch = read(NEW_BATCH)
    validate(old, new, old_batch, new_batch)

    changed = [dict(row) for row in new]
    target = next(row for row in changed if row["original_source"] == SOURCE)
    target["p1_state"] = "covered"
    rejected(old, changed, old_batch, new_batch)
    changed = [dict(row) for row in new]
    target = next(row for row in changed if row["original_source"] == SOURCE)
    target["compiler_followup"] = "none"
    rejected(old, changed, old_batch, new_batch)
    changed = [dict(row) for row in new]
    target = next(row for row in changed if row["original_source"] == SOURCE)
    target["historical_disposition"] = "compiler-investigate"
    rejected(old, changed, old_batch, new_batch)
    changed_batch = [dict(row) for row in new_batch]
    target = next(row for row in changed_batch
                  if row["original_source"] == SOURCE)
    target["batch"] = "5"
    rejected(old, new, old_batch, changed_batch)

    print("PASS: packed original stays blocked (67 sources, 59 frozen "
          "assignments, 4 negative controls)")


if __name__ == "__main__":
    main()
