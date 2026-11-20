#!/usr/bin/env python3
"""Negative controls for original 930513-1.c completion evidence."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_930513_audit_v1", ROOT / "tools/audit-p1-930513-original-v1.py")
auditor = importlib.util.module_from_spec(spec)
spec.loader.exec_module(auditor)


def rejected(rows, matrix, previous):
    try:
        auditor.validate(rows, matrix, previous)
    except ValueError:
        return
    raise AssertionError("bad original-source evidence was accepted")


def main():
    auditor.audit()
    rows = auditor.read(auditor.MANIFEST)
    matrix = auditor.read(auditor.MATRIX, True)
    previous = auditor.read(auditor.PREVIOUS)
    for field, value in (("status", "link_fail"),
                         ("source_sha256", "0" * 64),
                         ("profile", "gcc-ki10-o0"),
                         ("cpu", "ka10"),
                         ("report_sha256", "not-a-hash")):
        changed = [dict(r) for r in rows]
        changed[2][field] = value
        rejected(changed, matrix, previous)
    rejected(rows[:-1], matrix, previous)
    changed = [dict(r) for r in matrix]
    for row in changed:
        if row["test"] == auditor.SOURCE:
            row["pdp6_gcc_o2"] = "no_test"
    rejected(rows, changed, previous)
    changed = [dict(r) for r in previous]
    for row in changed:
        if row["original_source"] == auditor.SOURCE:
            row["p1_state"] = "covered"
    rejected(rows, matrix, changed)
    damaged = bytearray(auditor.ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        auditor.validate_archive(rows, bytes(damaged))
    except ValueError:
        pass
    else:
        raise AssertionError("damaged compressed guest evidence accepted")
    print("PASS: 930513 original oracle (9 negative controls)")


if __name__ == "__main__":
    main()
