#!/usr/bin/env python3
"""Static, source-pinned integrity audit for 67 deferred PDP-6 baselines.

Original deferred sources remain deferred even when a compiler exits
successfully.  This audit validates the original source identities,
134 compiler/profile observations and checksum-pinned real logs without
running the compiler or inventing hosted library implementations.
"""

import csv
import hashlib
from pathlib import Path
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
HISTORICAL = ROOT / 'docs/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
CURRENT = ROOT / 'docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv'
RESULTS = ROOT / 'docs/PDP10-P1-DEFERRED-PDP6-EVIDENCE-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-deferred-pdp6-evidence-20261119-v1.tar.gz'
COVERAGE = ROOT / 'docs/PDP10-P1-NONASSERTING-COVERAGE-20261119-v1.tsv'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
COMPANION_RESULTS = (
    ROOT / 'docs/PDP10-P1-COMPANION-MATRIX-RESULTS-20261119-v1.tsv',
    ROOT / 'docs/PDP10-P1-NONASSERTING-COMPANION-RESULTS-20261119-v1.tsv',
    ROOT / 'docs/PDP10-P1-PREFETCH-WIDE-MATRIX-RESULTS-20261119-v1.tsv',
)
FIELDS = ('source', 'sha256', 'disposition', 'gcc_status', 'kcc_status',
          'oracle_review', 'gcc_evidence_sha256',
          'kcc_evidence_sha256', 'next_action')
COVERAGE_FIELDS = ('source', 'source_sha256', 'companion',
                   'coverage', 'remaining')
STATUSES = frozenset(('pass', 'run_fail', 'compile_fail', 'link_fail',
                      'compiler_ice', 'assembler-harness-required'))
ASSEMBLER = 'tests/semantic/upstream/support/920428-1.s'


def read_tsv(path):
    with path.open(encoding='utf-8', newline='') as stream:
        return list(csv.DictReader(stream, delimiter='\t'))


def review_for(row):
    name = row['classified_path']
    if name == ASSEMBLER:
        return 'KL10-assembler-harness-required'
    if name == 'tests/semantic/upstream/extensions/20020108-1.c':
        return 'vacuous-original-width-guard-replaced-by-independent-matrix-oracle'
    if row['disposition'] == 'nonasserting':
        return 'nonasserting-not-eligible-for-activation'
    if row['disposition'] == 'compiler-ice-priority':
        return 'compiler-internal-error-preserved'
    return 'compiler-and-assertion-review-required'


def audit_nonasserting_coverage(original):
    """Ensure every nonasserting source has a real, reviewed matrix case.

    Companion coverage is not an activation of the historical source.
    Some target features require a deliberately partial companion:
    the old 32/32 union-overlay guard, for example, is still unknown.
    """
    errors = []
    cover = read_tsv(COVERAGE)
    originals = {r['classified_path']: r for r in original
                 if r['disposition'] == 'nonasserting'}
    if len(originals) != 14 or len(cover) != 14:
        errors.append('expected fourteen source-specific nonasserting reviews')
    if cover and tuple(cover[0]) != COVERAGE_FIELDS:
        errors.append('wrong nonasserting coverage ledger header')
    by_source = {r['source']: r for r in cover}
    if set(by_source) != set(originals) or len(by_source) != len(cover):
        errors.append('missing, duplicated or extra nonasserting source')
    with MATRIX.open(encoding='ascii') as handle:
        matrix = {r['test']: r for r in csv.DictReader(
            (line for line in handle if not line.startswith('#')),
            delimiter='\t')}
    evidence = {}
    for file in COMPANION_RESULTS:
        for r in read_tsv(file):
            evidence.setdefault(r['source'], set()).add(r['source_sha256'])
    for src, origin in originals.items():
        row = by_source.get(src)
        if row is None:
            continue
        cmpname = row['companion']
        cmpfile = (ROOT / cmpname).resolve()
        item = matrix.get(cmpname)
        if (row['source_sha256'] != origin['source_sha256'] or
                row['coverage'] not in ('targeted', 'partial') or
                not row['remaining'].strip() or
                not cmpfile.is_relative_to(ROOT / 'tests') or
                not cmpfile.is_file() or item is None or
                not any(item.get(col) in ('semantic', 'fail', 'error') for col
                        in ('pdp6', 'pdp6_gcc_o0')) or
                hashlib.sha256(cmpfile.read_bytes()).hexdigest()
                not in evidence.get(cmpname, set())):
            errors.append('invalid/orphaned nonasserting companion: ' + src)
    return errors


def audit(results=RESULTS, archive=ARCHIVE):
    errors = []
    original = read_tsv(HISTORICAL)
    current = read_tsv(CURRENT)
    results_rows = read_tsv(results)
    active = {row['classified_path']: row for row in current
              if row['activation'] == 'deferred'}
    if len(original) != 67 or len(active) != 67 or len(results_rows) != 67:
        errors.append('incorrect count of deferred sources/evidence')
    if results_rows and tuple(results_rows[0]) != FIELDS:
        errors.append('wrong deferred baseline evidence columns')
    if len({r['source'] for r in results_rows}) != len(results_rows):
        errors.append('duplicate deferred evidence source')
    indexed = {row['source']: row for row in results_rows}
    expected_members = set()
    try:
        with tarfile.open(archive, 'r:gz') as tar:
            members = {m.name: m for m in tar.getmembers()}
            if len(members) != 134:
                errors.append('expected 134 original compiler-profile logs')
            for i, row in enumerate(original, 1):
                name = row['classified_path']
                evidence = indexed.get(name)
                if evidence is None:
                    errors.append('missing deferred evidence: ' + name)
                    continue
                source_path = (ROOT / name).resolve()
                if (not source_path.is_relative_to(ROOT / 'tests') or
                        not source_path.is_file()):
                    errors.append('missing deferred source: ' + name)
                    continue
                digest = hashlib.sha256(source_path.read_bytes()).hexdigest()
                if (digest != row['source_sha256'] or
                        digest != evidence['sha256'] or
                        row['disposition'] != evidence['disposition'] or
                        row['next_action'] != evidence['next_action'] or
                        name not in active or
                        active[name]['activation'] != 'deferred' or
                        review_for(row) != evidence['oracle_review']):
                    errors.append('deferred source/provenance mismatch: ' + name)
                for compiler in ('gcc', 'kcc'):
                    status = evidence[compiler + '_status']
                    expected_member = 'source%02d/%s-pdp6-v1.log' % (i, compiler)
                    expected_members.add(expected_member)
                    member = members.get(expected_member)
                    if (status not in STATUSES or
                            (status == 'assembler-harness-required') !=
                            (name == ASSEMBLER) or member is None or
                            not member.isfile()):
                        errors.append('unsupported/missing recorded status: ' +
                                      name + ' ' + compiler)
                        continue
                    stream = tar.extractfile(member)
                    payload = stream.read() if stream else b''
                    if (hashlib.sha256(payload).hexdigest() !=
                            evidence[compiler + '_evidence_sha256'] or
                            ('SOURCE: %s\n' % name).encode('ascii') not in payload or
                            ('SOURCE_SHA256: %s\n' % digest).encode('ascii')
                            not in payload or
                            ('COMPILER: %s\n' % compiler).encode('ascii')
                            not in payload or
                            ('STATUS: %s\n' % status).encode('ascii')
                            not in payload):
                        errors.append('tampered deferred log: ' +
                                      name + ' ' + compiler)
                    # p10run can report success directly in cell.log
                    # without a separate .report.txt for tiny programs.
                    # The logged invocation must still require exit=0.
                    if (status == 'pass' and not (
                            b'result=PASS' in payload or
                            (b'PASS tests_' in payload and
                             b'--expect __test_exit=0' in payload)) or
                            status == 'compiler_ice' and not any(
                                x in payload.lower() for x in
                                (b'internal compiler error', b'[internal error]')) or
                            status == 'link_fail' and not any(
                                x in payload.lower() for x in
                                (b'link failed', b'undefined symbol'))):
                        errors.append('log does not prove result: ' +
                                      name + ' ' + compiler)
            if expected_members != set(members):
                errors.append('missing/extra archived deferred observations')
    except (OSError, KeyError, tarfile.TarError, ValueError) as ex:
        errors.append('cannot inspect deferred baseline archive: ' + str(ex))
    errors.extend(audit_nonasserting_coverage(original))
    return errors


def main():
    errors = audit()
    for problem in errors:
        print('ERROR: ' + problem)
    print('P1 deferred baseline: %s (67 sources, 134 observations, %d problems)' %
          ('FAIL' if errors else 'PASS', len(errors)))
    return bool(errors)


if __name__ == '__main__':
    sys.exit(main())
