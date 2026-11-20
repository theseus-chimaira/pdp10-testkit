#!/usr/bin/env python3
"""Mutation controls for P1 invalid-address prefetch source and evidence."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_prefetch_invalid_v1",
    ROOT / "tools/audit-p1-prefetch-invalid-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def rejected(rows, matrix, historical):
    try:
        audit.validate(rows, matrix, historical)
    except ValueError:
        return
    raise AssertionError("invalid prefetch coverage policy accepted")


def main():
    rows = audit.read(audit.LEDGER)
    matrix = audit.read(audit.MATRIX, True)
    historical = audit.read(audit.HISTORICAL)
    audit.audit()
    changed = [dict(r) for r in rows]
    changed[0]["status"] = "run_fail"
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in rows]
    changed[1]["source_sha256"] = "0" * 64
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in rows]
    changed[2]["profile"] = changed[0]["profile"]
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in rows]
    changed.pop()
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in matrix]
    for item in changed:
        if item["test"] == audit.SOURCE:
            item["pdp6_gcc_o2"] = "no_test"
    rejected(rows, changed, historical)
    changed = [dict(r) for r in historical]
    for item in changed:
        if item["original_source"] == audit.ORIGINAL:
            item["original_sha256"] = "0" * 64
    rejected(rows, matrix, changed)
    data = bytearray(audit.ARCHIVE.read_bytes())
    data[len(data) // 2] ^= 1
    try:
        audit.verify_reports(rows, bytes(data))
    except ValueError:
        pass
    else:
        raise AssertionError("tampered guest reports accepted")
    print("PASS: invalid-address prefetch evidence (7 negative controls)")


if __name__ == "__main__":
    main()
