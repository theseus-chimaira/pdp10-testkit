#!/usr/bin/env python3
"""Fail-closed testkit controls for executable original 960327-1.c."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_960327_audit_v1", ROOT / "tools/audit-p1-960327-original-v1.py")
auditor = importlib.util.module_from_spec(spec)
spec.loader.exec_module(auditor)


def reject(rows, matrix, ledger):
    try:
        auditor.validate(rows, matrix, ledger)
    except ValueError:
        return
    raise AssertionError("false original test acceptance")


def main():
    auditor.audit()
    rows = auditor.read(auditor.MANIFEST)
    matrix = auditor.read(auditor.MATRIX, True)
    ledger = auditor.read(auditor.HISTORICAL)
    changed = [dict(r) for r in rows]
    changed[0]["status"] = "link_fail"
    reject(changed, matrix, ledger)
    changed = [dict(r) for r in rows]
    changed[1]["source_sha256"] = "0" * 64
    reject(changed, matrix, ledger)
    changed = [dict(r) for r in rows]
    changed[3]["cpu"] = "pdp6"
    reject(changed, matrix, ledger)
    changed = [dict(r) for r in rows]
    changed[8]["profile"] = "gcc-ki10-o0"
    reject(changed, matrix, ledger)
    changed = [dict(r) for r in rows]
    changed.pop()
    reject(changed, matrix, ledger)
    changed = [dict(r) for r in matrix]
    for r in changed:
        if r["test"] == auditor.SOURCE:
            r["ks10"] = "no_test"
    reject(rows, changed, ledger)
    changed = [dict(r) for r in ledger]
    for r in changed:
        if r["original_source"] == auditor.SOURCE:
            r["p1_state"] = "covered"
    reject(rows, matrix, changed)
    changed = bytearray(auditor.ARCHIVE.read_bytes())
    changed[len(changed) // 2] ^= 1
    try:
        auditor.validate_archive(rows, bytes(changed))
    except ValueError:
        pass
    else:
        raise AssertionError("corrupted original guest archive accepted")
    print("PASS: 960327-1.c nine original profiles (8 negative controls)")


if __name__ == "__main__":
    main()
