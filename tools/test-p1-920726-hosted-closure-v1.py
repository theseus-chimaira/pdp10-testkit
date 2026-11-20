#!/usr/bin/env python3
"""Negative controls for P1 hosted formatting and return-ABI coverage."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_920726_closure_v1",
    ROOT / "tools/audit-p1-920726-hosted-closure-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def rejected(rows, matrix, previous):
    try:
        audit.validate(rows, matrix, previous)
    except ValueError:
        return
    raise AssertionError("false hosted/ABI evidence accepted")


def main():
    audit.audit()
    rows = audit.read(audit.MANIFEST)
    matrix = audit.read(audit.MATRIX, True)
    previous = audit.read(audit.PREVIOUS)
    changed = [dict(r) for r in rows]
    changed[0]["status"] = "run_fail"
    rejected(changed, matrix, previous)
    changed = [dict(r) for r in rows]
    changed[1]["source_sha256"] = "0" * 64
    rejected(changed, matrix, previous)
    changed = [dict(r) for r in rows]
    changed[2]["profile"] = changed[0]["profile"]
    rejected(changed, matrix, previous)
    changed = [dict(r) for r in rows]
    changed[3]["report_member"] = changed[1]["report_member"]
    rejected(changed, matrix, previous)
    changed = [dict(r) for r in rows]
    changed.pop()
    rejected(changed, matrix, previous)
    changed = [dict(r) for r in matrix]
    for r in changed:
        if r["test"] == audit.SOURCE:
            r["ki10"] = "no_test"
    rejected(rows, changed, previous)
    changed = [dict(r) for r in previous]
    for r in changed:
        if r["original_source"] == audit.SOURCE:
            r["p1_state"] = "covered"
    rejected(rows, matrix, changed)
    changed = bytearray(audit.ARCHIVE.read_bytes())
    changed[len(changed) // 2] ^= 1
    try:
        audit.validate_archive(rows, bytes(changed))
    except ValueError:
        pass
    else:
        raise AssertionError("changed hosted guest report accepted")
    gcc_rows = audit.read(audit.GCC_RECORDS)
    gcc_archive = audit.GCC_ARCHIVE.read_bytes()
    changed = [dict(r) for r in gcc_rows]
    changed[0]["status"] = "link_fail"
    try:
        audit.validate_gcc(changed, gcc_archive)
    except ValueError:
        pass
    else:
        raise AssertionError("fake GCC formatter pass accepted")
    changed = [dict(r) for r in gcc_rows]
    changed[3]["source_sha256"] = "0" * 64
    try:
        audit.validate_gcc(changed, gcc_archive)
    except ValueError:
        pass
    else:
        raise AssertionError("changed original GCC source accepted")
    changed_archive = bytearray(gcc_archive)
    changed_archive[len(changed_archive) // 2] ^= 1
    try:
        audit.validate_gcc(gcc_rows, bytes(changed_archive))
    except ValueError:
        pass
    else:
        raise AssertionError("tampered GCC guest evidence accepted")
    print("PASS: KCC/GCC hosted original and independent ABI oracle "
          "(11 negative controls)")


if __name__ == "__main__":
    main()
