#!/usr/bin/env python3
"""Fail-closed manifest and guest-evidence controls for 980605 stack P1."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_980605_stack_audit_v1", ROOT / "tools/audit-p1-980605-stack-v1.py")
auditor = importlib.util.module_from_spec(spec)
spec.loader.exec_module(auditor)


def reject(rows, matrix, previous):
    try:
        auditor.validate(rows, matrix, previous)
    except ValueError:
        return
    raise AssertionError("invalid original/companion admission accepted")


def main():
    auditor.audit()
    rows = auditor.read(auditor.MANIFEST)
    matrix = auditor.read(auditor.MATRIX, True)
    previous = auditor.read(auditor.PREVIOUS)
    count = 0
    for key, value in (("role", "original"), ("status", "run_fail"),
                       ("source_sha256", "0" * 64),
                       ("profile", "gcc-ki10-o2"), ("cpu", "ki10"),
                       ("report_sha256", "invalid"),
                       ("asm_member", "companion/pdp6/fake.s")):
        changed = [dict(r) for r in rows]
        changed[7][key] = value
        reject(changed, matrix, previous)
        count += 1
    reject(rows[:-1], matrix, previous)
    count += 1
    changed = [dict(r) for r in matrix]
    for row in changed:
        if row["test"] == auditor.COMPANION:
            row["pdp6_gcc_os"] = "no_test"
    reject(rows, changed, previous)
    count += 1
    changed = [dict(r) for r in previous]
    for row in changed:
        if row["original_source"] == auditor.ORIGINAL:
            row["p1_state"] = "covered"
    reject(rows, matrix, changed)
    count += 1
    damaged = bytearray(auditor.ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        auditor.validate_archive(rows, bytes(damaged))
    except ValueError:
        pass
    else:
        raise AssertionError("corrupt archived guest/ASM evidence accepted")
    count += 1
    print("PASS: 980605 original/companion (%d negative controls)" % count)


if __name__ == "__main__":
    main()
