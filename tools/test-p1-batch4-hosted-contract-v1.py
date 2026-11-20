#!/usr/bin/env python3
"""Negative controls for SHA-pinned P1 Batch 4 hosted-runtime contracts."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p1_batch4_hosted_contract_v1",
    ROOT / "tools/audit-p1-batch4-hosted-contract-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def rejected(rows, live, batches, header):
    try:
        audit.validate(rows, live, batches, header)
    except ValueError:
        return
    raise AssertionError("invalid hosted prerequisite contract accepted")


def main():
    rows = audit.read(audit.MANIFEST)
    live = audit.read(audit.RESOLUTION)
    batches = audit.read(audit.BATCHES)
    audit.validate(rows, live, batches, False)

    changed = [dict(row) for row in rows]
    changed[0]["status"] = "run_fail"
    rejected(changed, live, batches, False)
    changed = [dict(row) for row in rows]
    changed[2]["status"] = "pass"
    rejected(changed, live, batches, False)
    changed = [dict(row) for row in rows]
    changed[3]["diagnosis"] = "missing-malloc"
    rejected(changed, live, batches, False)
    changed = [dict(row) for row in rows]
    changed[1]["source_sha256"] = "0" * 64
    rejected(changed, live, batches, False)
    changed = [dict(row) for row in rows]
    changed[1]["compiler"] = "kcc"
    rejected(changed, live, batches, False)
    rejected(rows, live, batches, True)
    changed = [dict(row) for row in batches]
    target = next(row for row in changed
                  if row["original_source"] == audit.FIRST)
    target["slot"] = "10"
    rejected(rows, live, changed, False)
    changed = [dict(row) for row in live]
    target = next(row for row in changed
                  if row["original_source"] == audit.SECOND)
    target["p1_state"] = "covered"
    rejected(rows, changed, batches, False)

    print("PASS: Batch 4 hosted contract (8 negative controls)")


if __name__ == "__main__":
    main()
