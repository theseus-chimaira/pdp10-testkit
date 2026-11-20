#!/usr/bin/env python3
"""Summarize observed deferred batch probes without promoting test states."""

import argparse
import collections
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / 'docs/PDP10-P1-SOURCE-BATCHES-20261120-v7.tsv'


def read(path):
    with path.open(newline='', encoding='utf-8') as stream:
        return list(csv.DictReader(stream, delimiter='\t'))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--batch', type=int, choices=(4, 5, 6), required=True)
    parser.add_argument('--results', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    plan = [r for r in read(PLAN) if r['batch'] == str(args.batch)]
    results = read(args.results)
    expected = {(r['original_source'], compiler) for r in plan
                if r['original_source'].endswith('.c')
                for compiler in ('gcc', 'kcc')}
    observed = {(r['source'], r['compiler']) for r in results}
    if observed != expected or len(results) != len(expected):
        raise ValueError('missing, duplicate or unexpected compiler cells')
    by_source = {(r['source'], r['compiler']): r['status'] for r in results}
    counts = collections.Counter(r['status'] for r in results)
    with args.output.open('w', encoding='utf-8') as stream:
        stream.write('# P1 Batch %d deferred probe results v1\n\n' % args.batch)
        stream.write('Original sources are unchanged. Results are real '
                     'PDP-6 native KCC noopt and GCC O0 observations, '
                     'not semantic acceptance or compiler fixes.\n\n')
        stream.write('Observed cells: %d. ' % len(results))
        stream.write(', '.join('%s: %d' % (key, counts[key])
                               for key in sorted(counts)))
        stream.write('.\n\n| Original source | KCC | GCC |\n'
                     '| --- | --- | --- |\n')
        for row in plan:
            source = row['original_source']
            if source.endswith('.s'):
                kcc = gcc = 'ISA harness required'
            else:
                kcc = by_source[(source, 'kcc')]
                gcc = by_source[(source, 'gcc')]
            stream.write('| `%s` | %s | %s |\n' % (source, kcc, gcc))
        stream.write('\nPASS indicates the runner returned success, '
                     'not that an independent nonvacuous oracle was proven. '
                     'Failures remain unresolved; no fake stubs or '
                     'assertion changes were introduced.\n')


if __name__ == '__main__':
    main()
