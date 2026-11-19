#!/usr/bin/env python3
"""Fail-closed FP hardware-oracle construction inventory, not emulation.

Only the original DEC Type 166 case 9 has an independently reconstructed
physical expectation. Other entries must remain unverified until independent
hardware evidence is attached; emulator agreement is not hardware evidence.
"""

import argparse
import csv
import importlib.util
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
MATHEMATICAL_C = ROOT / 'tests/semantic/kcc-pdp6-rounded-fp-boundaries-v2.c'
HARDWARE_C = ROOT / 'tests/semantic/kcc-pdp6-fp-hardware-case9-v1.c'
CASE9_MODEL = ROOT / 'misc/validation/analyze-aap-pdp6-emnf-case9-v1.py'
REGISTRY = ROOT / 'docs/PDP10-FP-HARDWARE-ORACLES-20261119-v1.tsv'
CPUS = ('pdp6', 'ka10', 'ki10', 'ks10', 'kl10')
CASE = re.compile(r'^\s*\{\s*([-+]?\d+\.\d+F),\s*'
                  r'([-+]?\d+\.\d+F),\s*(0[0-7]+)UL,\s*([01])\s*\},?\s*$',
                  re.M)
FIELDS = ('cpu', 'case_index', 'lhs', 'rhs', 'operation',
          'mathematical_expected_octal', 'hardware_expected_octal',
          'hardware_status', 'hardware_evidence')


def original_cases():
    matches = CASE.findall(MATHEMATICAL_C.read_text(encoding='ascii'))
    if len(matches) != 24:
        raise ValueError('original PDP6 24-case source was modified')
    return matches


def case9_expected():
    spec = importlib.util.spec_from_file_location('pdp6_emnf_case9_v1',
                                                  CASE9_MODEL)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    got, checkpoints = mod.model()
    if got != 0o544000000003 or len(checkpoints) != 11:
        raise ValueError('independent DEC EMNF model changed')
    if '0544000000003UL' not in HARDWARE_C.read_text(encoding='ascii'):
        raise ValueError('hardware case9 compiled oracle changed')
    return '%012o' % got


def rows():
    original = original_cases()
    physical_case9 = case9_expected()
    for cpu in CPUS:
        for i, (lhs, rhs, mathematics, subtract) in enumerate(original, 1):
            verified = cpu == 'pdp6' and i == 9
            yield {'cpu': cpu, 'case_index': str(i), 'lhs': lhs,
                   'rhs': rhs, 'operation': 'sub' if subtract == '1' else 'add',
                   'mathematical_expected_octal': mathematics,
                   'hardware_expected_octal': physical_case9 if verified else '',
                   'hardware_status': 'independent-dec-verified' if verified
                   else 'hardware-evidence-required',
                   'hardware_evidence': ('DEC Type166 FDAS/EMNF model and '
                   'original AAP pulse trace; PDP6 case9' if verified else
                   'not yet independently established')}


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--write', action='store_true')
    args = ap.parse_args()
    expected = list(rows())
    if args.write:
        with REGISTRY.open('w', encoding='ascii', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=FIELDS, delimiter='\t',
                                    lineterminator='\n')
            writer.writeheader()
            writer.writerows(expected)
        print('Wrote 120 independently scoped FP oracle slots')
        return 0
    with REGISTRY.open(encoding='ascii', newline='') as f:
        reader = csv.DictReader(f, delimiter='\t')
        actual = list(reader)
        if tuple(reader.fieldnames) != FIELDS or actual != expected:
            print('P1 FP oracle registry changed without new evidence',
                  file=sys.stderr)
            return 1
    print('P1 FP oracle inventory: PASS (120 CPU/case slots; 1 DEC verified, '
          '119 require hardware evidence)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
