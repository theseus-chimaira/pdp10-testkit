#!/usr/bin/env python3
"""Fail-closed final APR-snapshot classification regression."""
import importlib.util
from pathlib import Path

file = Path(__file__).resolve().parents[2] / 'tools/aap-execution-class-v1.py'
spec = importlib.util.spec_from_file_location('aap_exec_class', file)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
clean = 'APR_CLASS_V1 NXM=0 ILLOP=0 PDLOV=0 PI_ACTIVE=0 PI_REQ=000 PI_CYC=0'
assert module.classify(clean) == 'final-snapshot-clear'
for variant in (clean.replace('NXM=0', 'NXM=1'),
                clean.replace('ILLOP=0', 'ILLOP=1'),
                clean.replace('PDLOV=0', 'PDLOV=1'),
                clean.replace('PI_ACTIVE=0', 'PI_ACTIVE=1'),
                clean.replace('PI_REQ=000', 'PI_REQ=001'),
                clean.replace('PI_CYC=0', 'PI_CYC=1'),
                clean + '\n' + clean, '', clean.replace('NXM=0', 'NXM=2')):
    try:
        module.classify(variant)
    except ValueError:
        pass
    else:
        raise AssertionError('unsafe APR final snapshot accepted: ' + repr(variant))
print('AAP fail-closed final-snapshot classification v1: PASS (10 cases)')
