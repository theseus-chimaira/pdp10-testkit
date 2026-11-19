#!/usr/bin/env python3
"""Verify source-backed 71-bit arithmetic companion for arith-ll.c.

The exact original fifteen operand pairs are preserved. The original
stdio output is purely diagnostic; a new normal-matrix source checks
arithmetic directly, with real KCC/GCC PDP-6 execution evidence.
"""

import csv
import hashlib
from pathlib import Path
import re
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = 'tests/todo/generic/arith-ll.c'
SOURCE = 'tests/semantic/regression/pdp10-wide-arithmetic-operators-v1.c'
HIST = ROOT / 'docs/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
CLASSIFIED = ROOT / 'docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv'
LEDGER = ROOT / 'docs/PDP10-P1-ARITHLL-MATRIX-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-arithll-pdp6-20261119-v1.tar.gz'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
PROFILES = ('kcc-pdp6-opt', 'kcc-pdp6-noopt', 'gcc-pdp6-o0',
            'gcc-pdp6-o1', 'gcc-pdp6-o2', 'gcc-pdp6-os')
FIELDS = ('source', 'source_sha256', 'profile', 'status',
          'evidence_sha256', 'archive_member')


def read(path, comments=False):
    with path.open(encoding='utf-8', newline='') as f:
        return list(csv.DictReader((s for s in f if s.strip() and
                                    (not comments or not s.startswith('#'))),
                                   delimiter='\t'))


def original_oracle():
    failures = []
    historical = {r['classified_path']:r for r in read(HIST)}
    importation = {r['classified_path']:r for r in read(CLASSIFIED)}
    row = historical.get(ORIGINAL)
    if (row is None or row['disposition'] != 'hosted-runtime' or
            importation[ORIGINAL]['activation'] != 'deferred' or
            hashlib.sha256((ROOT / ORIGINAL).read_bytes()).hexdigest() !=
            row['source_sha256']):
        failures.append('original hosted source identity changed')
    text = (ROOT / ORIGINAL).read_text(encoding='ascii')
    reference = re.findall(r'^\s*TEST(Z?)\s*\(\s*(-?\d+)\s*,\s*(-?\d+)\s*\)',
                           text, flags=re.M)
    if len(reference) != 15:
        failures.append('original fifteen operand pairs were not found')
    companion = (ROOT / SOURCE).read_text(encoding='ascii')
    derived = re.findall(
        r'^\s*check_v1\(\s*(-?\d+)LL\s*,\s*(-?\d+)LL\s*,\s*'
        r'(-?\d+)LL\s*,\s*(-?\d+)LL\s*,\s*(-?\d+)LL\s*,\s*'
        r'(-?\d+)LL\s*,\s*(\d+)\);', companion, flags=re.M)
    if len(derived) != 15:
        failures.append('companion must retain fifteen literal comparisons')
    for i, (src, dst) in enumerate(zip(reference, derived), 1):
        zero, first, second = src
        a, b, summed, difference, product, quotient, index = map(int, dst)
        if (int(first) != a or int(second) != b or int(index) != i or
                (b == 0) != bool(zero)):
            failures.append('original operand pair missing: case %d' % i)
        q = 0 if b == 0 else abs(a)//abs(b)*(-1 if (a < 0) != (b < 0) else 1)
        if (summed, difference, product, quotient) != (a+b, a-b, a*b, q):
            failures.append('incorrect independent arithmetic at case %d' % i)
    for source in ('add_v1', 'sub_v1', 'mul_v1', 'div_v1'):
        if companion.count(source+'(') < 2:
            failures.append('missing real operation call '+source)
    if (companion.count('fail_id = id * 8 + ') != 4 or
            companion.count('abort();') != 4 or
            'static volatile wide_v1 lhs_v1' not in companion or
            'static volatile wide_v1 rhs_v1' not in companion):
        failures.append('arithmetic assertion or volatile inputs missing')
    return failures


def audit(ledger=LEDGER, archive=ARCHIVE):
    failures = original_oracle()
    matrix = {r['test']:r for r in read(MATRIX, comments=True)}
    registered = matrix.get(SOURCE)
    if (registered is None or registered.get('pdp6') not in ('fail','semantic') or
            any(registered.get('pdp6_gcc_'+o) != 'semantic'
                for o in ('o0','o1','o2','os'))):
        failures.append('no active original-source-linked normal matrix cells')
    entries = read(ledger)
    if len(entries)!=6 or entries and tuple(entries[0])!=FIELDS:
        failures.append('wrong compiler profile evidence count/schema')
    source_hash = hashlib.sha256((ROOT / SOURCE).read_bytes()).hexdigest()
    seen=set()
    names=set()
    try:
        with tarfile.open(archive, 'r:gz') as tar:
            files={m.name:m for m in tar.getmembers()}
            for record in entries:
                profile=record['profile']
                if profile in seen or profile not in PROFILES:
                    failures.append('duplicate/unknown compiler profile: '+profile)
                    continue
                seen.add(profile)
                member='arithll/%s-v1.log'%profile
                names.add(member)
                item=files.get(member)
                expected='run_fail' if profile.startswith('kcc-') else 'pass'
                if (record['source']!=SOURCE or
                        record['source_sha256']!=source_hash or
                        record['status']!=expected or
                        record['archive_member']!=member or
                        item is None or not item.isfile()):
                    failures.append('compiler/profile provenance mismatch: '+profile)
                    continue
                fd=tar.extractfile(item)
                content=fd.read() if fd else b''
                if (hashlib.sha256(content).hexdigest()!=
                        record['evidence_sha256'] or
                        ('SOURCE: %s\n'%SOURCE).encode('ascii') not in content or
                        ('SHA256: %s\n'%source_hash).encode('ascii') not in content or
                        ('PROFILE: %s\n'%profile).encode('ascii') not in content or
                        ('STATUS: %s\n'%expected).encode('ascii') not in content):
                    failures.append('modified source or guest archive evidence: '+profile)
                if expected=='pass' and not (b'PASS tests_' in content and
                                              b'--expect __test_exit=0' in content):
                    failures.append('missing real PDP-6 GCC PASS: '+profile)
                if expected=='run_fail' and not (
                        b'FAIL: __test_exit:' in content and
                        b'FAIL: fail_id: got 000000000013' in content):
                    failures.append('missing genuine KCC assertion failure: '+profile)
            if set(files)!=names or seen!=set(PROFILES):
                failures.append('incomplete/extra original compiler evidence')
    except (OSError, KeyError, ValueError, tarfile.TarError) as exc:
        failures.append('cannot verify archived original tool output: '+str(exc))
    return failures


def main():
    errors=audit()
    for error in errors:print('ERROR: '+error)
    print('P1 wide arithmetic companion: %s (15 original pairs, 6 cells, %d errors)'%
          ('FAIL' if errors else 'PASS', len(errors)))
    return bool(errors)


if __name__ == '__main__':
    sys.exit(main())
