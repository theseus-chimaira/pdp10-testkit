#!/usr/bin/env python3
"""Negative controls for 920501 original and manyargs sprintf guest failures."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_920501_audit_v1", ROOT / "tools/audit-p1-920501-manyargs-v1.py")
auditor = importlib.util.module_from_spec(spec)
spec.loader.exec_module(auditor)


def reject(rows, matrix, previous):
    try:
        auditor.validate(rows, matrix, previous)
    except ValueError:
        return
    raise AssertionError("invalid original/companion profile accepted")


def main():
    auditor.audit()
    rows = auditor.read(auditor.MANIFEST)
    matrix = auditor.read(auditor.MATRIX, True)
    previous = auditor.read(auditor.PREVIOUS)
    checks = 0
    for key, value in (("source_sha256", "0" * 64),
                       ("status", "pass"), ("profile", "gcc-ka10-o2"),
                       ("role", "original"), ("artifact_sha256", "bad"),
                       ("map_member", "lost.map")):
        changed = [dict(r) for r in rows]
        changed[4][key] = value
        reject(changed, matrix, previous)
        checks += 1
    reject(rows[:-1], matrix, previous)
    checks += 1
    changed = [dict(r) for r in matrix]
    for r in changed:
        if r["test"] == auditor.COMPANION:
            r["pdp6_gcc_o2"] = "no_test"
    reject(rows, changed, previous)
    checks += 1
    changed = [dict(r) for r in previous]
    for r in changed:
        if r["original_source"] == auditor.ORIGINAL:
            r["p1_state"] = "covered"
    reject(rows, matrix, changed)
    checks += 1
    archive = bytearray(auditor.ARCHIVE.read_bytes())
    archive[len(archive) // 2] ^= 1
    try:
        auditor.validate_archive(rows, bytes(archive))
    except ValueError:
        pass
    else:
        raise AssertionError("corrupted checkpoint evidence accepted")
    checks += 1
    print("PASS: 920501 original and six guest failures (%d negative controls)" % checks)


if __name__ == "__main__":
    main()
