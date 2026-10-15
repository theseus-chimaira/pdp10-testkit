#!/usr/bin/env python3
"""Ensure broad timing gate cannot silently pass while work remains."""
import importlib.util
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parents[2]
tool = root / 'tools/check-aap-broad-coverage-v1.py'
spec = importlib.util.spec_from_file_location('coverage_gate_v1', tool)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
items = module.rows()
assert len(items) >= 15
assert any(x['status'] == 'incomplete' and x['mandatory'] == 'yes' for x in items)
assert subprocess.run([sys.executable, str(tool)], capture_output=True).returncode == 0
assert subprocess.run([sys.executable, str(tool), '--require-broad'],
                      capture_output=True).returncode == 1
print('AAP broad timing coverage gate v1: PASS (unfinished work rejected)')
