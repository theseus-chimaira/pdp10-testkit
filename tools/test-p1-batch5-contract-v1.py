#!/usr/bin/env python3
"""Host-only negative controls for Batch 5 prerequisite provenance."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p1_batch5_contract_v1", ROOT / "tools/audit-p1-batch5-contract-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def reject(rows, frozen, live):
    try:
        audit.validate(rows, frozen, live)
    except (ValueError, KeyError):
        return
    raise AssertionError("invalid Batch 5 evidence accepted")


def mutate(rows, index, column, value):
    changed = [dict(row) for row in rows]
    changed[index][column] = value
    return changed


def main():
    rows = audit.read(audit.MANIFEST)
    frozen = audit.read(audit.FROZEN)
    live = audit.read(audit.LIVE)
    audit.validate(rows, frozen, live)
    reject(mutate(rows, 0, "status", "run_fail"), frozen, live)
    reject(mutate(rows, 3, "status", "run_fail"), frozen, live)
    reject(mutate(rows, 0, "source_sha256", "0" * 64), frozen, live)
    reject(mutate(rows, 2, "compiler", "gcc"), frozen, live)
    reject(mutate(rows, 4, "profile", "gcc-pdp6-o0"), frozen, live)
    reject(mutate(rows, 10, "reason", "missing-isspace"), frozen, live)
    reject(rows[:-1], frozen, live)
    changed = [dict(row) for row in frozen]
    batch5 = next(r for r in changed if r["batch"] == "5")
    batch5["slot"] = "9"
    reject(rows, changed, live)
    changed = [dict(row) for row in live]
    target = next(r for r in changed if r["original_source"].endswith(
        "/980605-1.c"))
    target["p1_state"] = "covered"
    reject(rows, frozen, changed)
    print("PASS: Batch 5 contract (9 source/stage/closure negative controls)")


if __name__ == "__main__":
    main()
