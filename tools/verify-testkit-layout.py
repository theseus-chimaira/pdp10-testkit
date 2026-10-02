#!/usr/bin/env python3
from __future__ import print_function
import csv
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OLD_ROOTS = ["misc", "insn", "pattern", "imported", "standalone"]
OLD_FILES = ["STATE_MATRIX.tsv"]
OBSOLETE_TOOLS = [
    "norm-asm.py",
    "run-asm-checks.py",
    "run-codegen-policy.py",
    "run-full-sweep-local.py",
    "run-kcc-direct-semantic.py",
    "run-matrix.py",
    "run-simh-state-tests.py",
]

missing = []
gcc_runtime_helper_bad = []
header = None
with (ROOT / "TEST_MATRIX.tsv").open(encoding="utf-8", errors="replace") as f:
    for r in csv.reader((l for l in f if l.strip()), delimiter="\t"):
        if not r or r[0].startswith("#"):
            continue
        if r[0] == "test":
            header = r
            continue
        if header is None:
            continue
        row = dict(zip(header, r))
        test = row.get("test", "")
        if not (ROOT / test).is_file():
            missing.append(test)
        if test.startswith("tests/validation/gcc/runtime-helper/libgcc_helper_ownership_"):
            for key, value in row.items():
                if key in ("test", "group", "name") or "_gcc" in key:
                    continue
                if value not in ("no_test", "unsupported", "obsolete", ""):
                    gcc_runtime_helper_bad.append((test, key, value))

old_roots = [d for d in OLD_ROOTS if (ROOT / d).exists()]
old_files = [f for f in OLD_FILES if (ROOT / f).exists()]
old_tools = [f for f in OBSOLETE_TOOLS if (ROOT / "tools" / f).exists()]

print("missing_matrix_files=%d" % len(missing))
print("old_layout_roots=%s" % (",".join(old_roots) if old_roots else "none"))
print("old_matrix_files=%s" % (",".join(old_files) if old_files else "none"))
print("obsolete_tools=%s" % (",".join(old_tools) if old_tools else "none"))
print("gcc_runtime_helper_kcc_cells=%d" % len(gcc_runtime_helper_bad))

for x in missing[:20]:
    print("missing", x)
for test, key, value in gcc_runtime_helper_bad[:20]:
    print("gcc-runtime-helper-kcc-cell", test, key, value)

if missing or old_roots or old_files or old_tools or gcc_runtime_helper_bad:
    sys.exit(1)
