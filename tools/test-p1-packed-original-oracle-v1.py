#!/usr/bin/env python3
"""Host-only mutation controls for executable packed-aggregate coverage."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_packed_original_v1",
    ROOT / "tools/audit-p1-packed-original-oracle-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def rejected(rows, matrix, historical):
    try:
        audit.validate(rows, matrix, historical)
    except ValueError:
        return
    raise AssertionError("invalid packed compiler coverage accepted")


def main():
    audit.audit()
    rows = audit.read(audit.LEDGER)
    matrix = audit.read(audit.MATRIX, True)
    historical = audit.read(audit.HISTORICAL)
    changed = [dict(r) for r in rows]
    changed[0]["status"] = "pass"
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in rows]
    changed[1]["source_sha256"] = "0" * 64
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in rows]
    changed[1]["profile"] = changed[0]["profile"]
    rejected(changed, matrix, historical)
    changed = [dict(r) for r in matrix]
    for r in changed:
        if r["test"] == audit.SOURCE:
            r["pdp6"] = "no_test"
    rejected(rows, changed, historical)
    changed = [dict(r) for r in historical]
    for r in changed:
        if r["original_source"] == audit.SOURCE:
            r["p1_state"] = "covered"
    rejected(rows, matrix, changed)
    payload = bytearray(audit.ARCHIVE.read_bytes())
    payload[len(payload) // 2] ^= 1
    try:
        audit.verify_reports(rows, bytes(payload))
    except ValueError:
        pass
    else:
        raise AssertionError("mutated original simulator report accepted")
    print("PASS: original packed-aggregate evidence (6 negative controls)")


if __name__ == "__main__":
    main()
