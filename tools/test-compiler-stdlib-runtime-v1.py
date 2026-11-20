#!/usr/bin/env python3
"""Host negative controls for actual compiler stdlib PDP-6 outcomes."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_compiler_stdlib_evidence_v1", ROOT / "tools/audit-compiler-stdlib-runtime-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def reject(rows, payload):
    try:
        audit.validate(rows, payload)
    except ValueError:
        return
    raise AssertionError("invalid compiler library guest evidence accepted")


def main():
    audit.audit()
    rows = audit.read_manifest()
    data = audit.ARCHIVE.read_bytes()
    count = 0
    for key, value in (("source_sha256", "0" * 64),
                       ("status", "pass"),
                       ("expected_link_error", "exit"),
                       ("compiler", "gcc"),
                       ("runtime_archive_sha256", "0" * 64),
                       ("status_sha256", "not-a-sha"),
                       ("report_member", "fake-report.txt")):
        changed = [dict(row) for row in rows]
        changed[0][key] = value
        reject(changed, data)
        count += 1
    reject(rows[:-1], data)
    count += 1
    damaged = bytearray(data)
    damaged[len(damaged) // 2] ^= 1
    reject(rows, bytes(damaged))
    count += 1
    print("PASS: compiler stdlib native evidence (%d negative controls)" % count)


if __name__ == "__main__":
    main()
