#!/usr/bin/env python3
"""Source/hash, matrix, assertion, and simulator-provenance verification.

Capture with --capture only after executing normal PDP-6 matrix cells.
Default mode is a self-contained host verifier of the immutable log
archive and source-specific expected outcomes. Historical originals and
compiler failures are never edited, and a SIMH timeout is not an abort.
"""

import argparse
import csv
import gzip
import hashlib
import io
import math
import os
from pathlib import Path
import re
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / 'manifests/PDP10-P1-BATCH1-ADMISSION-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-batch1-admission-20261119-v1.tar.gz'
HISTORICAL = ROOT / 'manifests/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
FIELDS = ('original_source','source','source_sha256','profile','status',
          'observed_kind','fail_id_octal','evidence_sha256','archive_member')

# All eight sources are in the ordinary matrix; the untouched source
# identities are preserved in HISTORICAL. A flexible initializer's two
# independent assertions have separate companion sources.
ENTRIES = (
    ('pdp10-enum-code-bitfield-switch-v1', '20000914-1', True),
    ('pdp10-flexible-string-initializers-v1', '20010924-1', False),
    ('pdp10-fixed-string-initializer-baselines-v1', '20010924-1', True),
    ('pdp10-packed-unaligned-complex-v1', '20020227-1', False),
    ('pdp10-complex-conjugate-array-v1', '20020411-1', False),
    ('pdp10-label-offset-dispatch-v1', '920302-1', False),
    ('pdp10-wide-powmod-gcd-v1', '920501-2', True),
    ('pdp10-wide-isqrt-prime-v1', '920501-6', True),
)
FILES = {
    'pdp10-enum-code-bitfield-switch-v1': 'pdp10-batch1-all-matrix-v1',
    'pdp10-flexible-string-initializers-v1': 'pdp10-batch1-all-matrix-v1',
    'pdp10-fixed-string-initializer-baselines-v1': 'pdp10-batch1-all-matrix-v1',
    'pdp10-packed-unaligned-complex-v1': 'pdp10-batch1-four-matrix-v1',
    'pdp10-complex-conjugate-array-v1': 'pdp10-batch1-four-matrix-v1',
    'pdp10-label-offset-dispatch-v1': 'pdp10-batch1-four-matrix-v1',
    'pdp10-wide-powmod-gcd-v1': 'pdp10-batch1-all-matrix-v1',
    'pdp10-wide-isqrt-prime-v1': 'pdp10-batch1-all-matrix-v1',
}


def read_tsv(path):
    with path.open(encoding='utf-8', newline='') as f:
        return list(csv.DictReader((line for line in f if line.strip() and
                                    not line.startswith('#')), delimiter='\t'))


def source_for(name):
    return 'tests/semantic/regression/' + name + '.c'


def originals():
    return {Path(r['classified_path']).stem: r for r in read_tsv(HISTORICAL)}


def outcome(name, profile):
    compiler, machine, opt = profile.split('-')
    if machine != 'pdp6' or compiler not in ('kcc','gcc'):
        raise ValueError('unexpected execution profile: ' + profile)
    if compiler == 'kcc':
        kinds = {
            'pdp10-enum-code-bitfield-switch-v1': 'assertion_failure',
            'pdp10-fixed-string-initializer-baselines-v1': 'pass',
            'pdp10-wide-powmod-gcd-v1': 'link_missing_umoddi3',
            'pdp10-wide-isqrt-prime-v1':
                ('step_limit' if opt == 'noopt' else 'assertion_failure'),
        }
        if name not in kinds or opt not in ('opt','noopt'):
            raise ValueError('unsupported KCC fixture: ' + name)
        return kinds[name]
    if opt not in ('o0','o1','o2','os'):
        raise ValueError('unsupported GCC profile: '+profile)
    if name == 'pdp10-label-offset-dispatch-v1':
        return 'simulator_timeout'
    if name == 'pdp10-wide-isqrt-prime-v1' and opt == 'os':
        return 'pass'
    if name in ('pdp10-enum-code-bitfield-switch-v1',
                'pdp10-flexible-string-initializers-v1'):
        return 'pass'
    return 'assertion_failure'


def status_for(kind):
    if kind == 'pass':
        return 'pass'
    if kind == 'link_missing_umoddi3':
        return 'link_fail'
    return 'run_fail'


def profiles(name, kcc):
    result = []
    if kcc:
        result.extend(('kcc-pdp6-opt','kcc-pdp6-noopt'))
    result.extend(('gcc-pdp6-o0','gcc-pdp6-o1','gcc-pdp6-o2','gcc-pdp6-os'))
    return result


def check_payload(payload, row):
    errors = []
    identity = (('SOURCE: %s\n'%row['source']),
                ('SHA256: %s\n'%row['source_sha256']),
                ('PROFILE: %s\n'%row['profile']),
                ('STATUS: %s\n'%row['status']),
                ('KIND: %s\n'%row['observed_kind']))
    for part in identity:
        if part.encode('ascii') not in payload:
            errors.append('missing archived identity: '+part.strip())
    kind = row['observed_kind']
    text = payload.decode('utf-8','replace')
    if kind == 'pass':
        if 'PASS tests_' not in text or '--expect __test_exit=0' not in text:
            errors.append('no actual passing PDP-6 guest execution')
    elif kind == 'assertion_failure':
        match = re.search(r'FAIL: fail_id: got ([0-7]+) expected [0-7]+',text)
        if ('FAIL: __test_exit: got ' not in text or match is None or
                int(match.group(1),8) == 0 or
                row['fail_id_octal'] != match.group(1)):
            errors.append('missing real failing assertion and checkpoint')
    elif kind == 'simulator_timeout':
        if ('FAIL: SIMH exited with status 124' not in text or
                'no readable examine output' not in text):
            errors.append('SIMH timeout not reproduced')
    elif kind == 'step_limit':
        if ('Step expired, PC:' not in text or
                'FAIL: __test_exit:' not in text):
            errors.append('step-limit outcome not reproduced')
    elif kind == 'link_missing_umoddi3':
        if ('dlink: undefined symbol: __kcc_umoddi3' not in text or
                'p10run: link failed' not in text):
            errors.append('real wide-division linkage failure missing')
    else:
        errors.append('unrecognized outcome kind: '+kind)
    if kind != 'assertion_failure' and row['fail_id_octal']:
        errors.append('a non-assertion result carries a false failure checkpoint')
    return errors


def check_oracles():
    problems = []
    srcs = {name:(ROOT / source_for(name)).read_text(encoding='ascii')
            for name,_,_ in ENTRIES}
    enum_original = (ROOT / 'tests/todo/generic/20000914-1.c').read_text()
    prefix = enum_original[enum_original.index('enum tree_code {'):
                           enum_original.index('\nblah(){}')]
    if prefix not in srcs['pdp10-enum-code-bitfield-switch-v1']:
        problems.append('historical enum and bitfield structure not preserved')
    if 'AMBIG_CONV' not in prefix or 'case AMBIG_CONV:' not in srcs[
            'pdp10-enum-code-bitfield-switch-v1']:
        problems.append('8-bit enum discriminator not tested')
    values = {}
    blocks = re.findall(
        r'enum (tree_code|c_tree_code|cplus_tree_code)\s*\{([^}]+)\}',
        prefix, re.S)
    if len(blocks) != 3:
        problems.append('missing original three enum chains')
    for _,block in blocks:
        next_value = 0
        for entry in block.split(','):
            entry = entry.strip()
            if not entry:
                continue
            if '=' in entry:
                name,initializer = [s.strip() for s in entry.split('=',1)]
                next_value = (values[initializer] if initializer in values
                              else int(initializer,0))
            else:
                name = entry
            values[name] = next_value
            next_value += 1
    if (values.get('AMBIG_CONV') != 222 or
            'enum tree_code code : 8;' not in prefix):
        problems.append('original code:8 width or enum value 222 changed')
    # The fixed pointer baseline must not be folded into the GNU
    # flexible-array test, or the unrelated GCC pointer failure masks
    # the feature's actual passing result.
    flexible = srcs['pdp10-flexible-string-initializers-v1']
    fixed = srcs['pdp10-fixed-string-initializer-baselines-v1']
    if ("'o', \"wx\"" not in flexible or
            "'9', {'e', 'b'}" not in flexible or
            'a1_v1.p[2] != 0' not in fixed or
            'a1_v1' in flexible):
        problems.append('flexible extension mixed with pointer baseline')
    complex_src = srcs['pdp10-packed-unaligned-complex-v1']
    conjugate = srcs['pdp10-complex-conjugate-array-v1']
    if ('__attribute__((packed))' not in complex_src or
            '__real__ p->f != 1.0F' not in complex_src or
            '__imag__ p->f != 0.0F' not in complex_src or
            '__builtin_conjf' not in conjugate or
            '__imag__ result[0] != -1.0' not in conjugate):
        problems.append('unaligned complex / conjugate oracle lost')
    label = srcs['pdp10-label-offset-dispatch-v1']
    if ('&&label_y_v1' not in label or 'goto *(base + *instructions++)'
            not in label or '"xyxyz"' not in label):
        problems.append('computed goto/label offset test no longer executes')
    wide = srcs['pdp10-wide-powmod-gcd-v1']
    if (3**27 % 134217727 != 17325482 or 5**7 % 97 != 40 or
            math.gcd(123456,7890)!=6 or
            '!= 17325482ULL' not in wide or '!= 40ULL' not in wide or
            '!= 6UL' not in wide):
        problems.append('independent mod-power/gcd reference altered')
    square = srcs['pdp10-wide-isqrt-prime-v1']
    matches = re.findall(r'check_sqrt_v1\((0x[0-9A-Fa-f]+|[0-9]+)ULL,\s*'
                         r'([0-9]+)UL,\s*([0-9]+)\);',square)
    if len(matches)!=11:
        problems.append('expected eleven integer-sqrt reference cases')
    for value,expected,_ in matches:
        if math.isqrt(int(value,0))!=int(expected):
            problems.append('host integer square root reference mismatch: '+value)
    if ('str2llu_v1("1234111111")' not in square or
            'plist_v1(11ULL, 31ULL' not in square):
        problems.append('decimal parser or short primality interval missing')
    return problems


def capture():
    import importlib.util
    sys.path.insert(0,str(ROOT / 'tools'))
    spec=importlib.util.spec_from_file_location('p10tk_batch_runner_v1',
                                                ROOT / 'tools/run-tests.py')
    runner=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    temp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp')
    observed=[]
    blobs={}
    references=originals()
    for index,(name,origin,kcc) in enumerate(ENTRIES,1):
        source=source_for(name)
        digest=hashlib.sha256((ROOT/source).read_bytes()).hexdigest()
        original=references[origin]['classified_path']
        root=temp/FILES[name]
        for profile in runner.all_profiles():
            if profile['machine']!='pdp6' or profile['family']!='native':
                continue
            if profile['compiler']=='kcc' and not kcc:
                continue
            kind=outcome(name,profile['profile'])
            p=dict(profile,kind='semantic')
            details=runner.read_cell_status(root,source,p)
            if not details or details['status']!=status_for(kind):
                raise ValueError('wrong/missing real matrix result '+source+
                                 ' '+profile['profile']+' '+repr(details))
            cell=runner.cell_dir(root,source,p)
            content=(cell/'cell.log').read_bytes()
            # A failing normal-matrix cell may store cell.log as its
            # checkpoint report even though p10run also wrote a real
            # run/*.report.txt. Keep those guest artifacts separately:
            # only the SIMH report proves a step-limit vs an abort.
            guest_reports=sorted((cell/'run').glob('*.report.txt'))
            if len(guest_reports)>1:
                raise ValueError('ambiguous guest reports: '+str(cell))
            for report in guest_reports:
                content+=b'\n=== GUEST REPORT ===\n'+report.read_bytes()
            header=('SOURCE: %s\nSHA256: %s\nPROFILE: %s\nSTATUS: %s\n'
                    'KIND: %s\n\n'%(source,digest,profile['profile'],
                                     details['status'],kind)).encode('ascii')
            payload=header+content
            checkpoint=''
            match=re.search(rb'FAIL: fail_id: got ([0-7]+)',payload)
            if kind=='assertion_failure':
                if match is None:raise ValueError('missing guest checkpoint')
                checkpoint=match.group(1).decode('ascii')
            name_in_archive='case%02d/%s-v1.log'%(index,profile['profile'])
            row={'original_source':original,'source':source,
                 'source_sha256':digest,'profile':profile['profile'],
                 'status':details['status'],'observed_kind':kind,
                 'fail_id_octal':checkpoint,
                 'evidence_sha256':hashlib.sha256(payload).hexdigest(),
                 'archive_member':name_in_archive}
            errors=check_payload(payload,row)
            if errors:raise ValueError('; '.join(errors)+' '+source)
            blobs[name_in_archive]=payload
            observed.append(row)
    if len(observed)!=40:raise ValueError('expected exactly 40 original PDP6 runs')
    with LEDGER.open('w',encoding='ascii',newline='') as fd:
        w=csv.DictWriter(fd,fieldnames=FIELDS,delimiter='\t',lineterminator='\n')
        w.writeheader();w.writerows(observed)
    with ARCHIVE.open('wb') as fd:
        with gzip.GzipFile(fileobj=fd,mode='wb',mtime=0) as compressed:
            with tarfile.open(fileobj=compressed,mode='w') as tar:
                for name,payload in sorted(blobs.items()):
                    item=tarfile.TarInfo(name)
                    item.size=len(payload)
                    item.mode=0o644
                    item.mtime=0
                    tar.addfile(item,io.BytesIO(payload))
    print('CAPTURED %d original PDP-6 compiler/profile results'%len(observed))
    return 0


def audit(ledger=LEDGER,archive=ARCHIVE):
    errors=check_oracles()
    original=originals()
    matrix={r['test']:r for r in read_tsv(MATRIX)}
    expected={}
    for index,(name,origin,kcc) in enumerate(ENTRIES,1):
        if origin not in original:
            errors.append('unknown historical source: '+origin)
            continue
        orig=original[origin]
        path=orig['classified_path']
        if hashlib.sha256((ROOT/path).read_bytes()).hexdigest()!=orig['source_sha256']:
            errors.append('original source modified: '+path)
        source=source_for(name)
        digest=hashlib.sha256((ROOT/source).read_bytes()).hexdigest()
        matrix_row=matrix.get(source)
        if matrix_row is None:
            errors.append('missing normal matrix registration: '+source)
            continue
        for profile in profiles(name,kcc):
            kind=outcome(name,profile)
            compiler,_,opt=profile.split('-')
            col='pdp6' if compiler=='kcc' else 'pdp6_gcc_'+opt
            allowed=('semantic','fail','timeout')
            if matrix_row.get(col) not in allowed:
                errors.append('source/profile not scheduled: '+source+' '+profile)
            key=(source,profile)
            expected[key]=(index,path,digest,kind)
    try:
        rows=read_tsv(ledger)
        if len(rows)!=40 or rows and tuple(rows[0])!=FIELDS:
            errors.append('incorrect source/profile count or TSV columns')
        seen=set()
        filenames=set()
        with tarfile.open(archive,'r:gz') as tar:
            members={m.name:m for m in tar.getmembers()}
            for row in rows:
                key=(row['source'],row['profile'])
                if key in seen or key not in expected:
                    errors.append('unknown/duplicate PDP-6 profile '+str(key))
                    continue
                seen.add(key)
                index,path,digest,kind=expected[key]
                archive_name='case%02d/%s-v1.log'%(index,row['profile'])
                filenames.add(archive_name)
                item=members.get(archive_name)
                if (row['original_source']!=path or
                        row['source_sha256']!=digest or
                        row['status']!=status_for(kind) or
                        row['observed_kind']!=kind or
                        row['archive_member']!=archive_name or
                        item is None or not item.isfile()):
                    errors.append('source/outcome mismatch: '+str(key))
                    continue
                handle=tar.extractfile(item)
                payload=handle.read() if handle else b''
                if hashlib.sha256(payload).hexdigest()!=row['evidence_sha256']:
                    errors.append('tampered original log: '+str(key))
                errors.extend(check_payload(payload,row))
            if set(expected)!=seen or set(members)!=filenames:
                errors.append('missing or extra compiler/guest evidence cells')
    except (OSError,ValueError,KeyError,tarfile.TarError) as exc:
        errors.append('cannot audit admission archive: '+str(exc))
    return errors


def main():
    arg=argparse.ArgumentParser(description=__doc__)
    arg.add_argument('--capture',action='store_true')
    args=arg.parse_args()
    if args.capture:
        capture()
    failures=audit()
    for item in failures:
        print('ERROR: '+item)
    print('P1 batch1 original-source admission: %s (40 PDP6 cells, %d errors)'%
          ('FAIL' if failures else 'PASS',len(failures)))
    return bool(failures)


if __name__=='__main__':
    sys.exit(main())
