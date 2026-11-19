#!/usr/bin/env python3
"""Verify independent prefetch and 71-bit arithmetic PDP-6 regressions.

The original five upstream GNU prefetch cases and the original 960416-1.c
stay deferred. These executable companions have independent assertions.
This tool audits matrix ownership, host-calculated arithmetic values,
recorded compiler results, and archived original tool output.
"""

import csv
import hashlib
from pathlib import Path
import re
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / 'docs/PDP10-P1-PREFETCH-WIDE-MATRIX-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-prefetch-wide-pdp6-20261119-v1.tar.gz'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
CLASSIFICATION = ROOT / 'docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv'
PREFETCH = 'tests/semantic/regression/pdp10-prefetch-address-effects-v1.c'
WIDE = 'tests/semantic/regression/pdp10-wide-multiply-36bit-v1.c'
FIELDS = ('source', 'source_sha256', 'compiler', 'profile', 'status',
          'evidence_sha256', 'archive_member')
ORIGINALS = tuple('tests/semantic/upstream/extensions/builtin-prefetch-%d.c'
                  % n for n in (1, 2, 3, 5, 6)) + (
    'tests/todo/generic/960416-1.c',)
WIDE_VALUES = (
    (0o12345670123, 0o23456701234),
    (0o23456701234, 0o23456701234),
    (0o12345670123, 0o12345670123),
    (0o12345670123, 1),
    (0, 0o23456701234),
)


def read_tsv(path):
    with path.open(encoding='utf-8', newline='') as f:
        return list(csv.DictReader((s for s in f if s.strip() and
                                    not s.startswith('#')), delimiter='\t'))


def reference_errors():
    errors = []
    text = (ROOT / WIDE).read_text(encoding='ascii')
    # Match each literal constant in the actual executed test, then
    # compute its reference using unbounded host arithmetic (not target
    # long-long or target union ABI).  A source-only/table mismatch fails.
    pattern = (r'check_v1\(\s*(0[0-7]+UL|[0-9]+UL),\s*'
               r'(0[0-7]+UL|[0-9]+UL),\s*'
               r'([0-9]+ULL),\s*([0-9]+UL),\s*([0-9]+UL),\s*'
               r'([0-9]+)\s*\);')
    values = re.findall(pattern, text)
    if len(values) != 5:
        return ['wide-integer source no longer has five explicit cases']
    for i, row in enumerate(values):
        def parse(s):
            s = s.rstrip('UL')
            return int(s, 8 if s.startswith('0') and len(s) > 1 else 10)
        a, b, product, high, low, number = [parse(s) for s in row]
        if ((a, b) != WIDE_VALUES[i] or
                product != a*b or high != (a*b) >> 36 or
                low != (a*b) & ((1 << 36)-1) or
                number != i+1 or a >= 1 << 35 or b >= 1 << 35 or
                product >= 1 << 71):
            errors.append('wide-integer independent reference mismatch: %d' % (i+1))
    prefetch = (ROOT / PREFETCH).read_text(encoding='ascii')
    # A no-prefetch PDP-6 can erase the actual instruction, but is
    # still required to evaluate each volatile/side-effecting address.
    required = ('__builtin_prefetch', 'next_v1++', 'address_v1(6)',
                'shared_v1', '&bytes_v1[1]', '&bytes_v1[3]',
                '(void *)0', 'fail_id = 1;', 'fail_id = 2;',
                'fail_id = 3;', 'fail_id = 4;', 'fail_id = 5;')
    for value in required:
        if value not in prefetch:
            errors.append('missing meaningful prefetch oracle: '+value)
    current = {row['classified_path']: row for row in read_tsv(CLASSIFICATION)}
    for path in ORIGINALS:
        if path not in current or current[path]['activation'] != 'deferred':
            errors.append('original historical source unexpectedly activated: '+path)
    return errors


def audit(ledger=LEDGER, archive=ARCHIVE):
    problems = reference_errors()
    rows = read_tsv(ledger)
    matrix = {row['test']: row for row in read_tsv(MATRIX)}
    expected = {}
    for i, source in enumerate((PREFETCH, WIDE), 1):
        for comp, opts in (('gcc', ('o0', 'o1', 'o2', 'os')),
                           ('kcc', ('opt', 'noopt'))):
            if i == 1 and comp == 'kcc':
                continue
            for opt in opts:
                profile = comp + '-pdp6-' + opt
                status = 'pass' if i == 1 or comp == 'kcc' else 'run_fail'
                column = 'pdp6' if comp == 'kcc' else 'pdp6_gcc_'+opt
                expected[(source, profile)] = (i, comp, status, column)
    if len(rows) != 10 or rows and tuple(rows[0]) != FIELDS:
        problems.append('P1 prefetch/wide result count or header changed')
    seen = set()
    archive_seen = set()
    try:
        with tarfile.open(archive, 'r:gz') as tar:
            files = {item.name:item for item in tar.getmembers()}
            for row in rows:
                key = row['source'], row['profile']
                if key in seen or key not in expected:
                    problems.append('unknown or duplicate execution cell: '+str(key))
                    continue
                seen.add(key)
                index, compiler, status, column = expected[key]
                digest = hashlib.sha256((ROOT / row['source']).read_bytes()).hexdigest()
                registration = matrix.get(row['source'])
                if (row['source_sha256'] != digest or
                        row['compiler'] != compiler or
                        row['status'] != status or
                        registration is None or registration.get(column) not in
                        ('semantic','pending','fail','error')):
                    problems.append('test identity, profile or observation changed: '+str(key))
                member = 'test%02d/%s-v1.log' % (index,row['profile'])
                archive_seen.add(member)
                item = files.get(member)
                if row['archive_member'] != member or item is None or not item.isfile():
                    problems.append('missing genuine test output: '+str(key))
                    continue
                stream = tar.extractfile(item)
                payload = stream.read() if stream else b''
                if (hashlib.sha256(payload).hexdigest() !=
                        row['evidence_sha256'] or
                        ('SOURCE: %s\n' % row['source']).encode('ascii') not in payload or
                        ('SHA256: %s\n' % digest).encode('ascii') not in payload or
                        ('PROFILE: %s\n' % row['profile']).encode('ascii') not in payload or
                        ('STATUS: %s\n' % status).encode('ascii') not in payload):
                    problems.append('modified/corrupt test log: '+str(key))
                if status == 'pass':
                    if not (b'PASS tests_' in payload and
                            b'--expect __test_exit=0' in payload):
                        problems.append('no confirmed real guest PASS: '+str(key))
                else:
                    if not (b'FAIL: __test_exit:' in payload and
                            b'FAIL: fail_id:' in payload):
                        problems.append('missing recorded assertion failure: '+str(key))
            if archive_seen != set(files) or seen != set(expected):
                problems.append('incomplete or extra archived profile evidence')
    except (OSError, ValueError, KeyError, tarfile.TarError) as exc:
        problems.append('cannot inspect prefetch/wide evidence: '+str(exc))
    return problems


def main():
    failures = audit()
    for item in failures:
        print('ERROR: '+item)
    print('P1 prefetch/wide test construction: %s (10 cells, %d errors)' %
          ('FAIL' if failures else 'PASS',len(failures)))
    return bool(failures)


if __name__ == '__main__':
    sys.exit(main())
