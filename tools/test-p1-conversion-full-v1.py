#!/usr/bin/env python3
"""Fail-closed evidence controls for the original 71-bit P1 conversion.

Rejects false successful native compiler/CPU profiles, missing
source identities, fabricated simulator reports, altered archived
libgcc objects and corrupted raw DARC evidence.
"""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "p10tk_p1_conversion_full_v1",
    ROOT / "tools/build-p1-conversion-full-v1.py")
EVIDENCE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(EVIDENCE)


def must_reject(callback, label):
    try:
        callback()
    except (ValueError, EOFError, OSError):
        return
    raise AssertionError("invalid 71-bit compiler conversion accepted: " + label)


def main():
    rows = EVIDENCE.audit()
    raw = EVIDENCE.ARCHIVE.read_bytes()
    mutations = (
        (0, "role", "gnu71"),
        (1, "profile", "gcc-ka10-o0"),
        (2, "status", "run_fail"),
        (3, "compiler_sha256", "0" * 64),
        (4, "libgcc_archive_sha256", "0" * 64),
        (5, "core_libc_sha256", "0" * 64),
        (6, "source_sha256", "0" * 64),
        (7, "report_member", "fabricated.report.txt"),
        (8, "report_sha256", "0" * 64),
        (9, "map_sha256", "0" * 64),
        (10, "asm_sha256", "0" * 64),
        (12, "source", "tests/todo/generic/fake.c"),
        (16, "status", "link_fail"),
        (20, "cpu", "ka10"),
    )
    verified = 0
    for index, field, bad in mutations:
        changed = [dict(row) for row in rows]
        changed[index][field] = bad

        def probe():
            EVIDENCE.verify_rows(changed)
            EVIDENCE.verify_archive(changed, raw)

        must_reject(probe, field)
        verified += 1
    for changed in (rows[:-1], rows[1:]):
        must_reject(lambda: EVIDENCE.verify_rows(changed), "omitted profile")
        verified += 1
    damaged = bytearray(raw)
    damaged[len(damaged) // 2] ^= 1
    must_reject(lambda: EVIDENCE.verify_archive(rows, bytes(damaged)),
                "corrupt stored guest or compiler archive")
    verified += 1
    assert verified == 17
    print("PASS: original 71-bit conversion 6 native PDP-6 PASS, "
          "original-line 6 PASS, C89 direct ABI 4 PASS, "
          "original GNU sections 8 PASS, 129 raw artifacts, "
          "%d negative mutation controls" % verified)


if __name__ == "__main__":
    main()
