#!/usr/bin/env python3
"""Explicit dispatcher for non-matrix special tests.

This wrapper deliberately does not change SPECIAL_TESTS.tsv or the normal
compiler runner. Native DAIMOS cases are excluded pending ownership transfer.
"""
import csv
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "SPECIAL_TESTS.tsv"


def entries():
    with REGISTRY.open(encoding="utf-8", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def native(row):
    return row["id"].startswith(("native-toolchain-", "native-kcc-"))


def eligible(row):
    return row["enabled"] == "manual" and not native(row)


def main(argv):
    if not argv or argv[0] not in ("list", "run", "run-all"):
        raise SystemExit("usage: run-special-tests-v1.sh list | run ID | run-all")
    rows = entries()
    selected = [row for row in rows if eligible(row)]
    if argv[0] == "list" and len(argv) == 1:
        for row in rows:
            if row["enabled"] == "manual":
                state = "native-deferred" if native(row) else "selectable"
                print("%s\t%s\t%s" % (row["id"], state, row["path"]))
        return 0
    if argv[0] == "run" and len(argv) == 2:
        selected = [row for row in selected if row["id"] == argv[1]]
        if len(selected) != 1:
            raise SystemExit("unknown, ineligible or native DAIMOS test: " + argv[1])
    elif argv[0] != "run-all" or len(argv) != 1:
        raise SystemExit("usage: run-special-tests-v1.sh list | run ID | run-all")
    failures = 0
    for row in selected:
        result = subprocess.run([str(ROOT / "run-misc-tests.sh"), "run-id",
                                 row["id"], "--manual"], cwd=ROOT,
                                check=False)
        if result.returncode:
            failures += 1
            print("FAIL %s (exit %d)" % (row["id"], result.returncode),
                  flush=True)
    print("special: %d selected, %d failed" % (len(selected), failures))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
