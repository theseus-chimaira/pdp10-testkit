#!/usr/bin/env python3
"""Fail-closed host tests for exact 920501 default-libc provider replay."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_920501_provider_v1", ROOT / "tools/audit-p1-920501-stdio-provider-v1.py")
auditor = importlib.util.module_from_spec(spec)
spec.loader.exec_module(auditor)


def reject(rows, payload):
    try:
        auditor.validate(rows, payload)
    except ValueError:
        return
    raise AssertionError("corrupt or misattributed 920501 linker input accepted")


def main():
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--require-cross", action="store_true")
    args = parser.parse_args()
    auditor.audit(args.require_cross)
    rows = auditor.load_manifest()
    data = auditor.ARCHIVE.read_bytes()
    count = 0
    for key, bad in (("sha256", "0" * 64),
                     ("member", "inputs/00-fake.dobj"),
                     ("size_bytes", "999999")):
        changed = [dict(row) for row in rows]
        changed[0][key] = bad
        reject(changed, data)
        count += 1
    reject(rows[:-1], data)
    count += 1
    changed = [dict(row) for row in rows]
    changed[-1]["member"] = changed[0]["member"]
    reject(changed, data)
    count += 1
    damaged = bytearray(data)
    damaged[len(damaged) // 2] ^= 1
    reject(rows, bytes(damaged))
    count += 1
    print("PASS: 920501 provider provenance (%d negative controls)" % count)


if __name__ == "__main__":
    main()
