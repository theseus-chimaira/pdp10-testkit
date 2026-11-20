#!/usr/bin/env python3
"""Reconcile frozen P1 Batch 4 using source-pinned targeted probe evidence.

The 2026-11-19 original 18 C cell reports remain intact. Newer exact
libc/variadic/hosted contract snapshots replace only their own source
cells. A KL10 assembly fixture remains an ISA obligation, not a C test.
This auditor never runs any compiler or modifies original test sources.
"""

import argparse
import collections
import csv
import hashlib
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
BATCH = ROOT / "docs/PDP10-P1-SOURCE-BATCHES-20261120-v7.tsv"
ORIGINAL = ROOT / "docs/PDP10-P1-BATCH4-PROBE-20261119-v1.tsv"
CURRENT = ROOT / "docs/PDP10-P1-BATCH4-RECONCILED-20261120-v1.tsv"
REVISED = (
    ROOT / "docs/PDP10-P1-BATCH4-LIBC-CONTRACT-20261120-v1.tsv",
    ROOT / "docs/PDP10-P1-BATCH4-VARIADIC-CONTRACT-20261120-v1.tsv",
    ROOT / "docs/PDP10-P1-BATCH4-HOSTED-CONTRACT-20261120-v1.tsv",
)
FIELDS = ("slot", "original_source", "source_sha256",
          "compiler", "status", "evidence")
UNREVISED = {
    ("tests/semantic/upstream/extensions/builtin-prefetch-6.c", "kcc"):
        "link_fail",
    ("tests/semantic/upstream/extensions/builtin-prefetch-6.c", "gcc"):
        "pass",
    ("tests/semantic/upstream/extensions/20010518-2.c", "kcc"):
        "run_fail",
    ("tests/semantic/upstream/extensions/20010518-2.c", "gcc"):
        "run_fail",
    ("tests/semantic/upstream/support/920428-1.s", "none"):
        "isa-harness-required",
}
EXPECTED_COUNTS = {
    "pass": 2, "run_fail": 4, "link_fail": 4,
    "compile_fail": 4, "timeout": 4, "isa-harness-required": 1,
}


def read(path):
    with path.open(newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def reconcile(plan, original, manifests):
    slots = [r for r in plan if r["batch"] == "4"]
    if (len(slots) != 10 or
            [r["slot"] for r in slots] !=
            [str(i) for i in range(1, 11)] or
            [r["live_state"] for r in slots] !=
            ["partial"] + ["blocked"] * 9):
        raise ValueError("frozen Batch 4 slots/states differ")
    source_map = {r["original_source"]: r for r in slots}
    if len(source_map) != 10:
        raise ValueError("duplicate original Batch 4 source")
    for path, row in source_map.items():
        source = ROOT / path
        if (not source.is_file() or
                hashlib.sha256(source.read_bytes()).hexdigest() !=
                row["source_sha256"]):
            raise ValueError("original Batch 4 SHA mismatch: " + path)

    old = {}
    for entry in original:
        key = (entry["source"], entry["compiler"])
        source = source_map.get(entry["source"])
        if (source is None or
                entry["original_sha256"] != source["source_sha256"] or
                key in old):
            raise ValueError("stale or duplicate 2026-11-19 evidence")
        old[key] = entry["observed"]
    if len(old) != 19 or (
            set(old) != {(source, "none" if source.endswith(".s")
                          else compiler)
                         for source in source_map
                         for compiler in (("none",) if source.endswith(".s")
                                          else ("kcc", "gcc"))}):
        raise ValueError("old Batch 4 source/profile inventory incomplete")
    for key, status in UNREVISED.items():
        if old[key] != status:
            raise ValueError("unrevised original observation changed")

    updates = {}
    for manifest in manifests:
        for row in read(manifest):
            key = row["source"], row["compiler"]
            pinned = source_map.get(row["source"])
            if (pinned is None or
                    row["source_sha256"] != pinned["source_sha256"] or
                    row["profile"] != ("kcc-pdp6-noopt"
                                       if row["compiler"] == "kcc"
                                       else "gcc-pdp6-o0") or
                    key in updates or key not in old or key in UNREVISED):
                raise ValueError("unverified targeted Batch 4 override")
            updates[key] = (row["status"], manifest.name)
    if len(updates) != 14 or set(updates) != set(old) - set(UNREVISED):
        raise ValueError("missing or extra targeted Batch 4 overrides")

    rows = []
    for slot in slots:
        source = slot["original_source"]
        for compiler in (("none",) if source.endswith(".s")
                         else ("kcc", "gcc")):
            key = source, compiler
            if key in updates:
                status, evidence = updates[key]
            else:
                status, evidence = old[key], ORIGINAL.name
            rows.append({
                "slot": slot["slot"],
                "original_source": source,
                "source_sha256": slot["source_sha256"],
                "compiler": compiler,
                "status": status,
                "evidence": evidence,
            })
    if collections.Counter(r["status"] for r in rows) != EXPECTED_COUNTS:
        raise ValueError("unexpected P1 Batch 4 failure-class distribution")
    return rows


def validate(stored, expected):
    if not stored or len(stored) != 19 or tuple(stored[0]) != FIELDS:
        raise ValueError("reconciled Batch 4 ledger malformed")
    if stored != expected:
        raise ValueError("reconciled Batch 4 evidence differs from sources")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--write", action="store_true")
    args = ap.parse_args()
    expected = reconcile(read(BATCH), read(ORIGINAL), REVISED)
    if args.write:
        with CURRENT.open("w", newline="", encoding="utf-8") as stream:
            writer = csv.DictWriter(stream, fieldnames=FIELDS,
                                    delimiter="\t", lineterminator="\n")
            writer.writeheader()
            writer.writerows(expected)
    else:
        try:
            validate(read(CURRENT), expected)
        except ValueError as exc:
            print("ERROR: " + str(exc), file=sys.stderr)
            return 1
    print("PASS: frozen Batch 4 (10 sources, 18 PDP-6 cells, "
          "1 KL10 ISA obligation; 2 pass/4 run_fail/4 link_fail/"
          "4 compile_fail/4 timeout)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
