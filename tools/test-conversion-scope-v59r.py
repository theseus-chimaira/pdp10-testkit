#!/usr/bin/env python3
"""Check compiler-specific admission of the frozen conversion fixtures."""
import collections
import csv
import hashlib
import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('runner', ROOT / 'tools/run-tests.py')
runner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)

PREFIX = 'tests/semantic/regression/'
STAGES = {
    PREFIX + 'pdp10-conversion-gnu71-stages-v1.c':
        '7b6f6484e7a3e108f95ab637971fe8bf46e9c92ed13c9d2034f53abd79c3e4a7',
    PREFIX + 'pdp10-conversion-gnu71-fixstage-v1.c':
        '6bcc4c3da8da7d973fe56c9c8adfd1ca6c62f9d0ff07e3fab2b8a58ceea5a9d4',
}
RAW = PREFIX + 'pdp10-libgcc-di-float-abi-v1.c'
NATIVE = PREFIX + 'kcc-wide-cast-oracle-v59r.c'


def validate(rows):
    selected, _, missing, _ = runner.build_cells(rows, runner.all_profiles(), 'semantic')
    assert not missing, missing
    counts = collections.Counter((name, cell['compiler']) for name, cell in selected)
    for name in STAGES:
        assert counts[name, 'kcc'] == 0, name
        assert counts[name, 'gcc'] >= 16, name
    # Do not lose genuine cross-compiler raw ABI tests or native casts.
    assert counts[RAW, 'kcc'] >= 12
    assert counts[RAW, 'gcc'] >= 16
    assert counts[NATIVE, 'kcc'] == 22


def main():
    with (ROOT / 'COMPILER_MATRIX.tsv').open(newline='') as f:
        rows = [r for r in csv.DictReader((l for l in f if not l.startswith('#')),
                delimiter='\t') if r['test'] in set(STAGES) | {RAW, NATIVE}]
    for name, expected in STAGES.items():
        assert hashlib.sha256((ROOT / name).read_bytes()).hexdigest() == expected
    original = ROOT / 'tests/semantic/upstream/pdp10/pdp10/conversion.c'
    assert hashlib.sha256(original.read_bytes()).hexdigest() == (
        '2736912e40e1dabd84f7f193ddaaf5ddf9bf00e76edb0cca0611b3f49e5c1beb')
    validate(rows)
    for name in STAGES:
        bad = [dict(r) for r in rows]
        next(r for r in bad if r['test'] == name)['ka10'] = 'pending'
        try:
            validate(bad)
        except AssertionError:
            continue
        raise AssertionError('invalid KCC wrapper admission accepted: ' + name)
    print('PASS conversion fixture scope, frozen hashes and two rejection controls')


if __name__ == '__main__':
    main()
