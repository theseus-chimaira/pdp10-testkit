#!/usr/bin/env python3
"""Synthetic negative checks for current P1 Batch 4 evidence merging."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p1_batch4_reconcile_v1",
    ROOT / "tools/audit-p1-batch4-reconciled-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def rejected(rows, expected):
    try:
        audit.validate(rows, expected)
    except ValueError:
        return
    raise AssertionError("incorrect merged evidence accepted")


def main():
    expected = audit.reconcile(
        audit.read(audit.BATCH), audit.read(audit.ORIGINAL), audit.REVISED)
    audit.validate(audit.read(audit.CURRENT), expected)

    changed = [dict(row) for row in expected]
    target = next(r for r in changed
                  if r["original_source"].endswith("920501-8.c")
                  and r["compiler"] == "kcc")
    target["status"] = "run_fail"
    rejected(changed, expected)
    changed = [dict(row) for row in expected]
    target = next(r for r in changed if r["compiler"] == "none")
    target["status"] = "pass"
    rejected(changed, expected)
    changed = [dict(row) for row in expected]
    changed[0]["source_sha256"] = "0" * 64
    rejected(changed, expected)
    changed = [dict(row) for row in expected]
    changed[1]["compiler"] = "kcc"
    rejected(changed, expected)
    changed = [dict(row) for row in expected]
    changed[0]["evidence"] = "invented"
    rejected(changed, expected)
    rejected(expected[:-1], expected)
    print("PASS: reconciled Batch 4 evidence (6 negative controls)")


if __name__ == "__main__":
    main()
