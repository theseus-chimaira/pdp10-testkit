#!/usr/bin/env python3
"""Fail-closed controls for GNU variable-sized va_arg original evidence."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_vla_original_oracle_v1",
    ROOT / "tools/audit-p1-variadic-vla-original-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def rejected(rows, matrix, historical):
    try:
        audit.validate(rows, matrix, historical)
    except ValueError:
        return
    raise AssertionError("invalid VLA oracle evidence accepted")


def main():
    audit.audit()
    rows = audit.read(audit.MANIFEST)
    matrix = audit.read(audit.MATRIX, True)
    historical = audit.read(audit.HISTORICAL)
    changed = [dict(r) for r in rows]
    changed[0]["status"] = "pass"
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in rows]
    changed[1]["status"] = "pass"
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in rows]
    changed[2]["source_sha256"] = "0" * 64
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in rows]
    changed[3]["profile"] = changed[2]["profile"]
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in matrix]
    for item in changed:
        if item["test"] == audit.SOURCE:
            item["pdp6_gcc_o2"] = "no_test"
    rejected(rows, changed, historical)
    changed = [dict(r) for r in historical]
    for item in changed:
        if item["original_source"] == audit.SOURCE:
            item["p1_state"] = "covered"
    rejected(rows, matrix, changed)
    data = bytearray(audit.ARCHIVE.read_bytes())
    data[len(data) // 2] ^= 1
    try:
        audit.validate_archive(rows, bytes(data))
    except ValueError:
        pass
    else:
        raise AssertionError("altered GCC guest archive accepted")
    print("PASS: original variable-sized va_arg (7 negative controls)")


if __name__ == "__main__":
    main()
