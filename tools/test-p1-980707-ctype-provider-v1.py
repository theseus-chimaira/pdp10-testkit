#!/usr/bin/env python3
"""Negative controls for KCC original hosted ctype/exit ownership."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_980707_ctype_v1", ROOT / "tools/audit-p1-980707-ctype-provider-v1.py")
auditor = importlib.util.module_from_spec(spec)
spec.loader.exec_module(auditor)


def reject(rows, payload):
    try:
        auditor.verify(rows, payload)
    except ValueError:
        return
    raise AssertionError("false 980707 provider evidence was accepted")


def main():
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-cross", action="store_true")
    args = parser.parse_args()
    auditor.audit(args.require_cross)
    rows = auditor.load()
    payload = auditor.ARCHIVE.read_bytes()
    count = 0
    for field, bad in (("sha256", "0" * 64),
                       ("member", "inputs/00-fake.dobj"),
                       ("size_bytes", "999999")):
        changed = [dict(row) for row in rows]
        changed[0][field] = bad
        reject(changed, payload)
        count += 1
    reject(rows[:-1], payload)
    count += 1
    changed = [dict(row) for row in rows]
    changed[-1]["member"] = changed[0]["member"]
    reject(changed, payload)
    count += 1
    altered = bytearray(payload)
    altered[len(altered) // 2] ^= 1
    reject(rows, bytes(altered))
    count += 1
    print("PASS: native 980707 ctype/libc/exit ownership "
          "(%d negative controls)" % count)


if __name__ == "__main__":
    main()
