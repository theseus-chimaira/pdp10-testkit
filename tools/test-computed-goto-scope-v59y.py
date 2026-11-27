#!/usr/bin/env python3
"""Check historical flat-address exclusion and native computed-goto coverage."""
import collections
import csv
import hashlib
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('runner', ROOT / 'tools/run-tests.py')
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
OLD = 'tests/todo/generic/comp-goto-1.c'
NATIVE = 'tests/semantic/regression/pdp10-heap-computed-goto-v59x.c'
BLT = 'tests/semantic/regression/gcc-blt-memory-effects-v59y.c'
DIGEST = 'c874cfc465c32b0361a952505b4a11fcb605441e3ee8ae5da785324ef32c8bae'


def validate(rows):
    selected, _, missing, _ = runner.build_cells(rows, runner.all_profiles(), 'semantic')
    assert not missing, missing
    counts = collections.Counter((name, cell['compiler']) for name, cell in selected)
    assert counts[OLD, 'gcc'] == counts[OLD, 'kcc'] == 0
    assert counts[NATIVE, 'gcc'] == 44
    assert counts[NATIVE, 'kcc'] == 22
    assert counts[BLT, 'gcc'] == 44
    assert counts[BLT, 'kcc'] == 0


def main():
    assert hashlib.sha256((ROOT / OLD).read_bytes()).hexdigest() == DIGEST
    with (ROOT / 'COMPILER_MATRIX.tsv').open(newline='') as f:
        rows = [r for r in csv.DictReader((l for l in f if not l.startswith('#')),
                delimiter='\t') if r['test'] in {OLD, NATIVE, BLT}]
    assert len(rows) == 3
    validate(rows)
    for name, field, status in (
        (OLD, 'pdp6', 'pending'),
        (OLD, 'pdp6_gcc_o2', 'pending'),
        (NATIVE, 'pdp6', 'unsupported'),
        (NATIVE, 'pdp6_gcc_o2', 'unsupported'),
    ):
        bad = [dict(r) for r in rows]
        next(r for r in bad if r['test'] == name)[field] = status
        try:
            validate(bad)
        except AssertionError:
            continue
        raise AssertionError('invalid scope accepted: ' + name + ' ' + field)
    print('PASS: frozen computed-goto scope, native coverage, four rejection controls')


if __name__ == '__main__':
    main()
