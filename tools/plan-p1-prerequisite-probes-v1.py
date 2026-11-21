#!/usr/bin/env python3
"""Produce a bounded, SHA-verified P1 prerequisite probe plan; never execute."""

import argparse
import csv
import hashlib
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / 'manifests/PDP10-P1-RUNTIME-PREREQUISITES-20261119-v1.tsv'
POLICIES = ('hosted-service-required', 'compiler-stack-runtime-review',
            'compiler-feature-review', 'variadic-abi-review',
            'freestanding-or-source-review')


def select(rows, policy, limit):
    """Fail closed on stale sources, duplicate identities and invalid bounds."""
    if policy not in POLICIES or not 1 <= limit <= 10:
        raise ValueError('policy or limit outside approved bounded probe plan')
    seen = {}
    selected = []
    for row in rows:
        path = row['current_path']
        if path in seen:
            previous = seen[path]
            # Historical duplicate identities may legitimately resolve to
            # one canonical file. Probe it once, but reject conflicting
            # canonical hashes or prerequisite policies.
            if (previous['current_sha256'] != row['current_sha256'] or
                    previous['prerequisite_policy'] != row['prerequisite_policy']):
                raise ValueError('conflicting canonical aliases: ' + path)
        else:
            seen[path] = row
        if row['prerequisite_policy'] not in POLICIES:
            raise ValueError('unknown prerequisite policy: ' + path)
        source = (ROOT / path).resolve()
        if not source.is_relative_to(ROOT / 'tests') or not source.is_file():
            raise ValueError('source outside test tree or missing: ' + path)
        if hashlib.sha256(source.read_bytes()).hexdigest() != row['current_sha256']:
            raise ValueError('source hash changed: ' + path)
        if (seen[path] is row and row['prerequisite_policy'] == policy
                and len(selected) < limit):
            selected.append(row)
    return selected


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--policy', required=True, choices=POLICIES)
    ap.add_argument('--limit', type=int, default=5)
    args = ap.parse_args(argv)
    with MANIFEST.open(newline='') as stream:
        rows = list(csv.DictReader(stream, delimiter='\t'))
    chosen = select(rows, args.policy, args.limit)
    print('source\tpolicy\tkcc_historical\tgcc_historical')
    for row in chosen:
        print('%s\t%s\t%s\t%s' % (
            row['current_path'], row['prerequisite_policy'],
            row['kcc_pdp6_result'], row['gcc_pdp6_result']))
    return 0


if __name__ == '__main__':
    sys.exit(main())
