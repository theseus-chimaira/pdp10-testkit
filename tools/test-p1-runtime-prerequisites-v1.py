#!/usr/bin/env python3
"""Host-only fail-closed checks for the frozen P1 prerequisite ledger."""

import csv
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    'p1_runtime_audit_v1', ROOT / 'tools/audit-p1-runtime-prerequisites-v1.py')
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


def main():
    with MODULE.LEDGER.open(newline='') as stream:
        originals = list(csv.DictReader(stream, delimiter='\t'))
    baseline = MODULE.derive(originals)
    assert len(baseline) == 53
    assert sum(row['classified_path'] != row['current_path']
               for row in baseline) == 12
    assert sum(row['source_sha256'] != row['current_sha256']
               for row in baseline) == 2
    changed = [dict(row) for row in originals]
    target = next(row for row in changed if row['focused_batch_20261118_v2'] != 'not-probed')
    target['kcc_pdp6_native_noopt_20261118_v2'] = 'not-probed'
    try:
        MODULE.derive(changed)
    except ValueError:
        pass
    else:
        raise AssertionError('missing historical outcome accepted')
    changed = [dict(row) for row in originals]
    target = next(row for row in changed if row['focused_batch_varargs_20261118_v4'] != 'not-probed')
    target['focused_batch_20261118_v2'] = 'libc'
    try:
        MODULE.derive(changed)
    except ValueError:
        pass
    else:
        raise AssertionError('ambiguous batch accepted')
    assert MODULE.main() == 0
    print('PASS: P1 prerequisite policy (53 sources, 2 negative controls)')


if __name__ == '__main__':
    main()
