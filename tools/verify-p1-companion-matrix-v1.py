#!/usr/bin/env python3
"""Validate the 26 source-pinned PDP-6 companion semantic test results.

Historical vacuous sources stay untouched; independently authored,
assertion-bearing C companions run in COMPILER_MATRIX.tsv. The archived
PDP-6 cell evidence is immutable and no compiler failure is accepted.
"""

import csv
import hashlib
from pathlib import Path
import re
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / 'manifests/PDP10-P1-COMPANION-MATRIX-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-companions-pdp6-20261119-v1.tar.gz'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
FIELDS = ('source', 'source_sha256', 'compiler', 'profile', 'status',
          'evidence_sha256', 'archive_member')
NAMES = (
    'pdp10-loop-sum-readback-v1',
    'pdp10-aligned-typedef-v1',
    'pdp10-packed-field-readback-v1',
    'pdp10-packed-pointer-array-v1',
    'pdp10-signed-bitfields-52-53-v1',
)


def read_tsv(path):
    with path.open(encoding='utf-8', newline='') as f:
        return list(csv.DictReader((line for line in f
                                    if line.strip() and
                                    not line.startswith('#')),
                                   delimiter='\t'))


def audit(results=RESULTS, archive=ARCHIVE):
    problems = []
    rows = read_tsv(results)
    matrix = {r['test']: r for r in read_tsv(MATRIX)}
    expected = {}
    for n, name in enumerate(NAMES, 1):
        source = 'tests/semantic/regression/' + name + '.c'
        for compiler, opts in (
                ('kcc', ('opt', 'noopt')),
                ('gcc', ('o0', 'o1', 'o2', 'os'))):
            if (compiler == 'kcc' and name in
                    ('pdp10-aligned-typedef-v1',
                     'pdp10-signed-bitfields-52-53-v1')):
                continue
            for opt in opts:
                profile = compiler + '-pdp6-' + opt
                expect = ('pass' if compiler == 'kcc' or
                          name in ('pdp10-loop-sum-readback-v1',
                                   'pdp10-aligned-typedef-v1') else
                          'run_fail')
                expected[(source, profile)] = (n, compiler, expect)
    if len(expected) != 26 or len(rows) != 26:
        problems.append('expected exactly 26 source/profile results')
    if rows and tuple(rows[0]) != FIELDS:
        problems.append('companion evidence columns changed')
    seen = set()
    names_seen = set()
    try:
        with tarfile.open(archive, 'r:gz') as tar:
            files = {m.name: m for m in tar.getmembers()}
            for row in rows:
                key = (row['source'], row['profile'])
                if key not in expected or key in seen:
                    problems.append('unknown/duplicate companion cell: ' + str(key))
                    continue
                seen.add(key)
                n, compiler, status = expected[key]
                source = ROOT / row['source']
                current = hashlib.sha256(source.read_bytes()).hexdigest()
                matrix_row = matrix.get(row['source'])
                col = ('pdp6' if compiler == 'kcc' else
                       'pdp6_gcc_' + row['profile'].rsplit('-', 1)[-1])
                if (row['source_sha256'] != current or
                        row['compiler'] != compiler or
                        row['status'] != status or
                        matrix_row is None or
                        matrix_row.get(col) not in
                        ('semantic', 'pending', 'fail', 'error')):
                    problems.append('source, profile or result changed: ' +
                                    str(key))
                member = 'test%02d/%s-v1.log' % (n, row['profile'])
                names_seen.add(member)
                item = files.get(member)
                if (row['archive_member'] != member or
                        item is None or not item.isfile()):
                    problems.append('missing companion log: ' + str(key))
                    continue
                stream = tar.extractfile(item)
                payload = stream.read() if stream else b''
                if (hashlib.sha256(payload).hexdigest() !=
                        row['evidence_sha256'] or
                        ('SOURCE: %s\n' % row['source']).encode('ascii')
                        not in payload or
                        ('SHA256: %s\n' % current).encode('ascii')
                        not in payload or
                        ('PROFILE: %s\n' % row['profile']).encode('ascii')
                        not in payload or
                        ('STATUS: %s\n' % status).encode('ascii')
                        not in payload):
                    problems.append('tampered companion log: ' + str(key))
                if status == 'pass':
                    if not (b'PASS tests_' in payload and
                            b'--expect __test_exit=0' in payload):
                        problems.append('missing actual successful guest: ' +
                                        str(key))
                else:
                    if not (b'FAIL: __test_exit:' in payload and
                            re.search(rb'FAIL: fail_id: got 0*[1-7]\b',
                                      payload)):
                        problems.append('missing real failing checkpoint: ' +
                                        str(key))
            if seen != set(expected) or names_seen != set(files):
                problems.append('incomplete/extra companion results')
    except (OSError, ValueError, KeyError, tarfile.TarError) as exc:
        problems.append('could not verify companion archive: ' + str(exc))
    return problems


def main():
    problems = audit()
    for item in problems:
        print('ERROR: ' + item)
    print('P1 companion matrix: %s (26 PDP6 cells, %d problems)' %
          ('FAIL' if problems else 'PASS', len(problems)))
    return bool(problems)


if __name__ == '__main__':
    sys.exit(main())
