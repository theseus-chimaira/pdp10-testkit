#!/usr/bin/env python3
"""Host-only mutation controls for the P1 Batch 4 libc contract auditor."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_batch4_libc_v1",
    ROOT / "tools/audit-p1-batch4-libc-contract-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def rejected(rows, exports):
    try:
        audit.validate(rows, exports)
    except ValueError:
        return
    raise AssertionError("inconsistent Batch 4 contract accepted")


def main():
    records = audit.read(audit.MANIFEST)
    valid_exports = set()
    audit.validate(records, valid_exports)

    changed = [dict(r) for r in records]
    changed[0]["status"] = "pass"
    rejected(changed, valid_exports)
    changed = [dict(r) for r in records]
    changed[0]["missing_symbol"] = "-"
    rejected(changed, valid_exports)
    changed = [dict(r) for r in records]
    changed[0]["source_sha256"] = "0" * 64
    rejected(changed, valid_exports)
    changed = [dict(r) for r in records]
    changed[1]["compiler"] = changed[0]["compiler"]
    rejected(changed, valid_exports)
    rejected(records, {"isprint"})
    rejected(records, {"__fixunssfsi"})
    print("PASS: P1 Batch 4 libc audit (4 cases, 6 negative controls)")


if __name__ == "__main__":
    main()
