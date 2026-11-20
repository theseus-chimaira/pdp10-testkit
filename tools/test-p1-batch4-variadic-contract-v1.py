#!/usr/bin/env python3
"""Host-only negative controls for Batch 4 variadic failure provenance."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p1_batch4_variadic_v1",
    ROOT / "tools/audit-p1-batch4-variadic-contract-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def rejected(rows, headers, ledger):
    try:
        audit.validate(rows, headers, ledger)
    except ValueError:
        return
    raise AssertionError("invalid source/ABI contract accepted")


def main():
    rows = audit.read(audit.MANIFEST)
    ledger = audit.read(audit.RESOLUTION)
    audit.validate(rows, False, ledger)

    changed = [dict(row) for row in rows]
    changed[2]["status"] = "run_fail"
    rejected(changed, False, ledger)
    changed = [dict(row) for row in rows]
    changed[4]["status"] = "compile_fail"
    rejected(changed, False, ledger)
    changed = [dict(row) for row in rows]
    changed[0]["source_sha256"] = "0" * 64
    rejected(changed, False, ledger)
    changed = [dict(row) for row in rows]
    changed[1]["compiler"] = "kcc"
    rejected(changed, False, ledger)
    changed = [dict(row) for row in rows]
    changed[3]["diagnosis"] = "hosted-printf-missing"
    rejected(changed, False, ledger)
    rejected(rows, True, ledger)
    changed_ledger = [dict(row) for row in ledger]
    target = next(row for row in changed_ledger
                  if row["original_source"] ==
                  "tests/todo/generic/920726-1.c")
    target["p1_state"] = "covered"
    rejected(rows, False, changed_ledger)
    print("PASS: Batch 4 variadic contract (7 negative controls)")


if __name__ == "__main__":
    main()
