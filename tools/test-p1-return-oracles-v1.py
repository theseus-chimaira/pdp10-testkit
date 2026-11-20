#!/usr/bin/env python3
"""Host-only fail-closed controls for two P1 return-value companions."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_return_oracles_v1",
    ROOT / "tools/audit-p1-return-oracles-v1.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def reject(case, rows, matrix, live):
    try:
        audit.validate_case(case, rows, matrix, live)
    except ValueError:
        return
    raise AssertionError("incorrect source/profile/oracle policy accepted")


def main():
    matrix = audit.read(audit.MATRIX, True)
    live = audit.read(audit.LIVE)
    audit.audit()
    controls = 0
    for case in audit.CASES:
        rows = audit.read(audit.ROOT / case["records"])
        changed = [dict(r) for r in rows]
        changed[0]["status"] = "run_fail" if rows[0]["status"] != "run_fail" else "pass"
        reject(case, changed, matrix, live)
        controls += 1
        changed = [dict(r) for r in rows]
        changed[2]["fail_id_octal"] = "000000000777"
        reject(case, changed, matrix, live)
        controls += 1
        changed = [dict(r) for r in rows]
        changed[1]["source_sha256"] = "0" * 64
        reject(case, changed, matrix, live)
        controls += 1
        changed = [dict(r) for r in matrix]
        for item in changed:
            if item["test"] == case["source"]:
                item["pdp6_gcc_o0"] = "no_test"
        reject(case, rows, changed, live)
        controls += 1
        changed = [dict(r) for r in live]
        for item in changed:
            if item["original_source"] == case["original"]:
                item["p1_state"] = "covered"
        reject(case, rows, matrix, changed)
        controls += 1
        archive_bytes = bytearray((audit.ROOT / case["archive"]).read_bytes())
        archive_bytes[len(archive_bytes) // 2] ^= 1
        try:
            audit.validate_archive(case, rows, bytes(archive_bytes))
        except ValueError:
            pass
        else:
            raise AssertionError("tampered guest report archive accepted")
        controls += 1
    print("PASS: P1 return-value oracle audit (%d negative controls)" %
          controls)


if __name__ == "__main__":
    main()
