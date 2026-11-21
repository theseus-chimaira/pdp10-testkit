#!/usr/bin/env python3
"""Audit independently derived signed 52/53-bit XOR/OR test results.

The original 991118-1.c and bf64-1.c remain deferred; this companion
preserves the intended bitwise operation, pad and struct-return checks,
without assuming the original host's 64-bit sign-extension masks.
"""

import csv
import hashlib
from pathlib import Path
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = 'tests/semantic/regression/pdp10-signed-bitfields-operations-v1.c'
ORIGINALS = ('tests/todo/generic/991118-1.c',
             'tests/todo/generic/bf64-1.c')
LEDGER = ROOT / 'manifests/PDP10-P1-BITFIELDS-OPERATIONS-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-bitfields-operations-20261119-v1.tar.gz'
DEFERRED = ROOT / 'manifests/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
CLASSIFIED = ROOT / 'manifests/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
FIELDS = ('source', 'source_sha256', 'profile', 'status',
          'evidence_sha256', 'archive_member')
PROFILES = ('gcc-pdp6-o0','gcc-pdp6-o1','gcc-pdp6-o2','gcc-pdp6-os')
CASES = (
    (52,0x123456789ABCD,0x0008765412345678,'xor',-1876791358784075),
    (53,0x1FFFF00000000,0x0018765412345678,'xor',-1818956999141768),
    (52,0xFFF000FFF000F,0x0008765412345678,'or',-738197547393),
)


def read_tsv(path,comments=False):
    with path.open(encoding='utf-8',newline='') as f:
        return list(csv.DictReader((line for line in f if line.strip() and
                                    (not comments or not line.startswith('#'))),
                                   delimiter='\t'))


def reference_errors():
    errors=[]
    src=(ROOT / SOURCE).read_text(encoding='ascii')
    for bits,a,b,operation,expected in CASES:
        n = (a ^ b) if operation=='xor' else (a | b)
        n &= (1<<bits)-1
        if n & (1<<(bits-1)):
            n -= 1<<bits
        if n!=expected:
            errors.append('independent sign extension mismatch for %d/%s'%
                          (bits,operation))
        if ('0x%XLL'%a).upper() not in src.upper() or (
                '0x%016XLL'%b).upper() not in src.upper() or (
                str(expected)+'LL') not in src:
            errors.append('original operation inputs/outputs not in fixture')
    for name in ('field52_first_v1','field52_last_v1',
                 'field53_first_v1','field53_last_v1'):
        if name not in src:
            errors.append('missing signed field order: '+name)
    for name in ('xor52_first_v1','xor52_last_v1','xor53_first_v1',
                 'xor53_last_v1','or52_first_v1','or52_last_v1'):
        if ('= '+name+'(') not in src or ('\n'+name+'(') not in src:
            errors.append('structure return/call missing: '+name)
    if src.count('fail_id = ') != 6 or src.count('abort();') != 6:
        errors.append('original six field+pad assertion checkpoints changed')
    deferred={r['classified_path']:r for r in read_tsv(DEFERRED)}
    classified={r['classified_path']:r for r in read_tsv(CLASSIFIED)}
    for name in ORIGINALS:
        if (name not in deferred or
                deferred[name]['disposition']!='width-or-source-adaptation' or
                classified[name]['activation']!='deferred' or
                hashlib.sha256((ROOT / name).read_bytes()).hexdigest()!=
                deferred[name]['source_sha256']):
            errors.append('historical signed field source/disposition changed: '+name)
    return errors


def audit(ledger=LEDGER,archive=ARCHIVE):
    problems=reference_errors()
    rows=read_tsv(ledger)
    if len(rows)!=4 or rows and tuple(rows[0])!=FIELDS:
        problems.append('incorrect field-operation profile ledger count')
    matrix={r['test']:r for r in read_tsv(MATRIX,comments=True)}
    registration=matrix.get(SOURCE)
    if (registration is None or registration.get('pdp6')!='unsupported' or
            any(registration.get('pdp6_gcc_'+o) not in ('fail','semantic')
                for o in ('o0','o1','o2','os'))):
        problems.append('missing normal compiler matrix registration')
    digest=hashlib.sha256((ROOT / SOURCE).read_bytes()).hexdigest()
    seen=set();filenames=set()
    try:
        with tarfile.open(archive,'r:gz') as t:
            files={item.name:item for item in t.getmembers()}
            for row in rows:
                profile=row['profile']
                if profile in seen or profile not in PROFILES:
                    problems.append('duplicate/unknown GCC profile: '+profile)
                    continue
                seen.add(profile)
                filename='bitfields/%s-v1.log'%profile
                filenames.add(filename)
                item=files.get(filename)
                if (row['source']!=SOURCE or row['source_sha256']!=digest or
                        row['status']!='run_fail' or
                        row['archive_member']!=filename or
                        item is None or not item.isfile()):
                    problems.append('source/profile/evidence mismatch: '+profile)
                    continue
                f=t.extractfile(item)
                data=f.read() if f else b''
                if (hashlib.sha256(data).hexdigest()!=
                        row['evidence_sha256'] or
                        ('SOURCE: %s\n'%SOURCE).encode('ascii') not in data or
                        ('SHA256: %s\n'%digest).encode('ascii') not in data or
                        ('PROFILE: %s\n'%profile).encode('ascii') not in data or
                        b'STATUS: run_fail\n' not in data):
                    problems.append('tampered original compiler log: '+profile)
                if not (b'FAIL: __test_exit:' in data and
                        b'FAIL: fail_id: got 000000000001' in data):
                    problems.append('first field assertion not reproduced: '+profile)
            if seen!=set(PROFILES) or filenames!=set(files):
                problems.append('missing/extra signed bitfield execution record')
    except (OSError,ValueError,KeyError,tarfile.TarError) as ex:
        problems.append('could not inspect evidence archive: '+str(ex))
    return problems


def main():
    problems=audit()
    for problem in problems:
        print('ERROR: '+problem)
    print('P1 signed 52/53 field operation oracle: %s (3 reference cases, 4 GCC cells, %d errors)'%
          ('FAIL' if problems else 'PASS',len(problems)))
    return bool(problems)


if __name__=='__main__':
    sys.exit(main())
