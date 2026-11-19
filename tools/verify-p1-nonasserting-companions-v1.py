#!/usr/bin/env python3
"""Integrity check for four original-upstream nonasserting companions.

The eighteen PDP-6 outcomes cover four GCC profiles per source and
two KCC profiles for the packed union. Runtime failure
and timeouts must never be accepted as compiler passes.
"""

import csv
import hashlib
from pathlib import Path
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / 'docs/PDP10-P1-NONASSERTING-COMPANION-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-nonasserting-companions-20261119-v1.tar.gz'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
NAMES = ('pdp10-bitfield-array-writeback-v1',
         'pdp10-nested-trampoline-call-v1',
         'pdp10-packed-union-identifier-v1',
         'pdp10-nested-label-indirect-goto-v1')
FIELDS = ('source', 'source_sha256', 'profile', 'status',
          'evidence_sha256', 'archive_member')
OPT = ('o0', 'o1', 'o2', 'os')


def tsv(path):
    with path.open(encoding='ascii', newline='') as file:
        return list(csv.DictReader((line for line in file
                                    if line.strip() and
                                    not line.startswith('#')),
                                   delimiter='\t'))


def audit(results=RESULTS, archive=ARCHIVE):
    problems = []
    rows = tsv(results)
    matrix = {r['test']: r for r in tsv(MATRIX)}
    expected = {}
    for i, name in enumerate(NAMES, 1):
        source = 'tests/semantic/regression/' + name + '.c'
        for opt in OPT:
            profile = 'gcc-pdp6-' + opt
            outcome = ('pass' if i == 4 or (i == 2 and opt == 'o0')
                       else 'run_fail')
            expected[(source, profile)] = (i, outcome, 'pdp6_gcc_'+opt)
        if i == 3:
            for opt in ('opt', 'noopt'):
                expected[(source, 'kcc-pdp6-'+opt)] = (i, 'pass', 'pdp6')
    if len(rows) != 18 or rows and tuple(rows[0]) != FIELDS:
        problems.append('wrong companion result count/columns')
    seen = set()
    members_expected = set()
    try:
        with tarfile.open(archive, 'r:gz') as files:
            members = {member.name: member for member in files.getmembers()}
            for row in rows:
                key = (row['source'], row['profile'])
                if key not in expected or key in seen:
                    problems.append('unexpected/duplicate compiler cell: '+str(key))
                    continue
                seen.add(key)
                i, outcome, column = expected[key]
                src = ROOT / row['source']
                checksum = hashlib.sha256(src.read_bytes()).hexdigest()
                selected = matrix.get(row['source'])
                if (row['source_sha256'] != checksum or
                        row['status'] != outcome or selected is None or
                        selected.get(column) not in
                        ('semantic', 'fail')):
                    problems.append('source/profile/result mismatch: '+str(key))
                member_name = 'test%02d/%s-v1.log' % (i, row['profile'])
                members_expected.add(member_name)
                file = members.get(member_name)
                if (row['archive_member'] != member_name or file is None or
                        not file.isfile()):
                    problems.append('missing original cell log: '+str(key))
                    continue
                handle = files.extractfile(file)
                content = handle.read() if handle else b''
                if (hashlib.sha256(content).hexdigest() !=
                        row['evidence_sha256'] or
                        ('SOURCE: %s\n' % row['source']).encode('ascii')
                        not in content or
                        ('SHA256: %s\n' % checksum).encode('ascii')
                        not in content or
                        ('PROFILE: %s\n' % row['profile']).encode('ascii')
                        not in content or
                        ('STATUS: %s\n' % outcome).encode('ascii')
                        not in content):
                    problems.append('archive content mismatch: '+str(key))
                if outcome == 'pass' and not (
                        b'PASS tests_' in content and
                        b'--expect __test_exit=0' in content):
                    problems.append('missing actual guest PASS: '+str(key))
                if outcome == 'run_fail':
                    if i == 2:
                        confirmed = (b'FAIL: SIMH exited with status 124' in
                                     content and b'no readable examine output'
                                     in content)
                    else:
                        confirmed = (b'FAIL: __test_exit:' in content and
                                     b'FAIL: fail_id:' in content)
                    if not confirmed:
                        problems.append('missing original guest failure: '+
                                        str(key))
            if set(members) != members_expected or seen != set(expected):
                problems.append('missing/extra profile evidence')
    except (OSError, KeyError, ValueError, tarfile.TarError) as exc:
        problems.append('cannot inspect evidence: '+str(exc))
    return problems


def main():
    failures = audit()
    for line in failures:
        print('ERROR: '+line)
    print('P1 nonasserting companions: %s (18 cells, %d problems)' %
          ('FAIL' if failures else 'PASS', len(failures)))
    return bool(failures)


if __name__ == '__main__':
    sys.exit(main())
