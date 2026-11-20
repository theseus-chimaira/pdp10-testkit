#!/usr/bin/env python3
"""Negative controls for unchanged original and shifted-array companion."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_960521_gate_v1", ROOT / "tools/audit-p1-960521-shifted-array-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def reject(rows, matrix, history):
    try:
        audit.validate(rows, matrix, history)
    except ValueError:
        return
    raise AssertionError("false 960521 original/companion state accepted")


def main():
    audit.audit()
    rows = audit.read(audit.MANIFEST)
    matrix = audit.read(audit.MATRIX, True)
    historical = audit.read(audit.PREVIOUS)
    count = 0
    for key, value in (("source_sha256", "0" * 64),
                       ("status", "run_fail"),
                       ("profile", "gcc-ks10-os"),
                       ("role", "original"),
                       ("report_sha256", "not-a-sha"),
                       ("asm_member", "fake.s")):
        changed = [dict(row) for row in rows]
        changed[6][key] = value
        reject(changed, matrix, historical)
        count += 1
    reject(rows[:-1], matrix, historical)
    count += 1
    changed = [dict(row) for row in matrix]
    for row in changed:
        if row["test"] == audit.COMPANION:
            row["pdp6_gcc_o2"] = "no_test"
    reject(rows, changed, historical)
    count += 1
    changed = [dict(row) for row in historical]
    for row in changed:
        if row["original_source"] == audit.ORIGINAL:
            row["p1_state"] = "covered"
    reject(rows, matrix, changed)
    count += 1
    damaged = bytearray(audit.ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        audit.validate_archive(rows, bytes(damaged))
    except ValueError:
        pass
    else:
        raise AssertionError("damaged original guest archive passed")
    count += 1
    print("PASS: 960521 original/companion (%d negative controls)" % count)


if __name__ == "__main__":
    main()
