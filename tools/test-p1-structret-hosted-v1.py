#!/usr/bin/env python3
"""Negative controls for combined original/companion struct-ret coverage."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_structret_hosted_v1", ROOT / "tools/audit-p1-structret-hosted-v1.py")
verifier = importlib.util.module_from_spec(spec)
spec.loader.exec_module(verifier)


def reject(rows, matrix, historical):
    try:
        verifier.validate(rows, matrix, historical)
    except ValueError:
        return
    raise AssertionError("false hosted struct-return acceptance")


def main():
    verifier.audit()
    rows = verifier.read(verifier.MANIFEST)
    matrix = verifier.read(verifier.MATRIX, True)
    historical = verifier.read(verifier.PREVIOUS)
    for key, invalid in (("status", "link_fail"),
                         ("source_sha256", "0" * 64),
                         ("profile", "gcc-ki10-o0"),
                         ("report_sha256", "x"),
                         ("cpu", "ki10")):
        changed = [dict(r) for r in rows]
        changed[0][key] = invalid
        reject(changed, matrix, historical)
    reject(rows[:-1], matrix, historical)
    changed = [dict(r) for r in matrix]
    for row in changed:
        if row["test"] == verifier.SOURCE:
            row["pdp6_gcc_o2"] = "no_test"
    reject(rows, changed, historical)
    changed = [dict(r) for r in historical]
    for row in changed:
        if row["original_source"] == verifier.SOURCE:
            row["p1_state"] = "covered"
    reject(rows, matrix, changed)
    damaged = bytearray(verifier.ARCHIVE.read_bytes())
    damaged[len(damaged) // 2] ^= 1
    try:
        verifier.validate_archive(rows, bytes(damaged))
    except ValueError:
        pass
    else:
        raise AssertionError("corrupt original guest archive accepted")
    print("PASS: struct-ret original and companion (9 negative controls)")


if __name__ == "__main__":
    main()
