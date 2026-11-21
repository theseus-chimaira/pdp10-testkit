#!/usr/bin/env python3
"""Fail-closed mutation tests for the 175 real ICE-focused native runs."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "p10tk_harness_observations_v1",
    ROOT / "tools/audit-harness-integration-evidence-v1.py")
AUDIT = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(AUDIT)


def must_reject(func, name):
    try:
        func()
    except (ValueError, EOFError, OSError):
        return
    raise AssertionError("corrupt native observation accepted: " + name)


def main():
    rows = AUDIT.audit()
    raw = AUDIT.ARCHIVE.read_bytes()
    assert len(rows) == 175
    ice_index = next(i for i, row in enumerate(rows)
                     if row["status"] == "compiler_ice")
    mutations = (
        (0, "role", "original-gcc-o0"),
        (0, "source", "tests/not-a-real-source.c"),
        (0, "source_sha256", "0" * 64),
        (0, "status", "compile_fail"),
        (0, "compiler_sha256", "0" * 64),
        (0, "profile", "kcc-ka10-noopt"),
        (0, "kind", "semantic"),
        (0, "status_sha256", "0" * 64),
        (0, "asm_member", "not-a-real-assembly.s"),
        (ice_index, "status", "pass"),
        (ice_index, "compiler_stdlib_sha256", "0" * 64),
    )
    count = 0
    for index, field, bad in mutations:
        altered = [dict(row) for row in rows]
        altered[index][field] = bad
        must_reject(lambda: (AUDIT.verify_rows(altered),
                             AUDIT.verify_archive(altered, raw)), field)
        count += 1
    for changed in (rows[:-1], rows[1:]):
        must_reject(lambda: AUDIT.verify_rows(changed), "missing guest cell")
        count += 1
    corrupted = bytearray(raw)
    corrupted[len(corrupted) // 2] ^= 1
    must_reject(lambda: AUDIT.verify_archive(rows, bytes(corrupted)),
                "damaged archive byte")
    count += 1
    assert count == 14
    print("PASS: 175 actual PDP-6 harness observations, "
          "582 authentic raw artifacts, one true compiler ICE "
          "and %d negative controls" % count)


if __name__ == "__main__":
    main()
