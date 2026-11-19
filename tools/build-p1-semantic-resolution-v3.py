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
HIST = ROOT / 'docs/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
CLASS = ROOT / 'docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv'
COVERAGE = ROOT / 'docs/PDP10-P1-NONASSERTING-COVERAGE-20261119-v1.tsv'
BASELINE = ROOT / 'docs/PDP10-P1-DEFERRED-PDP6-EVIDENCE-20261119-v1.tsv'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
LEDGER = ROOT / 'docs/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v3.tsv'
RESULTS = (
    ROOT / 'docs/PDP10-P1-COMPANION-MATRIX-RESULTS-20261119-v1.tsv',
    ROOT / 'docs/PDP10-P1-NONASSERTING-COMPANION-RESULTS-20261119-v1.tsv',
    ROOT / 'docs/PDP10-P1-PREFETCH-WIDE-MATRIX-RESULTS-20261119-v1.tsv',
    ROOT / 'docs/PDP10-P1-KDEV36-MATRIX-RESULTS-20261119-v1.tsv',
    ROOT / 'docs/PDP10-P1-DIVMOD-NATIVE-RESULTS-20261119-v1.tsv',
    ROOT / 'docs/PDP10-P1-BITFIELDS-OPERATIONS-RESULTS-20261119-v1.tsv',
    ROOT / 'docs/PDP10-P1-ARITHLL-MATRIX-RESULTS-20261119-v1.tsv',
    ROOT / 'docs/PDP10-P1-ALIGN32-RESULTS-20261119-v1.tsv',
    ROOT / 'docs/PDP10-P1-BATCH1-ADMISSION-RESULTS-20261119-v1.tsv',
)
COVERED_COMPANION_INTENTS = {
    'tests/todo/generic/arith-ll.c':
        'tests/semantic/regression/pdp10-wide-arithmetic-operators-v1.c',
    'tests/semantic/upstream/extensions/20010904-1.c':
        'tests/semantic/regression/pdp10-aligned32-array-strides-v1.c',
    'tests/semantic/upstream/extensions/20010904-2.c':
        'tests/semantic/regression/pdp10-aligned32-array-strides-v1.c',
    'tests/todo/generic/20010924-1.c':
        'tests/semantic/regression/pdp10-flexible-string-initializers-v1.c;'
        'tests/semantic/regression/pdp10-fixed-string-initializer-baselines-v1.c',
    'tests/semantic/upstream/extensions/20020227-1.c':
        'tests/semantic/regression/pdp10-packed-unaligned-complex-v1.c',
    'tests/semantic/upstream/extensions/20020411-1.c':
        'tests/semantic/regression/pdp10-complex-conjugate-array-v1.c',
}

# A genuine target policy question, a timeout, or missing runtime/library
# support cannot be closed merely because a diagnostic was reproduced.
PARTIAL_COMPANION_ACTIONS = {
    'tests/todo/generic/20000914-1.c': (
        'tests/semantic/regression/pdp10-enum-code-bitfield-switch-v1.c',
        'Determine target signedness/range policy for enum code:8 '
        'and AMBIG_CONV=222; KCC and GCC currently disagree'),
    'tests/todo/generic/920302-1.c': (
        'tests/semantic/regression/pdp10-label-offset-dispatch-v1.c',
        'Diagnose GNU label-offset computed goto: all four GCC '
        'profiles time out before returning any guest assertion'),
    'tests/todo/generic/920501-2.c': (
        'tests/semantic/regression/pdp10-wide-powmod-gcd-v1.c',
        'Provide real KCC __kcc_umoddi3 library support and complete '
        'the original factor-search oracle; GCC powmod assertion fails'),
    'tests/todo/generic/920501-6.c': (
        'tests/semantic/regression/pdp10-wide-isqrt-prime-v1.c',
        'Test original billion-scale primes: KCC noopt exhausts '
        'steps, KCC opt fails integer sqrt, GCC O0-O2 fail decimal '
        'conversion; GCC Os passes bounded checks'),
}

FIELDS = ('original_source', 'original_sha256', 'historical_disposition',
          'p1_state', 'compiler_followup', 'evidence_source',
          'gcc_pdp6_baseline', 'kcc_pdp6_baseline',
          'p1_remaining_action')
STATES = ('covered', 'partial', 'blocked')
ACTIVE_STATUSES = frozenset(('semantic', 'run', 'runtime', 'ok',
                             'pending', 'fail', 'error', 'timeout'))


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
        if (linked or name in COVERED_COMPANION_INTENTS or
                name in PARTIAL_COMPANION_ACTIONS):
            companion = (linked['companion'] if linked else
                         COVERED_COMPANION_INTENTS[name] if name in
                         COVERED_COMPANION_INTENTS else
                         PARTIAL_COMPANION_ACTIONS[name][0])
            statuses = []
            for source in companion.split(';'):
                statuses.extend(companion_profile_statuses(
                    source, matrix, evidence))
            state = ('partial' if (linked and
                     linked['coverage'] == 'partial') or
                     name in PARTIAL_COMPANION_ACTIONS else 'covered')
            if any(status in ('run_fail', 'compile_fail', 'link_fail',
                              'compiler_ice') for status in statuses):
                # The nested trampoline's optimized modes timed out in
                # SIMH without a readable exit value.  Do not promote a
                # timeout to a proven compiler assertion failure.
                compiler = ('simulator-timeout' if name.endswith(
                    '/921215-1.c') else 'assertion-failure')
            if name.endswith('/20000914-1.c'):
                compiler = 'target-policy-review'
            elif name.endswith('/920302-1.c'):
                compiler = 'simulator-timeout'
            if state == 'covered':
                action = 'None for tested PDP-6 intent; retain original as historical source'
            elif linked:
                action = linked['remaining']
            else:
                action = PARTIAL_COMPANION_ACTIONS[name][1]
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
            'covered': 14, 'partial': 10, 'blocked': 43}:
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
