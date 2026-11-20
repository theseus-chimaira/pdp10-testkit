#!/usr/bin/env python3
"""Fail-closed controls for real PDP-6 36-bit conversion evidence."""

import csv
import importlib.util
import io
from pathlib import Path
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "p10tk_p1_conversion36_v1",
    ROOT / "tools/build-p1-conversion-36bit-evidence-v1.py")
BUILDER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BUILDER)


def main():
    rows = BUILDER.audit()
    count = 0
    changes = (
        (0, "role", "signed-final"),
        (0, "source_sha256", "0" * 64),
        (1, "profile", "gcc-ka10-o0"),
        (4, "status", "pass"),
        (5, "fail_id", "0"),
        (6, "compiler_sha256", "0" * 64),
        (7, "kcc_fp36_archive_sha256", "-"),
        (8, "core_libc_sha256", "0" * 64),
        (9, "report_member", "missing-report"),
        (10, "asm_sha256", "bad"),
    )
    for index, field, wrong in changes:
        altered = [dict(r) for r in rows]
        altered[index][field] = wrong
        try:
            BUILDER.verify_rows(altered)
        except ValueError:
            count += 1
        else:
            raise AssertionError("incorrect conversion evidence accepted: " + field)
    for changed in (rows[:-1], rows[1:]):
        try:
            BUILDER.verify_rows(changed)
        except ValueError:
            count += 1
        else:
            raise AssertionError("missing conversion guest profile accepted")
    raw = bytearray(BUILDER.ARCHIVE.read_bytes())
    raw[len(raw) // 2] ^= 1
    try:
        BUILDER.verify_archive(rows, bytes(raw))
    except ValueError:
        count += 1
    else:
        raise AssertionError("damaged raw conversion guest archive accepted")
    with tarfile.open(fileobj=io.BytesIO(BUILDER.ARCHIVE.read_bytes()),
                      mode="r:gz") as archive:
        assert len(archive.getmembers()) == 230
    assert count == 13
    print("PASS: PDP-6 36-bit conversion 30 PASS, 18 genuine failures, "
          "230 raw artifacts, %d mutation controls" % count)


if __name__ == "__main__":
    main()
