#!/usr/bin/env python3
"""Run frozen deferred P1 batches with original source hash validation.

Only actual semantic runner outcomes are reported.  An assembler source is
classified as requiring its ISA harness, never passed to a C compiler.
"""

import argparse
import csv
from pathlib import Path
import subprocess
import sys

from p1_source_replacement_v1 import (
    current_path_for, source_matches_historical,
)

ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / 'manifests/PDP10-P1-SOURCE-BATCHES-20261120-v13.tsv'
PROBE = ROOT / 'tools/probe-deferred-libc-v1.py'
EXPECTED = {4: 10, 5: 10, 6: 9}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--batch', type=int, choices=(4, 5, 6), required=True)
    parser.add_argument('--outdir', required=True, type=Path)
    parser.add_argument('--compiler', choices=('all', 'gcc', 'kcc'),
                        default='all')
    parser.add_argument('--start', type=int, default=1)
    parser.add_argument('--limit', type=int, default=10)
    args = parser.parse_args()
    if args.start < 1 or args.limit < 1:
        parser.error('start and limit must be positive')
    with PLAN.open(newline='', encoding='utf-8') as stream:
        rows = [row for row in csv.DictReader(stream, delimiter='\t')
                if row['batch'] == str(args.batch)]
    if len(rows) != EXPECTED[args.batch]:
        raise ValueError('frozen batch size mismatch')
    for row in rows:
        source = row['original_source']
        if not source_matches_historical(source, row['source_sha256']):
            raise ValueError('source provenance mismatch: ' + source)
    selected = rows[args.start - 1:args.start - 1 + args.limit]
    sources = []
    for row in selected:
        source = current_path_for(row['original_source'])
        if source.endswith('.s'):
            print('ISA-HARNESS-REQUIRED ' + source, flush=True)
        elif source.endswith('.c'):
            sources.append(source)
        else:
            raise ValueError('unknown source type: ' + source)
    if not sources:
        return 0
    args.outdir.mkdir(parents=True, exist_ok=True)
    command = [sys.executable, str(PROBE), '--compiler', args.compiler,
               '--outdir', str(args.outdir)]
    for source in sources:
        command.extend(('--source', source))
    return subprocess.call(command, cwd=str(ROOT))


if __name__ == '__main__':
    sys.exit(main())
