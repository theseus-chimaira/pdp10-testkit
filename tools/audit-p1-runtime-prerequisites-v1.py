#!/usr/bin/env python3
"""Verify historical P1 libc/header/variadic evidence without rerunning cells."""

import csv
import hashlib
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / 'docs/PDP10-DEFERRED-BLOCKER-TRIAGE-20261118-v4.tsv'
OUT = ROOT / 'docs/PDP10-P1-RUNTIME-PREREQUISITES-20261119-v1.tsv'
FIELDS = ('classified_path', 'source_sha256', 'current_path',
          'current_sha256', 'historical_area',
          'evidence_batch', 'kcc_pdp6_result', 'gcc_pdp6_result',
          'source_facilities', 'prerequisite_policy')
TOKENS = {
    'hosted-allocation': r'\b(?:malloc|calloc|realloc|free)\s*\(',
    'hosted-stdio': r'\b(?:printf|sprintf|fprintf|vprintf|vsprintf|puts|putchar)\s*\(',
    'alloca': r'\balloca\s*\(',
    'gnu-builtin': r'\b__builtin_[A-Za-z_0-9]+\s*\(',
    'varargs': r'\b(?:va_arg|va_start|va_end|va_copy)\s*\(|\bvarargs\.h\b',
    'gnu-size-type': r'\b__SIZE_TYPE__\b',
}


def derive(ledger):
    rows = []
    seen = set()
    with (ROOT / 'docs/UPSTREAM-DUPLICATE-CONSOLIDATION-20261118-v21.tsv').open(newline='') as stream:
        aliases = {row['removed_path']: row['canonical_path']
                   for row in csv.DictReader(stream, delimiter='\t')}
    for entry in ledger:
        batch = entry['focused_batch_20261118_v2']
        variadic = entry['focused_batch_varargs_20261118_v4']
        if batch == 'not-probed' and variadic == 'not-probed':
            continue
        path = entry['classified_path']
        if path in seen:
            raise ValueError('duplicate historical identity: ' + path)
        seen.add(path)
        current = aliases.get(path, path)
        source = ROOT / current
        if not source.is_file():
            raise ValueError('missing canonical source: ' + current)
        current_hash = hashlib.sha256(source.read_bytes()).hexdigest()
        # Historical evidence is immutable; a consolidated or later
        # updated canonical source may have a different hash. The emitted
        # manifest pins both identities, and the audit checks both.
        text = source.read_text(encoding='latin1')
        facilities = sorted(key for key, pattern in TOKENS.items()
                            if re.search(pattern, text))
        if variadic != 'not-probed':
            if batch != 'not-probed':
                raise ValueError('ambiguous evidence batch: ' + path)
            statuses = (entry['kcc_pdp6_native_noopt_varargs_20261118_v4'],
                        entry['gcc_pdp6_native_o0_varargs_20261118_v4'])
            evidence = 'varargs-20261118-v4'
        else:
            statuses = (entry['kcc_pdp6_native_noopt_20261118_v2'],
                        entry['gcc_pdp6_native_o0_20261118_v2'])
            evidence = batch + '-20261118-v2'
        if any(status in ('', 'not-probed') for status in statuses):
            raise ValueError('missing focused result: ' + path)
        if 'hosted-allocation' in facilities or 'hosted-stdio' in facilities:
            policy = 'hosted-service-required'
        elif 'alloca' in facilities:
            policy = 'compiler-stack-runtime-review'
        elif ('gnu-builtin' in facilities or
              'gnu-size-type' in facilities):
            policy = 'compiler-feature-review'
        elif evidence.startswith('varargs'):
            policy = 'variadic-abi-review'
        else:
            policy = 'freestanding-or-source-review'
        rows.append(dict(zip(FIELDS, (path, entry['source_sha256'], current,
                      current_hash, entry['blocker_area'], evidence, statuses[0],
                      statuses[1], ','.join(facilities) or 'none', policy))))
    if len(rows) != 53:
        raise ValueError('expected 27 libc/header + 26 variadic sources, got %d' % len(rows))
    return sorted(rows, key=lambda row: row['classified_path'])


def main():
    with LEDGER.open(newline='') as stream:
        rows = derive(csv.DictReader(stream, delimiter='\t'))
    with OUT.open(newline='') as stream:
        stored = list(csv.DictReader(stream, delimiter='\t'))
    if rows != stored:
        print('FAIL: P1 runtime prerequisite manifest is stale', file=sys.stderr)
        return 1
    print('PASS: 53 SHA-pinned historical P1 prerequisites (27 libc/header, 26 varargs)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
