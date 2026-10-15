#!/usr/bin/env python3
"""Validate instruction regression gates and safe weighted comparison."""
import json
import pathlib
import subprocess
import sys
import tempfile


def run(*args):
    return subprocess.run([sys.executable, *args], stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE, text=True).returncode


def main(compare):
    with tempfile.TemporaryDirectory() as d:
        root = pathlib.Path(d)
        a, b = root / 'baseline.json', root / 'candidate.json'
        sample = {'schema': 'pdp6-opcode-profile-v1', 'instruction_count': 1000,
                  'weight_file': None, 'unweighted_dispatches': 1000,
                  'partial_weighted_cost': None}
        a.write_text(json.dumps(sample))
        sample['instruction_count'] = 1010
        b.write_text(json.dumps(sample))
        assert run(compare, str(a), str(b)) == 1
        assert run(compare, str(a), str(b), '--max-regression-pct', '1') == 0
        assert run(compare, str(a), str(b), '--metric', 'weighted') != 0
    print('pdp6 profile comparison v1: PASS')


if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('usage: test-pdp6-profile-comparison-v1.py COMPARATOR')
    main(sys.argv[1])
