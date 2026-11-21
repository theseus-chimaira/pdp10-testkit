#!/usr/bin/env python3
"""Audit target-width Linux kdev_t oracle against independent 36-bit math.

The original GCC 980526-2.c remains deferred: its 32-bit expected
constant and signed shift are not PDP-10 oracle values. The new normal
compiler-matrix source uses unsigned 36-bit arithmetic and independent
host-computed results, with full real guest execution provenance.
"""

import csv
import hashlib
from pathlib import Path
import re
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = 'tests/todo/generic/980526-2.c'
SOURCE = 'tests/semantic/regression/pdp10-kdev-36bit-encoding-v1.c'
DEFERRED = ROOT / 'manifests/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
CURRENT = ROOT / 'manifests/SEMANTIC-UPSTREAM-CLASSIFICATION-20261118-v25.tsv'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
LEDGER = ROOT / 'manifests/PDP10-P1-KDEV36-MATRIX-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-kdev36-pdp6-20261119-v1.tar.gz'
FIELDS = ('source', 'source_sha256', 'profile', 'status',
          'evidence_sha256', 'archive_member')
INPUTS = (0, 1, 255, 256, 65535, 0x12345678, 0xffffffff,
          0xabcdef00, 0x80000000, 0x3fffffff)


def rows(path, comments=False):
    with path.open(encoding='utf-8', newline='') as f:
        return list(csv.DictReader((line for line in f if line.strip() and
                                    (not comments or not line.startswith('#'))),
                                   delimiter='\t'))


def audit(ledger=LEDGER, archive=ARCHIVE):
    errors = []
    original = {r['classified_path']:r for r in rows(DEFERRED)}
    classification = {r['classified_path']:r for r in rows(CURRENT)}
    if (ORIGINAL not in original or
            original[ORIGINAL]['disposition'] != 'width-or-source-adaptation' or
            hashlib.sha256((ROOT / ORIGINAL).read_bytes()).hexdigest() !=
            original[ORIGINAL]['source_sha256'] or
            classification[ORIGINAL]['activation'] != 'deferred'):
        errors.append('original Linux 32-bit source identity/disposition changed')

    source = (ROOT / SOURCE).read_text(encoding='ascii')
    matches = re.findall(r'check_v1\(0x([0-9a-f]+)U,\s*'
                         r'0x([0-9a-f]+)U,\s*(\d+)\);',source)
    if len(matches) != 10:
        errors.append('missing native-width 36-bit source expectations')
    for index, case in enumerate(matches):
        dev, expected, number = (int(case[0],16), int(case[1],16),
                                 int(case[2]))
        result = (((dev >> 8) << 22) | (dev & 255)) & ((1 << 36) - 1)
        if dev != INPUTS[index] or expected != result or number != index+1:
            errors.append('independent unsigned 36-bit oracle changed at %d' %
                          (index+1))
    if ('major = device >> 8;' not in source or
            'minor = device & 0377U;' not in source or
            '(major << 22) | minor' not in source or
            'device_v1 = device;' not in source):
        errors.append('native-width encoding operation no longer exercised')
    digest = hashlib.sha256((ROOT / SOURCE).read_bytes()).hexdigest()
    matrix = {r['test']:r for r in rows(MATRIX,comments=True)}
    r = matrix.get(SOURCE)
    if (r is None or r.get('pdp6') != 'semantic' or
            any(r.get('pdp6_gcc_'+opt) != 'semantic'
                for opt in ('o0','o1','o2','os'))):
        errors.append('six normal compiler matrix profiles not registered')

    observed = rows(ledger)
    profiles = ('kcc-pdp6-opt', 'kcc-pdp6-noopt', 'gcc-pdp6-o0',
                'gcc-pdp6-o1', 'gcc-pdp6-o2', 'gcc-pdp6-os')
    if (len(observed)!=6 or observed and tuple(observed[0])!=FIELDS):
        errors.append('wrong profile result ledger')
    seen=set()
    names=set()
    try:
        with tarfile.open(archive,'r:gz') as tar:
            files={m.name:m for m in tar.getmembers()}
            for row in observed:
                profile=row['profile']
                if profile not in profiles or profile in seen:
                    errors.append('unexpected/duplicate profile: '+profile)
                    continue
                seen.add(profile)
                name='kdev36/%s-v1.log'%profile
                names.add(name)
                item=files.get(name)
                if (row['source'] != SOURCE or
                        row['source_sha256'] != digest or
                        row['status'] != 'pass' or
                        row['archive_member'] != name or
                        item is None or not item.isfile()):
                    errors.append('bad profile identity or archive: '+profile)
                    continue
                stream=tar.extractfile(item)
                content=stream.read() if stream else b''
                if (hashlib.sha256(content).hexdigest() !=
                        row['evidence_sha256'] or
                        ('SOURCE: %s\n'%SOURCE).encode('ascii') not in content or
                        ('SHA256: %s\n'%digest).encode('ascii') not in content or
                        ('PROFILE: %s\n'%profile).encode('ascii') not in content or
                        b'STATUS: pass\n' not in content or
                        b'--expect __test_exit=0' not in content or
                        b'PASS tests_' not in content):
                    errors.append('missing real guest success/evidence: '+profile)
            if seen!=set(profiles) or names!=set(files):
                errors.append('missing/extra native 36-bit execution evidence')
    except (OSError,KeyError,ValueError,tarfile.TarError) as exc:
        errors.append('unable to verify kdev evidence: '+str(exc))
    return errors


def main():
    problems=audit()
    for issue in problems:
        print('ERROR: '+issue)
    print('P1 kdev native-width oracle: %s (10 cases, 6 PDP6 profiles, %d problems)'%
          ('FAIL' if problems else 'PASS',len(problems)))
    return bool(problems)


if __name__=='__main__':
    sys.exit(main())
