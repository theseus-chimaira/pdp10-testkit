#!/usr/bin/env python3
"""Host-only negative controls for P1 native CPU/optimization admission."""

import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location(
    "p10tk_native_admission_v1",
    ROOT / "tools/audit-p1-matrix-admission-v3.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


def rejected(rows, matrix, ledger):
    try:
        audit.validate(rows, matrix, ledger)
    except (ValueError, KeyError):
        return
    raise AssertionError("invalid P1 matrix admission was accepted")


def mutate(rows, key, value, name):
    changed = [dict(r) for r in rows]
    target = next(r for r in changed if r["test"] == name)
    target[key] = value
    return changed


def main():
    rows = audit.read(audit.MANIFEST)
    matrix = audit.read(audit.MATRIX, True)
    ledger = audit.read(audit.LEDGER)
    _, new, cells = audit.validate(rows, matrix, ledger)
    assert new == 126 and cells == 249
    source = "tests/todo/generic/20020412-1.c"
    reject = lambda rows: rejected(rows, matrix, ledger)

    rejected(rows, mutate(matrix, "pdp6_gcc_o2", "no_test", source), ledger)
    rejected(rows, mutate(matrix, "ka10", "no_test", source), ledger)
    rejected(rows, mutate(matrix, "ki10_gcc_o1", "ok", source), ledger)
    rejected(rows, mutate(matrix, "pdp6_base", "pending", source), ledger)
    c = "tests/todo/generic/960521-1.c"
    rejected(rows, mutate(matrix, "pdp6_gcc_o1", "pending", c), ledger)
    c = "tests/todo/generic/920726-1.c"
    rejected(rows, mutate(matrix, "ka10", "no_test", c), ledger)
    rejected(rows, mutate(matrix, "ka10_gcc_o0", "pending", c), ledger)
    c = "tests/semantic/upstream/extensions/stdio-opt-2.c"
    rejected(rows, mutate(matrix, "pdp6_gcc_os", "no_test", c), ledger)
    changed = [dict(r) for r in rows]
    target = next(r for r in changed if
                  r["original_source"].endswith("/980605-1.c"))
    target["tier"] = "dual-native"
    reject(changed)
    changed = [dict(r) for r in rows]
    target = next(r for r in changed if
                  r["original_source"].endswith("/920810-1.c"))
    target["source_sha256"] = "0" * 64
    reject(changed)
    changed = [dict(r) for r in ledger]
    target = next(r for r in changed if
                  r["original_source"].endswith("/20020412-1.c"))
    target["p1_state"] = "covered"
    rejected(rows, matrix, changed)
    changed = [dict(r) for r in rows]
    changed.pop()
    reject(changed)
    changed = [dict(r) for r in matrix]
    target = next(r for r in changed if r["test"] == source)
    changed.append(dict(target))
    rejected(rows, changed, ledger)
    smoke = audit.read(audit.SMOKE)
    payload = audit.SMOKE_ARCHIVE.read_bytes()
    audit.validate_smoke(smoke, payload, matrix)
    changed = [dict(r) for r in smoke]
    changed[0]["status"] = "run_fail"
    try:
        audit.validate_smoke(changed, payload, matrix)
    except ValueError:
        pass
    else:
        raise AssertionError("falsified KA10 guest success accepted")
    changed = [dict(r) for r in smoke]
    changed[2]["evidence_sha256"] = "0" * 64
    try:
        audit.validate_smoke(changed, payload, matrix)
    except ValueError:
        pass
    else:
        raise AssertionError("altered linker evidence SHA accepted")
    changed = bytearray(payload)
    changed[len(changed) // 2] ^= 1
    try:
        audit.validate_smoke(smoke, bytes(changed), matrix)
    except ValueError:
        pass
    else:
        raise AssertionError("tampered target smoke archive accepted")
    print("PASS: native P1 matrix admission, 16 negative controls")


if __name__ == "__main__":
    main()
