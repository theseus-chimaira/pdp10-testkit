#!/usr/bin/env python3
"""Run frozen P1 Batch 4 deferred sources without pretending they pass.

The original sources are not rewritten.  Each supported C source is run
through the production semantic runner with the real freestanding runtime.
The KL10 assembler fixture is explicitly classified as requiring an ISA
harness, rather than being fed to a C compiler.
"""

import argparse
import csv
import hashlib
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
PLAN = ROOT / 'docs/PDP10-P1-SOURCE-BATCHES-20261120-v13.tsv'
PROBE = ROOT / 'tools/probe-deferred-libc-v1.py'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--outdir', required=True, type=Path)
    parser.add_argument('--compiler', choices=('all', 'gcc', 'kcc'),
                        default='all')
    args = parser.parse_args()
    with PLAN.open(newline='', encoding='utf-8') as stream:
        rows = [row for row in csv.DictReader(stream, delimiter='\t')
                if row['batch'] == '4']
    if len(rows) != 10:
        raise ValueError('frozen Batch 4 must contain exactly ten sources')
    sources = []
    for row in rows:
        source = row['original_source']
        path = ROOT / source
        if (not path.is_file() or
                hashlib.sha256(path.read_bytes()).hexdigest() !=
                row['source_sha256']):
            raise ValueError('source provenance mismatch: ' + source)
        if path.suffix == '.s':
            print('ISA-HARNESS-REQUIRED ' + source, flush=True)
        elif path.suffix == '.c':
            sources.append(source)
        else:
            raise ValueError('unknown source type: ' + source)
    args.outdir.mkdir(parents=True, exist_ok=True)
    command = [sys.executable, str(PROBE), '--compiler', args.compiler,
               '--outdir', str(args.outdir)]
    for source in sources:
        command.extend(('--source', source))
    return subprocess.call(command, cwd=str(ROOT))


if __name__ == '__main__':
    sys.exit(main())
