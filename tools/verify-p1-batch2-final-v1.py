#!/usr/bin/env python3
"""Independent P1 Batch 2 final source, option, and guest evidence audit.

Historical originals are read-only. The 26 normal matrix cells and four
real compiler-instrumented source runs are preserved with exact SHA256
logs. Genuine compiler ICEs, wall timeouts, and assertion failures do
not become passing results just because P1 test construction finishes.
"""

import argparse
import collections
import csv
import gzip
import hashlib
import io
import os
from pathlib import Path
import re
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT/'manifests/PDP10-P1-BATCH2-FINAL-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT/'refs/pdp10-p1-batch2-final-20261119-v1.tar.gz'
HIST = ROOT/'manifests/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
MATRIX = ROOT/'COMPILER_MATRIX.tsv'
MATRIX_DIR = 'pdp10-batch2-remaining-matrix-v1'
INSTRUMENTED_DIR = 'pdp10-eeprof-real-options-matrix-v1'
FIELDS = ('original_source','original_sha256','source','source_sha256',
          'profile','status','kind','fail_id_octal',
          'evidence_sha256','archive_member')

NORMAL = (
 ('pdp10-nestfunc-captured-sum-v1','nestfunc-3',False),
 ('pdp10-return-address-depth-v1','20010122-1',False),
 ('pdp10-gnu-wide-bitfield-promotions-v1','bf-sign-2',False),
 ('pdp10-dec-double-signbit-v1','991228-1',True),
 ('pdp10-gnu-dformat-initializer-v1','991228-1',False),
 ('pdp10-gnu-dec-signbit-function-v1','991228-1',False),
)
EEPROF = 'tests/semantic/upstream/extensions/eeprof-1.c'
SPECIAL_NAME = 'p1-eeprof-instrumented-v1'
GCC_OPTS = ('o0','o1','o2','os')


def read(path):
    with path.open(encoding='utf-8',newline='') as f:
        return list(csv.DictReader((line for line in f if line.strip() and
                                    not line.startswith('#')),delimiter='\t'))


def digest(data):
    return hashlib.sha256(data).hexdigest()


def source(name):
    return 'tests/semantic/regression/'+name+'.c'


def originals():
    return {Path(r['classified_path']).stem:r for r in read(HIST)}


def profile_names(has_kcc):
    out=['gcc-pdp6-'+x for x in GCC_OPTS]
    if has_kcc:
        out=['kcc-pdp6-opt','kcc-pdp6-noopt']+out
    return out


def kind_for(name,profile):
    if name=='pdp10-nestfunc-captured-sum-v1':
        return ('pass' if profile.endswith('-o1') else
                'simh_wall_timeout' if profile.endswith(('-o2','-os')) else
                'assertion_failure')
    if name=='pdp10-return-address-depth-v1':
        return 'assertion_failure'
    if name=='pdp10-gnu-wide-bitfield-promotions-v1':
        return 'pass'
    if name=='pdp10-dec-double-signbit-v1':
        return 'assertion_failure' if profile=='kcc-pdp6-opt' else 'pass'
    if name=='pdp10-gnu-dformat-initializer-v1':
        return 'pass'
    if name=='pdp10-gnu-dec-signbit-function-v1':
        return 'compiler_ice' if profile.endswith('-o0') else 'pass'
    raise ValueError('unknown semantic source: '+name)


def status_for(kind):
    if kind in ('pass','instrumented_pass'):
        return 'pass'
    if kind=='compiler_ice':
        return 'compiler_ice'
    return 'run_fail'


def independent_oracles():
    errors=[]
    bodies={name:(ROOT/source(name)).read_text(encoding='ascii')
            for name,_,_ in NORMAL}
    # Evaluate the original triple-nested callback order independently.
    value=0
    calls=0
    for i in range(2):
        for j in range(2):
            for k in range(2):
                a=abs(j-k)
                b=i
                leaf=(a-b if a>2*b else b-a)
                value+=leaf+value
                calls+=1
    nested=bodies['pdp10-nestfunc-captured-sum-v1']
    if (value!=105 or calls!=8 or 'sum != 105L' not in nested or
            'callbacks_v1 != 8UL' not in nested or
            'long nest_0(long a, long b)' not in nested or
            'return use_v1(nest_0, b, a) + sum' not in nested or
            'return nest_1(b, a)' not in nested or
            'sum += foo_v1(i,' not in nested):
        errors.append('bounded nested-function original oracle missing')
    address=bodies['pdp10-return-address-depth-v1']
    for token in ('__builtin_return_address(0)',
                  '__builtin_return_address(1)',
                  '__builtin_alloca(4)',
                  'returns0_v1[0] != returns0_v1[1]',
                  'returns1_v1[0] != returns1_v1[1]',
                  'returns2_v1[0] != returns2_v1[1]',
                  'returns3_v1[0] != returns3_v1[1]',
                  'side_v1 != 11U'):
        if token not in address:
            errors.append('return-address ABI original form missing: '+token)
    bits=bodies['pdp10-gnu-wide-bitfield-promotions-v1']
    for token in ('unsigned long long u3 : 3;',
                  'unsigned long long u35 : 35;',
                  'bits_v1.u3 - 2) >= 0',
                  'bits_v1.u35 - 2) >= 0',
                  '(1ULL << 35) - 1ULL'):
        if token not in bits:
            errors.append('GNU wide-bitfield promotion policy missing: '+token)
    sign=bodies['pdp10-dec-double-signbit-v1']
    initial=bodies['pdp10-gnu-dformat-initializer-v1']
    func=bodies['pdp10-gnu-dec-signbit-function-v1']
    for token in ('#define SIGN_V1 0400000000000UL',
                  'd_v1.words[0] & SIGN_V1',
                  'd_v1.words[1] & SIGN_V1',
                  'check_v1(-0.25, 1',
                  'check_v1(0.25, 0'):
        if token not in sign:
            errors.append('DEC native double-sign reference missing: '+token)
    for token in ('} negative_v1 = { d: -0.25 };',
                  'negative_v1.words[0] & SIGN_V1',
                  'negative_v1.words[1] & SIGN_V1'):
        if token not in initial:
            errors.append('GNU D-format initializer reference missing: '+token)
    for token in ('} bits = { d: x };','return bits.words[0] < 0;',
                  'if (!native_signbit_v1(input_v1))',
                  'if (native_signbit_v1(input_v1))'):
        if token not in func:
            errors.append('original GNU signbit-function ICE form missing: '+token)
    host_sign=(1 << 35)
    if int('400000000000',8)!=host_sign:
        errors.append('DEC sign-mask independent 36-bit value incorrect')
    original_ee=(ROOT/EEPROF).read_text(encoding='ascii')
    for token in ('__cyg_profile_func_enter',
                  '__cyg_profile_func_exit',
                  '__attribute__ ((no_instrument_function))',
                  'entry_calls == 3 && exit_calls == 3'):
        if token not in original_ee:
            errors.append('original instrumentation requirement missing: '+token)
    return errors


def inspect_blob(blob,row):
    errors=[]
    fields=(('SOURCE: ',row['source']),
            ('ORIGINAL: ',row['original_source']),
            ('SHA256: ',row['source_sha256']),
            ('PROFILE: ',row['profile']),
            ('STATUS: ',row['status']),
            ('KIND: ',row['kind']))
    for key,value in fields:
        if (key+value+'\n').encode('ascii') not in blob:
            errors.append('missing source/profile header: '+key+value)
    kind=row['kind']
    text=blob.decode('utf-8','replace')
    if kind=='pass':
        if 'PASS tests_' not in text or '--expect __test_exit=0' not in text:
            errors.append('guest PASS not supported by actual p10run output')
    elif kind=='instrumented_pass':
        if ('-finstrument-functions' not in text or
                '-D__pdp10__' not in text or
                'pushj 17,__cpfn' not in text or
                '__cpfn:' not in text or '__cpfx:' not in text or
                'PASS p1-eeprof-' not in text or
                '--expect __test_exit=0' not in text):
            errors.append('missing genuine instrumented guest pass/flags/hooks')
    elif kind=='assertion_failure':
        match=re.search(r'FAIL: fail_id: got ([0-7]+) expected [0-7]+',text)
        if not match or int(match.group(1),8)==0 or 'FAIL: __test_exit: got ' not in text:
            errors.append('assertion failure not a readable failing guest check')
        elif row['fail_id_octal']!=match.group(1):
            errors.append('wrong captured PDP6 fail_id checkpoint')
    elif kind=='simh_wall_timeout':
        if ('FAIL: SIMH exited with status 124' not in text or
                'no readable examine output' not in text):
            errors.append('unreadable simulator wall timeout misclassified')
    elif kind=='compiler_ice':
        if ('internal compiler error' not in text.lower() or
                ('instantiate_virtual_regs' not in text and
                 'function.c' not in text)):
            errors.append('original GCC compiler internal error not preserved')
    else:
        errors.append('unknown guest/complier result '+kind)
    if kind!='assertion_failure' and row['fail_id_octal']:
        errors.append('invented fail_id for nonassertion result')
    return errors


def capture():
    import importlib.util
    sys.path.insert(0,str(ROOT/'tools'))
    spec=importlib.util.spec_from_file_location('p10tk_runner_b2final',
                                                ROOT/'tools/run-tests.py')
    runner=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    temp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp')
    data=[]
    blobs={}
    original=originals()
    for index,(name,origin,kcc) in enumerate(NORMAL,1):
        src=source(name)
        raw=(ROOT/src).read_bytes()
        owner=original[origin]
        path=owner['classified_path']
        for p in runner.all_profiles():
            if p['family']!='native' or p['machine']!='pdp6':continue
            if p['compiler']=='kcc' and not kcc:continue
            profile=p['profile']
            kind=kind_for(name,profile)
            ctx=dict(p,kind='semantic')
            cell=runner.cell_dir(temp/MATRIX_DIR,src,ctx)
            info=runner.read_cell_status(temp/MATRIX_DIR,src,ctx)
            if not info or info['status']!=status_for(kind):
                raise ValueError('missing profile or incorrect real status: '+src+' '+profile)
            contents=(cell/'cell.log').read_bytes()
            reports=sorted((cell/'run').glob('*.report.txt'))
            if len(reports)>1:
                raise ValueError('ambiguous SIMH report: '+str(cell))
            for report in reports:
                contents+=b'\n=== GUEST REPORT ===\n'+report.read_bytes()
            member='case%02d/%s-v1.log'%(index,profile)
            header=('SOURCE: %s\nORIGINAL: %s\nSHA256: %s\n'
                    'PROFILE: %s\nSTATUS: %s\nKIND: %s\n\n'%
                    (src,path,digest(raw),profile,info['status'],kind)).encode('ascii')
            payload=header+contents
            match=re.search(rb'FAIL: fail_id: got ([0-7]+)',payload)
            checkpoint=match.group(1).decode('ascii') if (
                match and kind=='assertion_failure') else ''
            row=dict(original_source=path,
                     original_sha256=owner['source_sha256'],
                     source=src,source_sha256=digest(raw),profile=profile,
                     status=info['status'],kind=kind,
                     fail_id_octal=checkpoint,
                     evidence_sha256=digest(payload),archive_member=member)
            problems=inspect_blob(payload,row)
            if problems:raise ValueError('; '.join(problems)+' '+src)
            data.append(row)
            blobs[member]=payload
    if len(data)!=26:
        raise ValueError('expected 26 normal PDP6 GCC/KCC test executions')
    path=EEPROF
    raw=(ROOT/path).read_bytes()
    owner=original['eeprof-1']
    for opt in GCC_OPTS:
        profile='gcc-pdp6-'+opt+'-instrumented'
        directory=temp/INSTRUMENTED_DIR/('gcc-pdp6-'+opt)
        assembly=(directory/'eeprof-1-v1.s').read_bytes()
        compilelog=(directory/'compile-v1.log').read_bytes()
        runlog=(directory/'p10run-v1.log').read_bytes()
        reports=sorted(directory.glob('*.report.txt'))
        if len(reports)!=1:
            raise ValueError('missing instrumented real SIMH report: '+profile)
        contents=(compilelog+b'\n=== ASSEMBLY ===\n'+assembly+
                  b'\n=== GUEST RUN ===\n'+runlog+
                  b'\n=== GUEST REPORT ===\n'+reports[0].read_bytes())
        member='eeprof/%s-v1.log'%profile
        header=('SOURCE: %s\nORIGINAL: %s\nSHA256: %s\n'
                'PROFILE: %s\nSTATUS: pass\nKIND: instrumented_pass\n\n'%
                (path,path,digest(raw),profile)).encode('ascii')
        payload=header+contents
        row=dict(original_source=path,
                 original_sha256=owner['source_sha256'],
                 source=path,source_sha256=digest(raw),profile=profile,
                 status='pass',kind='instrumented_pass',
                 fail_id_octal='',evidence_sha256=digest(payload),
                 archive_member=member)
        problems=inspect_blob(payload,row)
        if problems:raise ValueError('; '.join(problems)+' '+profile)
        data.append(row)
        blobs[member]=payload
    if len(data)!=30:
        raise ValueError('expected exactly 30 independent source profiles')
    with LEDGER.open('w',encoding='ascii',newline='') as fd:
        w=csv.DictWriter(fd,fieldnames=FIELDS,delimiter='\t',lineterminator='\n')
        w.writeheader()
        w.writerows(data)
    with ARCHIVE.open('wb') as fd:
        with gzip.GzipFile(fileobj=fd,mode='wb',mtime=0) as z:
            with tarfile.open(fileobj=z,mode='w') as tar:
                for name,payload in sorted(blobs.items()):
                    info=tarfile.TarInfo(name)
                    info.size=len(payload)
                    info.mode=0o644
                    info.mtime=0
                    tar.addfile(info,io.BytesIO(payload))
    print('CAPTURED 26 normal matrix plus four real -finstrument-functions profiles')


def audit(ledger=LEDGER,archive=ARCHIVE):
    errors=independent_oracles()
    originals_map=originals()
    matrix={r['test']:r for r in read(MATRIX)}
    expected={}
    for index,(name,origin,kcc) in enumerate(NORMAL,1):
        owner=originals_map.get(origin)
        if owner is None:
            errors.append('missing original source hash: '+origin)
            continue
        original=owner['classified_path']
        if digest((ROOT/original).read_bytes())!=owner['source_sha256']:
            errors.append('historical original modified: '+original)
        src=source(name)
        sha=digest((ROOT/src).read_bytes())
        reg=matrix.get(src)
        if reg is None:
            errors.append('missing normal compiler matrix source: '+src)
            continue
        for profile in profile_names(kcc):
            compiler,_,opt=profile.split('-')
            col='pdp6' if compiler=='kcc' else 'pdp6_gcc_'+opt
            if reg.get(col) not in ('semantic','fail','timeout','runtime','ok'):
                errors.append('normal profile not active: '+profile+' '+src)
            kind=kind_for(name,profile)
            key=(src,profile)
            expected[key]=(original,owner['source_sha256'],sha,
                           kind,'case%02d/%s-v1.log'%(index,profile))
    owner=originals_map.get('eeprof-1')
    if owner is None:
        errors.append('missing unchanged eeprof original')
    else:
        if digest((ROOT/EEPROF).read_bytes())!=owner['source_sha256']:
            errors.append('changed original eeprof source')
        for opt in GCC_OPTS:
            profile='gcc-pdp6-'+opt+'-instrumented'
            expected[(EEPROF,profile)]=(EEPROF,owner['source_sha256'],
               digest((ROOT/EEPROF).read_bytes()),'instrumented_pass',
               'eeprof/%s-v1.log'%profile)
    try:
        entries=read(ledger)
        if len(entries)!=30 or entries and tuple(entries[0])!=FIELDS:
            errors.append('wrong evidence TSV schema or profile count')
        seen=set()
        names=set()
        with tarfile.open(archive,'r:gz') as tar:
            members={x.name:x for x in tar.getmembers()}
            for row in entries:
                key=(row['source'],row['profile'])
                if key in seen or key not in expected:
                    errors.append('unrecognized/duplicate source profile '+str(key))
                    continue
                seen.add(key)
                original,original_sha,sha,kind,member=expected[key]
                names.add(member)
                info=members.get(member)
                if (row['original_source']!=original or
                        row['original_sha256']!=original_sha or
                        row['source_sha256']!=sha or
                        row['status']!=status_for(kind) or
                        row['kind']!=kind or
                        row['archive_member']!=member or
                        info is None or not info.isfile()):
                    errors.append('false source ownership or outcome: '+str(key))
                    continue
                f=tar.extractfile(info)
                payload=f.read() if f else b''
                if digest(payload)!=row['evidence_sha256']:
                    errors.append('source profile evidence SHA256 mismatch '+str(key))
                errors.extend(inspect_blob(payload,row))
            if set(expected)!=seen or set(members)!=names:
                errors.append('missing/extra actual PDP6 test profiles')
    except (OSError,ValueError,KeyError,tarfile.TarError) as err:
        errors.append('cannot check archived guest/compiler evidence: '+str(err))
    return errors


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--capture',action='store_true')
    args=parser.parse_args()
    if args.capture:
        capture()
    problems=audit()
    for line in problems:
        print('ERROR: '+line)
    tally=collections.Counter(r['kind'] for r in read(LEDGER)) if LEDGER.exists() else {}
    print('P1 Batch 2 final evidence: %s (30 source/profile records, %d errors, %s)'%
          ('FAIL' if problems else 'PASS',len(problems),dict(tally)))
    return bool(problems)

if __name__=='__main__':
    sys.exit(main())
