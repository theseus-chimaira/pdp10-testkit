#!/usr/bin/env python3
"""Ensure registered standalone exact-form AAP tests count in static inventory."""
from pathlib import Path
import importlib.util
root=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('coverage',root/'tools/aap-kernel-coverage-v1.py')
coverage=importlib.util.module_from_spec(spec)
spec.loader.exec_module(coverage)
registered={line.split('\t')[3] for line in (root/'SPECIAL_TESTS.tsv').read_text().splitlines() if len(line.split('\t'))>=4}
tested=coverage.verified_family_names()
for filename, families in coverage.GENERATED_EVIDENCE.items():
    if filename.startswith('test-aap-') and filename not in ('test-aap-batch100-v4.py','test-aap-batch100-v5.py','test-aap-batch100-v6.py','test-aap-batch100-v7.py','test-aap-batch100-v8.py','test-aap-batch100-v10.py'):
        if 'misc/compat/'+filename in registered:
            assert families <= tested,(filename,families-tested)
assert 'tlz' in tested
print('AAP exact-form registry attribution v1: PASS')
