#!/usr/bin/env python3
"""Audit 32-char array-stride regressions for both 20010904 layouts."""

import csv
import hashlib
from pathlib import Path
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = 'tests/semantic/regression/pdp10-aligned32-array-strides-v1.c'
ORIGINALS = ('tests/semantic/upstream/extensions/20010904-1.c',
             'tests/semantic/upstream/extensions/20010904-2.c')
HIST = ROOT / 'docs/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
CLASSIFIED = ROOT / 'docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
LEDGER = ROOT / 'docs/PDP10-P1-ALIGN32-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-align32-pdp6-20261119-v1.tar.gz'
FIELDS = ('source', 'source_sha256', 'profile', 'status',
          'evidence_sha256', 'archive_member')
PROFILES = ('gcc-pdp6-o0', 'gcc-pdp6-o1', 'gcc-pdp6-o2', 'gcc-pdp6-os')


def read_tsv(path, comments=False):
    with path.open(encoding='utf-8', newline='') as file:
        return list(csv.DictReader((line for line in file
                                    if line.strip() and
                                    (not comments or not line.startswith('#'))),
                                   delimiter='\t'))


def audit(ledger=LEDGER, archive=ARCHIVE):
    errors=[]
    history={row['classified_path']: row for row in read_tsv(HIST)}
    classified={row['classified_path']: row for row in read_tsv(CLASSIFIED)}
    for path in ORIGINALS:
        r=history.get(path)
        if (r is None or r['disposition']!='compiler-investigate' or
                classified[path]['activation']!='deferred' or
                hashlib.sha256((ROOT/path).read_bytes()).hexdigest()!=
                r['source_sha256']):
            errors.append('original source/assertion identity changed: '+path)
        text=(ROOT/path).read_text(encoding='ascii')
        if ('__pdp10__' not in text or 'aligned(32)' not in text or
                '&y[1] - (char *)&y[0]' not in text):
            errors.append('missing original guarded alignment requirement: '+path)
    companion=(ROOT/SOURCE).read_text(encoding='ascii')
    required=('aligned(32)', 'sizeof(aligned_v1) % 32U',
              'first_stride_v1 % 32U', 'second_stride_v1 % 32U',
              'offsetof(first_v1, values)', 'offsetof(second_v1, first)',
              'offsetof(second_v1, rest)',
              '(char *)&first_objects_v1[1]',
              '(char *)&second_objects_v1[1]',
              'fail_id = 3;', 'abort();')
    for fragment in required:
        if fragment not in companion:
            errors.append('missing independent array stride assertion: '+fragment)
    matrix={r['test']:r for r in read_tsv(MATRIX,comments=True)}
    row=matrix.get(SOURCE)
    if (row is None or row.get('pdp6')!='unsupported' or
            any(row.get('pdp6_gcc_'+o) not in ('fail','semantic')
                for o in ('o0','o1','o2','os'))):
        errors.append('active GCC matrix registration incomplete')
    ledger_rows=read_tsv(ledger)
    if len(ledger_rows)!=4 or ledger_rows and tuple(ledger_rows[0])!=FIELDS:
        errors.append('incorrect 4-cell recorded evidence schema')
    digest=hashlib.sha256((ROOT/SOURCE).read_bytes()).hexdigest()
    seen=set();members_seen=set()
    try:
        with tarfile.open(archive,'r:gz') as t:
            members={m.name:m for m in t.getmembers()}
            for result in ledger_rows:
                profile=result['profile']
                if profile not in PROFILES or profile in seen:
                    errors.append('unknown/duplicate profile: '+profile)
                    continue
                seen.add(profile)
                member='align32/%s-v1.log'%profile
                members_seen.add(member)
                entry=members.get(member)
                if (result['source']!=SOURCE or
                        result['source_sha256']!=digest or
                        result['status']!='run_fail' or
                        result['archive_member']!=member or
                        entry is None or not entry.isfile()):
                    errors.append('source/profile evidence invalid: '+profile)
                    continue
                file=t.extractfile(entry)
                payload=file.read() if file else b''
                if (hashlib.sha256(payload).hexdigest()!=
                        result['evidence_sha256'] or
                        ('SOURCE: %s\n'%SOURCE).encode('ascii') not in payload or
                        ('SHA256: %s\n'%digest).encode('ascii') not in payload or
                        ('PROFILE: %s\n'%profile).encode('ascii') not in payload or
                        b'STATUS: run_fail\n' not in payload or
                        b'FAIL: __test_exit:' not in payload or
                        b'FAIL: fail_id: got 000000000003' not in payload):
                    errors.append('tampered/missing assertion failure: '+profile)
            if seen!=set(PROFILES) or members_seen!=set(members):
                errors.append('missing/extra array-stride execution evidence')
    except (OSError,ValueError,KeyError,tarfile.TarError) as exc:
        errors.append('cannot inspect original logs: '+str(exc))
    return errors


def main():
    errors=audit()
    for error in errors:print('ERROR: '+error)
    print('P1 aligned32 twin-source oracle: %s (4 GCC cells, %d errors)'%
          ('FAIL' if errors else 'PASS',len(errors)))
    return bool(errors)


if __name__ == '__main__':
    sys.exit(main())
