#!/usr/bin/env python3
"""Bounded source-pinned probes for all 67 unresolved semantic sources.

Compile/link/execute original sources with the existing bare-metal CRT and
real installed freestanding fragments. Failures are recorded, never counted
as PASS. A vacuous success is not promoted without independent assertion
review. This is P1 test construction, not a compiler-fix workflow.
"""

import argparse
import csv
import hashlib
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
DISPOSITION = ROOT / 'docs/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
CLASSIFICATION = ROOT / 'docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv'
PROBER = ROOT / 'tools/probe-deferred-libc-v1.py'
FIELDS = ('source', 'sha256', 'disposition', 'compiler', 'cpu',
          'optimization', 'observed', 'review', 'report')


def tsv(path):
    with path.open(encoding='utf-8', newline='') as f:
        return list(csv.DictReader(f, delimiter='\t'))


def sources():
    rows = tsv(DISPOSITION)
    current = {row['classified_path']: row for row in tsv(CLASSIFICATION)
               if row['activation'] == 'deferred'}
    if len(rows) != 67 or len(current) != 67:
        raise ValueError('expected 67 deferred canonical semantic sources')
    seen = set()
    for row in rows:
        path = row['classified_path']
        src = (ROOT / path).resolve()
        if (path in seen or path not in current or
                not src.is_relative_to(ROOT / 'tests') or
                not src.is_file() or
                hashlib.sha256(src.read_bytes()).hexdigest() != row['source_sha256']):
            raise ValueError('stale/duplicate deferred source: ' + path)
        seen.add(path)
    return rows


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--run', action='store_true')
    ap.add_argument('--compiler', choices=('kcc', 'gcc'), default='gcc')
    ap.add_argument('--disposition', default='all',
                    help='restrict to one recorded disposition class')
    ap.add_argument('--start', type=int, default=1)
    ap.add_argument('--limit', type=int, default=67)
    ap.add_argument('--timeout', type=int, default=65)
    ap.add_argument('--outdir', default=str(Path(os.environ.get('TMPDIR')
                    or (Path.home() / 'tmp')) / 'pdp10-p1-deferred-v1'))
    args = ap.parse_args()
    full = sources()
    rows = [r for r in full if args.disposition in ('all', r['disposition'])]
    if args.start < 1 or args.limit < 1 or args.timeout < 1:
        raise ValueError('invalid bounds')
    rows = rows[args.start-1:args.start-1+args.limit]
    print('P1 deferred selection: %d/67 sources, %s, class=%s' %
          (len(rows), args.compiler, args.disposition), flush=True)
    if not args.run:
        print('P1 deferred source verification: PASS (source hashes verified)')
        return 0
    outdir = Path(args.outdir)
    outdir.mkdir(parents=True, exist_ok=True)
    summary = outdir / 'results-v1.tsv'
    existing = tsv(summary) if summary.exists() else []
    existing_keys = {(r['source'], r['compiler']): r for r in existing}
    for i, row in enumerate(rows, 1):
        path = row['classified_path']
        key = (path, args.compiler)
        # 920428-1.s is a KL10 assembly fixture, not C source.  Feeding
        # it to KCC/GCC -S produces a meaningless compile_fail; it needs
        # an architecture-matched DAS/assembler harness instead.
        assembler = path.endswith('.s')
        if (not assembler and key in existing_keys and
                existing_keys[key]['sha256'] == row['source_sha256']):
            print('%02d/%02d SKIP %s (already measured)' %
                  (i, len(rows), path), flush=True)
            continue
        if assembler:
            observed = 'assembler-harness-required'
            report = ''
            review = 'non-C-KL10-source-not-a-PDP6-compiler-result'
            print('%02d/%02d ASSEMBLER-ONLY %s' %
                  (i, len(rows), path), flush=True)
        else:
            work = outdir / ('source-%03d-%s' % (i, args.compiler))
            cmd = [sys.executable, str(PROBER), '--source', path,
                   '--compiler', args.compiler, '--outdir', str(work)]
            print('%02d/%02d PROBE %s' % (i, len(rows), path), flush=True)
            try:
                result = subprocess.run(cmd, cwd=ROOT, capture_output=True,
                                        text=True, timeout=args.timeout)
                if result.returncode:
                    observed = 'probe-infrastructure-failed'
                    report = str(work / 'probe-output-v1.log')
                else:
                    measured = tsv(work / 'results-v1.tsv')
                    if len(measured) != 1 or measured[0]['source'] != path:
                        raise ValueError('incomplete probe result: ' + path)
                    observed = measured[0]['status']
                    report = measured[0]['report']
                (work / 'probe-output-v1.log').write_text(
                    result.stdout + result.stderr, encoding='utf-8')
            except subprocess.TimeoutExpired as exc:
                observed = 'probe-outer-timeout'
                report = str(work / 'probe-output-v1.log')
                (work / 'probe-output-v1.log').write_text(
                    str(exc), encoding='utf-8')
            if observed == 'pass':
                review = 'assertion-review-required-not-activated'
            else:
                review = 'failure-retained-not-activated'
        entry = {'source': path, 'sha256': row['source_sha256'],
                 'disposition': row['disposition'], 'compiler': args.compiler,
                 'cpu': 'pdp6', 'optimization': '-n' if args.compiler == 'kcc'
                 else '-O0', 'observed': observed, 'review': review,
                 'report': report}
        existing_keys[key] = entry
        with summary.open('w', encoding='utf-8', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=FIELDS, delimiter='\t',
                                    lineterminator='\n')
            writer.writeheader()
            writer.writerows(existing_keys.values())
        print('  RESULT %s (still deferred)' % observed, flush=True)
    print('P1 deferred probe window complete; no automatic activations')
    return 0


if __name__ == '__main__':
    sys.exit(main())
