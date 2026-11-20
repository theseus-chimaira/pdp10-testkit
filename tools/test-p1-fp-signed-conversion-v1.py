#!/usr/bin/env python3
"""Fail-closed source and guest evidence checks for signed conversions."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_fp_signed_v1",
    ROOT / "tools/audit-p1-fp-signed-conversion-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def rejected(rows, matrix, resolution):
    try:
        audit.validate(rows, matrix, resolution)
    except ValueError:
        return
    raise AssertionError("invalid conversion companion policy accepted")


def main():
    audit.audit()
    rows = audit.read(audit.MANIFEST)
    matrix = audit.read(audit.MATRIX, True)
    resolution = audit.read(audit.RESOLUTION)
    changed = [dict(row) for row in rows]
    changed[0]["status"] = "pass"
    rejected(changed, matrix, resolution)
    changed = [dict(row) for row in rows]
    changed[1]["failed_groups_octal"] = "000000000001"
    rejected(changed, matrix, resolution)
    changed = [dict(row) for row in rows]
    changed[2]["source_sha256"] = "0" * 64
    rejected(changed, matrix, resolution)
    changed = [dict(row) for row in rows]
    changed[3]["profile"] = changed[2]["profile"]
    rejected(changed, matrix, resolution)
    changed = [dict(row) for row in matrix]
    for item in changed:
        if item["test"] == audit.SOURCE:
            item["pdp6_gcc_o1"] = "no_test"
    rejected(rows, changed, resolution)
    changed = [dict(row) for row in resolution]
    for item in changed:
        if item["original_source"] == audit.ORIGINAL:
            item["p1_state"] = "covered"
    rejected(rows, matrix, changed)
    changed = bytearray(audit.ARCHIVE.read_bytes())
    changed[len(changed) // 2] ^= 1
    try:
        audit.verify_archive(rows, bytes(changed))
    except ValueError:
        pass
    else:
        raise AssertionError("tampered report accepted")
    print("PASS: native signed conversion companion (7 negative controls)")


if __name__ == "__main__":
    main()
