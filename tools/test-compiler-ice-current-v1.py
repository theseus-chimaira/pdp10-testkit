#!/usr/bin/env python3
"""Fail-closed host regressions for nine current compiler ICE records."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_ice_current_v1", ROOT / "tools/audit-compiler-ice-current-v1.py")
auditor = importlib.util.module_from_spec(spec)
spec.loader.exec_module(auditor)


def must_reject(rows, historical, matrix):
    try:
        auditor.validate(rows, historical, matrix)
    except ValueError:
        return
    raise AssertionError("invalid ICE source/profile status was accepted")


def main():
    auditor.audit()
    rows = auditor.read(auditor.MANIFEST)
    historical = auditor.read(auditor.HISTORICAL)
    matrix = auditor.read(auditor.MATRIX, True)
    count = 0
    for field, value in (("source_sha256", "0" * 64),
                         ("status", "pass"),
                         ("profile", "gcc-ka10-o0"),
                         ("compiler", "kcc"),
                         ("diagnostic_class", "kcc-gizlist"),
                         ("log_sha256", "bad")):
        altered = [dict(r) for r in rows]
        altered[0][field] = value
        must_reject(altered, historical, matrix)
        count += 1
    must_reject(rows[:-1], historical, matrix)
    count += 1
    previous = [dict(r) for r in historical]
    for row in previous:
        if (row["test"] == rows[0]["source"] and
                row["profile"] == rows[0]["profile"]):
            row["status"] = "pass"
    must_reject(rows, previous, matrix)
    count += 1
    changed = [dict(r) for r in matrix]
    for row in changed:
        if row["test"] == rows[0]["source"]:
            row["pdp6_gcc_o0"] = "no_test"
    must_reject(rows, historical, changed)
    count += 1
    damaged = bytearray(auditor.ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        auditor.validate_archive(rows, bytes(damaged))
    except ValueError:
        pass
    else:
        raise AssertionError("corrupted ICE archive passed")
    count += 1
    print("PASS: current compiler ICE evidence (%d negative controls)" % count)


if __name__ == "__main__":
    main()
