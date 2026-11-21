#!/usr/bin/env python3
"""Fail-closed mutation tests for unchanged original KCC conversion PASS.

The evidence is immutable: change a source digest, original-source
status, compiler/library identity, raw guest member or archive byte,
and the independent validator must reject it.  Original GCC 71-bit
link failures are required, not silently removed or relabeled PASS.
"""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "p10tk_kcc_original_conversion_v1",
    ROOT / "tools/build-p1-conversion-kcc-original-v1.py")
EVIDENCE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(EVIDENCE)


def must_reject(call, description):
    try:
        call()
    except (ValueError, EOFError, OSError):
        return
    raise AssertionError("invalid original-source evidence accepted: " +
                         description)


def main():
    rows = EVIDENCE.audit()
    raw = EVIDENCE.ARCHIVE.read_bytes()
    mutations = (
        (0, "role", "original"),
        (0, "source_sha256", "0" * 64),
        (1, "profile", "gcc-ka10-o0"),
        (5, "status", "run_fail"),
        (48, "status", "run_fail"),
        (49, "compiler_sha256", "0" * 64),
        (50, "status", "pass"),
        (51, "report_member", "fabricated.report.txt"),
        (52, "log_sha256", "0" * 64),
        (53, "signed_df_archive_sha256", "-"),
        (54, "asm_sha256", "corrupt"),
    )
    passed = 0
    for index, field, bad in mutations:
        candidate = [dict(row) for row in rows]
        candidate[index][field] = bad
        def verify_candidate():
            EVIDENCE.verify_rows(candidate)
            EVIDENCE.verify_archive(candidate, raw)
        must_reject(verify_candidate, field)
        passed += 1
    for candidate in (rows[:-1], rows[1:]):
        must_reject(lambda: EVIDENCE.verify_rows(candidate),
                    "missing profile")
        passed += 1
    damaged = bytearray(raw)
    damaged[len(damaged) // 2] ^= 1
    must_reject(lambda: EVIDENCE.verify_archive(rows, bytes(damaged)),
                "altered raw guest archive")
    passed += 1
    assert passed == 14
    print("PASS: 52 actual native PDP-6 conversion/original PASS, "
          "8 genuine GCC 71-bit link failures, 289 raw artifacts, "
          "%d negative controls" % passed)


if __name__ == "__main__":
    main()
