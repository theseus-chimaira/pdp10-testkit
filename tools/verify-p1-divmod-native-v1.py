#!/usr/bin/env python3
"""Validate 9/18/36-bit division/remainder P1 companion and six real runs.

Original arith-rand.c remains deferred. No signed MIN/-1 overflow or
zero divisor is admitted as a valid mathematical comparison.
"""

import csv
import hashlib
from pathlib import Path
import re
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = 'tests/semantic/regression/pdp10-divmod-native-widths-v1.c'
ORIGINAL = 'tests/todo/generic/arith-rand.c'
LEDGER = ROOT / 'docs/PDP10-P1-DIVMOD-NATIVE-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-divmod-native-20261119-v1.tar.gz'
DEFERRED = ROOT / 'docs/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
CLASSIFIED = ROOT / 'docs/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
FIELDS = ('source', 'source_sha256', 'profile', 'status',
          'evidence_sha256', 'archive_member')
PROFILES = ('kcc-pdp6-opt', 'kcc-pdp6-noopt', 'gcc-pdp6-o0',
            'gcc-pdp6-o1', 'gcc-pdp6-o2', 'gcc-pdp6-os')


def tsv(path, comments=False):
    with path.open(encoding='utf-8', newline='') as f:
        return list(csv.DictReader((line for line in f if line.strip() and
                                    (not comments or not line.startswith('#'))),
                                   delimiter='\t'))


def numeric_reference():
    errors = []
    text = (ROOT / SOURCE).read_text(encoding='ascii')
    pairs = re.findall(r'check_(sc|ss|si|uc|us|ui)_v1\('\
                       r'\s*([-0-9]+)(?:UL|L)?,\s*'\
                       r'([-0-9]+)(?:UL|L)?,\s*'\
                       r'([-0-9]+)(?:UL|L)?,\s*'\
                       r'([-0-9]+)(?:UL|L)?,\s*'\
                       r'([0-9]+)\);',text)
    if len(pairs)!=36:
        errors.append('expected exactly 36 explicit mathematical checks')
    expected_order = ('sc','ss','si','uc','us','ui')
    counts = dict((name,0) for name in expected_order)
    widths = {'sc':9,'ss':18,'si':36,'uc':9,'us':18,'ui':36}
    for i,case in enumerate(pairs,1):
        name=case[0]
        a,b,q,r,number=map(int,case[1:])
        counts[name]+=1
        bits=widths[name]
        if name != expected_order[(i-1)//6] or number!=i or b==0:
            errors.append('incorrect case identity/zero divisor at %d'%i)
            continue
        signed=name[0]=='s'
        hi=(1<<(bits-1))-1 if signed else (1<<bits)-1
        lo=-(1<<(bits-1)) if signed else 0
        if not (lo<=a<=hi and lo<=b<=hi) or signed and a==lo and b==-1:
            errors.append('out of range/undefined signed division at %d'%i)
            continue
        qref=abs(a)//abs(b)
        if (a<0)!=(b<0):qref=-qref
        rref=a-qref*b
        if q!=qref or r!=rref or not(lo<=q<=hi and lo<=r<=hi):
            errors.append('incorrect independent division oracle at %d'%i)
    if any(count!=6 for count in counts.values()):
        errors.append('incorrect coverage by target 9/18/36-bit type')
    for decl in ('volatile signed char sc_lhs_v1',
                 'volatile unsigned char uc_lhs_v1',
                 'volatile signed short ss_lhs_v1',
                 'volatile unsigned short us_lhs_v1',
                 'volatile signed int si_lhs_v1',
                 'volatile unsigned int ui_lhs_v1'):
        if decl not in text:
            errors.append('missing volatile operands: '+decl)
    return errors


def audit(ledger=LEDGER,archive=ARCHIVE):
    issues=numeric_reference()
    source_sha=hashlib.sha256((ROOT / SOURCE).read_bytes()).hexdigest()
    deferred={r['classified_path']:r for r in tsv(DEFERRED)}
    classified={r['classified_path']:r for r in tsv(CLASSIFIED)}
    if (ORIGINAL not in deferred or deferred[ORIGINAL]['disposition'] !=
            'width-or-source-adaptation' or
            hashlib.sha256((ROOT / ORIGINAL).read_bytes()).hexdigest()!=
            deferred[ORIGINAL]['source_sha256'] or
            classified[ORIGINAL]['activation']!='deferred'):
        issues.append('original random arithmetic semantics/source changed')
    matrix={r['test']:r for r in tsv(MATRIX,comments=True)}
    m=matrix.get(SOURCE)
    if m is None or m.get('pdp6')!='semantic' or any(
            m.get('pdp6_gcc_'+opt) not in ('semantic','fail')
            for opt in ('o0','o1','o2','os')):
        issues.append('normal compiler matrix does not schedule 6 PDP6 cells')
    observed=tsv(ledger)
    if len(observed)!=6 or observed and tuple(observed[0])!=FIELDS:
        issues.append('wrong division evidence profile count/schema')
    seen=set()
    names=set()
    try:
        with tarfile.open(archive,'r:gz') as tar:
            files={x.name:x for x in tar.getmembers()}
            for row in observed:
                profile=row['profile']
                if profile not in PROFILES or profile in seen:
                    issues.append('unexpected/duplicate profile: '+profile)
                    continue
                seen.add(profile)
                name='divmod/%s-v1.log'%profile
                names.add(name)
                expect='pass' if profile.startswith('kcc') else 'run_fail'
                item=files.get(name)
                if (row['source']!=SOURCE or row['source_sha256']!=source_sha or
                        row['status']!=expect or row['archive_member']!=name or
                        item is None or not item.isfile()):
                    issues.append('source or recorded outcome mismatch: '+profile)
                    continue
                handle=tar.extractfile(item)
                data=handle.read() if handle else b''
                if (hashlib.sha256(data).hexdigest()!=
                        row['evidence_sha256'] or
                        ('SOURCE: %s\n'%SOURCE).encode('ascii') not in data or
                        ('SHA256: %s\n'%source_sha).encode('ascii') not in data or
                        ('PROFILE: %s\n'%profile).encode('ascii') not in data or
                        ('STATUS: %s\n'%expect).encode('ascii') not in data):
                    issues.append('tampered original compiler/guest log: '+profile)
                if expect=='pass' and not (b'PASS tests_' in data and
                                            b'--expect __test_exit=0' in data):
                    issues.append('missing real guest pass: '+profile)
                if expect=='run_fail' and not (b'FAIL: __test_exit:' in data and
                                                b'FAIL: fail_id:' in data):
                    issues.append('missing real failed arithmetic assertion: '+profile)
            if seen!=set(PROFILES) or names!=set(files):
                issues.append('incomplete/extra archived arithmetic profiles')
    except (OSError,KeyError,ValueError,tarfile.TarError) as e:
        issues.append('cannot audit original compiler evidence: '+str(e))
    return issues


def main():
    errors=audit()
    for msg in errors:print('ERROR: '+msg)
    print('P1 9/18/36-bit division reference: %s (36 checks, 6 cells, %d issues)'%
          ('FAIL' if errors else 'PASS',len(errors)))
    return bool(errors)


if __name__=='__main__':sys.exit(main())
