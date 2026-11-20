#!/usr/bin/env python3
"""Host-only mutation tests for P1 Batch 6 prerequisite classifications."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_batch6_v1", ROOT / "tools/audit-p1-batch6-contract-v1.py")
auditor = importlib.util.module_from_spec(spec)
spec.loader.exec_module(auditor)


def expect_rejected(rows, frozen, live):
    try:
        auditor.validate(rows, frozen, live)
    except (KeyError, ValueError):
        return
    raise AssertionError("corrupted P1 Batch 6 record accepted")


def changed(rows, index, key, value):
    copies = [dict(item) for item in rows]
    copies[index][key] = value
    return copies


def main():
    rows = auditor.read(auditor.MANIFEST)
    frozen = auditor.read(auditor.FROZEN)
    live = auditor.read(auditor.LIVE)
    auditor.validate(rows, frozen, live)

    expect_rejected(changed(rows, 5, "status", "pass"), frozen, live)
    expect_rejected(changed(rows, 1, "status", "run_fail"), frozen, live)
    expect_rejected(changed(rows, 4, "reason", "expected-non-tops20-exit"),
                    frozen, live)
    expect_rejected(changed(rows, 10, "reason", "missing-printf"),
                    frozen, live)
    expect_rejected(changed(rows, 0, "source_sha256", "0" * 64),
                    frozen, live)
    expect_rejected(changed(rows, 7, "compiler", "kcc"), frozen, live)
    expect_rejected(changed(rows, 8, "profile", "gcc-pdp6-o0"),
                    frozen, live)
    expect_rejected(rows[:-1], frozen, live)
    moved = [dict(item) for item in frozen]
    target = next(item for item in moved if item["batch"] == "6")
    target["slot"] = "2"
    expect_rejected(rows, moved, live)
    promoted = [dict(item) for item in live]
    target = next(item for item in promoted if item["original_source"] ==
                  auditor.ORIGINALS[2])
    target["p1_state"] = "covered"
    expect_rejected(rows, frozen, promoted)
    print("PASS: P1 Batch 6 prerequisite contracts (10 negative controls)")


if __name__ == "__main__":
    main()
