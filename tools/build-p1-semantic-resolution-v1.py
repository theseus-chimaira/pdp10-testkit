#!/usr/bin/env python3
"""Generate and verify the actionable P1 status of 67 original sources.

Historical import/disposition manifests are read-only snapshots. Original
sources may remain archived as 'deferred' even if meaningful testkit
coverage is complete: the new ledger is authoritative for P1 work.

A completed intent requires a covered companion *in the normal matrix*
and real source/profile-linked guest evidence. Failures remain failures.
No compiler repair is implied by closing a test-construction obligation.
"""

import argparse
import collections
import csv
import hashlib
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
HIST = ROOT / 'manifests/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
CLASS = ROOT / 'manifests/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv'
COVERAGE = ROOT / 'manifests/PDP10-P1-NONASSERTING-COVERAGE-20261119-v1.tsv'
BASELINE = ROOT / 'manifests/PDP10-P1-DEFERRED-PDP6-EVIDENCE-20261119-v1.tsv'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
LEDGER = ROOT / 'manifests/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v1.tsv'
RESULTS = (
    ROOT / 'manifests/PDP10-P1-COMPANION-MATRIX-RESULTS-20261119-v1.tsv',
    ROOT / 'manifests/PDP10-P1-NONASSERTING-COMPANION-RESULTS-20261119-v1.tsv',
    ROOT / 'manifests/PDP10-P1-PREFETCH-WIDE-MATRIX-RESULTS-20261119-v1.tsv',
    ROOT / 'manifests/PDP10-P1-KDEV36-MATRIX-RESULTS-20261119-v1.tsv',
    ROOT / 'manifests/PDP10-P1-DIVMOD-NATIVE-RESULTS-20261119-v1.tsv',
    ROOT / 'manifests/PDP10-P1-BITFIELDS-OPERATIONS-RESULTS-20261119-v1.tsv',
)
FIELDS = ('original_source', 'original_sha256', 'historical_disposition',
          'p1_state', 'compiler_followup', 'evidence_source',
          'gcc_pdp6_baseline', 'kcc_pdp6_baseline',
          'p1_remaining_action')
STATES = ('covered', 'partial', 'blocked')
ACTIVE_STATUSES = frozenset(('semantic', 'run', 'runtime', 'ok',
                             'pending', 'fail', 'error'))


def read(path, comments=False):
    with path.open(encoding='utf-8', newline='') as handle:
        return list(csv.DictReader((line for line in handle if line.strip() and
                                    (not comments or not line.startswith('#'))),
                                   delimiter='\t'))


def authoritative():
    original = read(HIST)
    import_manifest = {row['classified_path']: row for row in read(CLASS)}
    coverage = {row['source']: row for row in read(COVERAGE)}
    baseline = {row['source']: row for row in read(BASELINE)}
    matrix = {row['test']: row for row in read(MATRIX, comments=True)}
    evidence = collections.defaultdict(list)
    for filename in RESULTS:
        for record in read(filename):
            evidence[record['source']].append(record)
    if (len(original) != 67 or len(baseline) != 67 or
            len(coverage) != 14 or len(set(r['classified_path'] for r in
                                           original)) != 67):
        raise ValueError('historical source/coverage inventory changed')
    for row in original:
        name = row['classified_path']
        if (import_manifest[name]['activation'] != 'deferred' or
                hashlib.sha256((ROOT / name).read_bytes()).hexdigest() !=
                row['source_sha256'] or
                baseline[name]['sha256'] != row['source_sha256']):
            raise ValueError('original source/disposition changed: ' + name)
    return original, coverage, baseline, matrix, evidence


def companion_profile_statuses(path, matrix, evidence):
    if path not in matrix or path not in evidence:
        raise ValueError('companion lacks normal matrix/evidence: '+path)
    sha = hashlib.sha256((ROOT / path).read_bytes()).hexdigest()
    statuses = []
    for record in evidence[path]:
        profile = record['profile']
        pieces = profile.split('-')
        if len(pieces) != 3 or pieces[1] != 'pdp6':
            raise ValueError('unrecognized companion machine: '+path+' '+profile)
        column = 'pdp6' if pieces[0] == 'kcc' else 'pdp6_gcc_'+pieces[2]
        if (record['source_sha256'] != sha or
                record['status'] not in ('pass', 'run_fail',
                                         'compile_fail', 'link_fail',
                                         'compiler_ice') or
                matrix[path].get(column) not in ACTIVE_STATUSES):
            raise ValueError('companion source/profile/status mismatch: '+path)
        statuses.append(record['status'])
    if not statuses:
        raise ValueError('no actual compiler observation: '+path)
    return statuses


def resolution_rows():
    original, coverage, baseline, matrix, evidence = authoritative()
    entries = []
    for row in original:
        name = row['classified_path']
        src = baseline[name]
        linked = coverage.get(name)
        state = 'blocked'
        companion = ''
        compiler = 'none'
        action = row['next_action']
        if linked:
            companion = linked['companion']
            statuses = companion_profile_statuses(companion, matrix, evidence)
            state = 'covered' if linked['coverage'] == 'targeted' else 'partial'
            if any(status in ('run_fail', 'compile_fail', 'link_fail',
                              'compiler_ice') for status in statuses):
                # The nested trampoline's optimized modes timed out in
                # SIMH without a readable exit value.  Do not promote a
                # timeout to a proven compiler assertion failure.
                compiler = ('simulator-timeout' if name.endswith(
                    '/921215-1.c') else 'assertion-failure')
            if state == 'covered':
                action = 'None for tested PDP-6 intent; retain original as historical source'
            else:
                action = linked['remaining']
        # A genuine runtime failure outside the normal matrix is not yet
        # an active compiler regression. Keep such originals blocked
        # until they have a source-pinned, owned matrix registration.
        entries.append(dict(original_source=name,
                            original_sha256=row['source_sha256'],
                            historical_disposition=row['disposition'],
                            p1_state=state,
                            compiler_followup=compiler,
                            evidence_source=companion,
                            gcc_pdp6_baseline=src['gcc_status'],
                            kcc_pdp6_baseline=src['kcc_status'],
                            p1_remaining_action=action))
    if collections.Counter(r['p1_state'] for r in entries) != {
            'covered': 8, 'partial': 6, 'blocked': 53}:
        raise ValueError('P1 closure changed without source-specific review')
    return entries


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--write', action='store_true')
    ap.add_argument('--ledger', type=Path, default=LEDGER,
                    help='read another ledger for negative audit controls')
    args = ap.parse_args()
    expected = resolution_rows()
    if args.write:
        if args.ledger != LEDGER:
            raise ValueError('--write requires the canonical versioned ledger')
        with LEDGER.open('w', encoding='utf-8', newline='') as file:
            writer = csv.DictWriter(file, fieldnames=FIELDS,
                                    delimiter='\t', lineterminator='\n')
            writer.writeheader()
            writer.writerows(expected)
    else:
        actual = read(args.ledger)
        if (actual != expected or len(actual) != 67 or
                (actual and tuple(actual[0]) != FIELDS)):
            print('ERROR: actionable semantic resolution ledger is stale, '
                  'unreviewed, or does not match original evidence',
                  file=sys.stderr)
            return 1
    count = collections.Counter(r['p1_state'] for r in expected)
    follow = sum(r['compiler_followup'] == 'assertion-failure'
                 for r in expected)
    timeouts = sum(r['compiler_followup'] == 'simulator-timeout'
                   for r in expected)
    print('P1 semantic resolution: PASS (%d covered, %d partial, '
          '%d blocked, %d companion assertion failures, '
          '%d simulator timeout, '
          '%d historical originals)' %
          (count['covered'],count['partial'],count['blocked'],follow,timeouts,
           len(expected)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
