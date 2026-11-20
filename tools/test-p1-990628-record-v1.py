#!/usr/bin/env python3
"""Fail-closed test of source identities and real 990628 guest results."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_990628_gate_v1", ROOT / "tools/audit-p1-990628-record-v1.py")
auditor = importlib.util.module_from_spec(spec)
spec.loader.exec_module(auditor)


def rejects(rows, matrix, old):
    try:
        auditor.validate(rows, matrix, old)
    except ValueError:
        return
    raise AssertionError("false 990628 source/profile result accepted")


def main():
    auditor.audit()
    rows = auditor.read(auditor.MANIFEST)
    matrix = auditor.read(auditor.MATRIX, True)
    old = auditor.read(auditor.PREVIOUS)
    count = 0
    for field, value in (("source_sha256", "0" * 64),
                         ("status", "run_fail"),
                         ("profile", "gcc-ka10-o0"),
                         ("role", "original"),
                         ("report_sha256", "bad"),
                         ("asm_member", "fake.s")):
        changed = [dict(row) for row in rows]
        changed[4][field] = value
        rejects(changed, matrix, old)
        count += 1
    rejects(rows[:-1], matrix, old)
    count += 1
    changed = [dict(row) for row in matrix]
    for row in changed:
        if row["test"] == auditor.COMPANION:
            row["pdp6_gcc_o2"] = "no_test"
    rejects(rows, changed, old)
    count += 1
    changed = [dict(row) for row in old]
    for row in changed:
        if row["original_source"] == auditor.ORIGINAL:
            row["p1_state"] = "covered"
    rejects(rows, matrix, changed)
    count += 1
    damaged = bytearray(auditor.ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        auditor.validate_archive(rows, bytes(damaged))
    except ValueError:
        pass
    else:
        raise AssertionError("mutated 990628 output archive accepted")
    count += 1
    print("PASS: native 990628 source/record-copy proof (%d negative controls)" % count)


if __name__ == "__main__":
    main()
