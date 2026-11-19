#!/usr/bin/env python3
"""Audit 42 genuine PDP6 executions of Batch 3 target-width oracles.

Fail closed: original import/source SHA256, independent generated
1000-case arithmetic and exact original Karatsuba source, original
GNU prefetch call families, normal matrix profiles, checked simulator
outcomes, unmodified archived compiler/guest logs. Unsupported
features and genuine compiler failures are not converted into PASS.
"""

import argparse
import collections
import csv
import gzip
import hashlib
import importlib.util
import io
import os
from pathlib import Path
import re
import sys
import tarfile

ROOT=Path(__file__).resolve().parents[1]
LEDGER=ROOT/'docs/PDP10-P1-BATCH3-FINAL-RESULTS-20261119-v1.tsv'
ARCHIVE=ROOT/'refs/pdp10-p1-batch3-final-20261119-v1.tar.gz'
HIST=ROOT/'docs/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
MATRIX=ROOT/'COMPILER_MATRIX.tsv'
FIELDS=('original_source','original_sha256','source','source_sha256',
        'profile','status','kind','fail_id_octal','evidence_sha256','archive_member')
CASES=(
 ('pdp10-kdev-node-callpath-v1','980526-2',True,'pdp10-p1-batch3-first-matrix-v1'),
 ('pdp10-prefetch-original-forms-v1','builtin-prefetch-1',False,'pdp10-p1-batch3-first-matrix-v1'),
 ('pdp10-prefetch-global-local-original-v1','builtin-prefetch-2',False,'pdp10-p1-batch3-first-matrix-v1'),
 ('pdp10-prefetch-volatile-original-v1','builtin-prefetch-3',False,'pdp10-p1-batch3-first-matrix-v1'),
 ('pdp10-arith-random-1000-v1','arith-rand',True,'pdp10-p1-batch3-final-matrix-v1'),
 ('pdp10-dec-cbrt-newton-v1','cbrt',True,'pdp10-p1-batch3-final-matrix-v1'),
 ('pdp10-wide-union-overlay-v1','960416-1',True,'pdp10-p1-batch3-final-matrix-v1'),
 ('pdp10-original-wide-karatsuba-v1','960416-1',True,'pdp10-p1-batch3-final-matrix-v1'),
)
GCC=('gcc-pdp6-o0','gcc-pdp6-o1','gcc-pdp6-o2','gcc-pdp6-os')
KCC=('kcc-pdp6-opt','kcc-pdp6-noopt')


def read(path):
    with path.open(encoding='utf-8',newline='') as f:
        return list(csv.DictReader((x for x in f if x.strip() and
                                    not x.startswith('#')),delimiter='\t'))


def sha(data):
    return hashlib.sha256(data).hexdigest()


def src(name):
    return 'tests/semantic/regression/'+name+'.c'


def owner_map():
    return {Path(row['classified_path']).stem:row for row in read(HIST)}


def profiles(kcc):
    return KCC+GCC if kcc else GCC


def result(name,profile):
    if name=='pdp10-kdev-node-callpath-v1':
        return 'assertion_failure' if profile.startswith('kcc-') else 'pass'
    if name in ('pdp10-prefetch-original-forms-v1',
                'pdp10-prefetch-global-local-original-v1',
                'pdp10-prefetch-volatile-original-v1',
                'pdp10-dec-cbrt-newton-v1',
                'pdp10-wide-union-overlay-v1'):
        return 'pass'
    if name in ('pdp10-arith-random-1000-v1',
                'pdp10-original-wide-karatsuba-v1'):
        return 'assertion_failure'
    raise ValueError('unregistered Batch3 source '+name)


def expected_checkpoint(name,profile):
    if name=='pdp10-kdev-node-callpath-v1':return 3
    if name=='pdp10-arith-random-1000-v1':
        return 6 if profile.startswith('kcc-') else 2
    if name=='pdp10-original-wide-karatsuba-v1':
        return 4 if profile.startswith('kcc-') else 1
    return 0


def references():
    errors=[]
    def body(name):return (ROOT/src(name)).read_text(encoding='ascii')
    for name,orig,_,_ in CASES:
        text=body(name)
        if 'extern void abort(void)' not in text or 'fail_id' not in text:
            errors.append('missing active semantic assertion in '+name)
    node=body('pdp10-kdev-node-callpath-v1')
    val=(((0x12345678>>8)<<22)|(0x12345678&255))&((1<<36)-1)
    if (val!=0xd15800078 or 'observed_dev_v1 != 0xd15800078U' not in node or
            'mknod_v1(filename, mode, encode_v1(dev));' not in node or
            'observed_filename_v1 != name_v1' not in node):
        errors.append('original mknod callback/36-bit kdev oracle incorrect')
    includes=(('pdp10-prefetch-original-forms-v1','builtin-prefetch-1'),
              ('pdp10-prefetch-global-local-original-v1','builtin-prefetch-2'),
              ('pdp10-prefetch-volatile-original-v1','builtin-prefetch-3'))
    for name,orig in includes:
        text=body(name)
        for token in ('#define main original_main_v1',
                      '#define exit(n) return (n)',
                      '#include "../upstream/extensions/'+orig+'.c"',
                      '#undef exit','#undef main'):
            if token not in text:
                errors.append('historical prefetch source not included exactly: '+name)
    pre1=body(includes[0][0])
    pre2=body(includes[1][0])
    pre3=body(includes[2][0])
    for token in ('original_main_v1() != 0',
                  'arr[i] != i * 17 + 3'):
        if token not in pre1:errors.append('missing locality original state check')
    for token in ('simple_global();','simple_file();',
                  'simple_static_local();','simple_local();',
                  'simple_arg(glob_int_arr, glob_ptr_int, glob_int);',
                  'expr_global();','safe_local_v1();',
                  't.next = &t;',
                  '__builtin_prefetch(t.next->d, 0, 0);',
                  'glob_int_arr[i] != i + 20'):
        if token not in pre2:errors.append('unsafe or omitted global/local form '+token)
    for token in ('original_main_v1() != 0',
                  'glob_vol_int_arr[i] != i + 17',
                  'vol_str.next != &str'):
        if token not in pre3:errors.append('volatile original state absent '+token)
    # Ensure source-included histories actually contain the expected
    # full source expression families, not renamed/deleted call sites.
    source_counts=(('builtin-prefetch-1',22),
                   ('builtin-prefetch-2',51),
                   ('builtin-prefetch-3',46))
    originals=owner_map()
    for short,minimum in source_counts:
        orig=(ROOT/originals[short]['classified_path']).read_text(encoding='ascii')
        if orig.count('__builtin_prefetch (') < minimum:
            errors.append('historical original prefetch syntax family truncated: '+short)
    # Exact-source C generators are independent of guest compiler logs.
    for filename,name,fn in (
         ('tools/generate-pdp10-arith-rand-v1.py','pdp10-arith-random-1000-v1','generate'),
         ('tools/generate-pdp10-wide-karatsuba-v1.py','pdp10-original-wide-karatsuba-v1','generate')):
        spec=importlib.util.spec_from_file_location(name.replace('-','_'),ROOT/filename)
        mod=importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
        if body(name)!=getattr(mod,fn)():
            errors.append('generated independent source oracle tampered: '+name)
    cbrt=body('pdp10-dec-cbrt-newton-v1')
    for numeric in ('27.0, 3.0','-27.0, -3.0','8.0, 2.0',
                    '-8.0, -2.0','0.125, 0.5','0.015625, 0.25'):
        if numeric not in cbrt:
            errors.append('missing native DEC cube-root reference: '+numeric)
    if ('for (i = 0; i < 24; i++)' not in cbrt or
            'guess = (2.0 * guess + absolute / (guess * guess)) / 3.0;'
            not in cbrt):
        errors.append('native D-format Newton implementation missing')
    overlay=body('pdp10-wide-union-overlay-v1')
    for token in ('big_v1.d = 1ULL << 35;',
                  'big_v1.s.h != 1UL || big_v1.s.l != 0UL',
                  'little_v1.d = 1ULL;',
                  'little_v1.s.l != 0UL || little_v1.s.h != 1UL'):
        if token not in overlay:
            errors.append('native high36:low35 ABI overlay not checked: '+token)
    return errors


def check_log(blob,row):
    errors=[]
    for key,value in (('SOURCE: ',row['source']),
                      ('ORIGINAL: ',row['original_source']),
                      ('SHA256: ',row['source_sha256']),
                      ('PROFILE: ',row['profile']),
                      ('STATUS: ',row['status']),
                      ('KIND: ',row['kind'])):
        if (key+value+'\n').encode('ascii') not in blob:
            errors.append('missing archived profile identity '+key+value)
    text=blob.decode('utf-8','replace')
    if row['kind']=='pass':
        if ('PASS tests_' not in text or '--expect __test_exit=0' not in text):
            errors.append('no actual passing PDP6 guest output')
        if row['fail_id_octal']:
            errors.append('passing profile with false failing checkpoint')
    elif row['kind']=='assertion_failure':
        check=re.search(r'FAIL: fail_id: got ([0-7]+) expected [0-7]+',text)
        if (not check or int(check.group(1),8)!=expected_checkpoint(
                Path(row['source']).stem,row['profile']) or
                row['fail_id_octal']!=check.group(1) or
                'FAIL: __test_exit: got ' not in text):
            errors.append('missing genuine original PDP6 assertion checkpoint')
    else:
        errors.append('unknown/mislabeled guest outcome')
    return errors


def capture():
    sys.path.insert(0,str(ROOT/'tools'))
    spec=importlib.util.spec_from_file_location('pdp10_b3runner',
                                                ROOT/'tools/run-tests.py')
    runner=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    owners=owner_map()
    temp=Path(os.environ.get('TMPDIR') or Path.home()/'tmp')
    entries=[]
    blobs={}
    for index,(name,orig,kcc,folder) in enumerate(CASES,1):
        path=src(name)
        digest=sha((ROOT/path).read_bytes())
        owner=owners[orig]
        for p in runner.all_profiles():
            if p['family']!='native' or p['machine']!='pdp6':continue
            if p['compiler']=='kcc' and not kcc:continue
            profile=p['profile']
            kind=result(name,profile)
            ctx=dict(p,kind='semantic')
            info=runner.read_cell_status(temp/folder,path,ctx)
            status='pass' if kind=='pass' else 'run_fail'
            if not info or info['status']!=status:
                raise ValueError('missing real compiler/guest cell '+path+' '+profile)
            directory=runner.cell_dir(temp/folder,path,ctx)
            contents=(directory/'cell.log').read_bytes()
            reports=sorted((directory/'run').glob('*.report.txt'))
            if len(reports)>1:
                raise ValueError('ambiguous actual guest report '+str(directory))
            for report in reports:
                contents+=b'\n=== GUEST REPORT ===\n'+report.read_bytes()
            header=('SOURCE: %s\nORIGINAL: %s\nSHA256: %s\n'
                    'PROFILE: %s\nSTATUS: %s\nKIND: %s\n\n'%
                    (path,owner['classified_path'],digest,profile,status,kind)).encode('ascii')
            blob=header+contents
            matched=re.search(rb'FAIL: fail_id: got ([0-7]+)',blob)
            checkpoint=matched.group(1).decode('ascii') if (
                       kind=='assertion_failure' and matched) else ''
            member='case%02d/%s-v1.log'%(index,profile)
            row=dict(original_source=owner['classified_path'],
                     original_sha256=owner['source_sha256'],
                     source=path,source_sha256=digest,profile=profile,
                     status=status,kind=kind,fail_id_octal=checkpoint,
                     evidence_sha256=sha(blob),archive_member=member)
            problems=check_log(blob,row)
            if problems:raise ValueError('; '.join(problems)+' '+path)
            entries.append(row)
            blobs[member]=blob
    if len(entries)!=42:
        raise ValueError('expected 42 actual source/compiler observations')
    with LEDGER.open('w',encoding='ascii',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=FIELDS,delimiter='\t',lineterminator='\n')
        writer.writeheader();writer.writerows(entries)
    with ARCHIVE.open('wb') as f:
        with gzip.GzipFile(fileobj=f,mode='wb',mtime=0) as z:
            with tarfile.open(fileobj=z,mode='w') as t:
                for name,blob in sorted(blobs.items()):
                    info=tarfile.TarInfo(name)
                    info.mode=0o644
                    info.mtime=0
                    info.size=len(blob)
                    t.addfile(info,io.BytesIO(blob))
    print('CAPTURED 42 genuine source-linked native PDP6 executions')


def audit(ledger=LEDGER,archive=ARCHIVE):
    errors=references()
    owners=owner_map()
    matrix={r['test']:r for r in read(MATRIX)}
    expected={}
    for index,(name,orig,kcc,_) in enumerate(CASES,1):
        owner=owners[orig]
        original=owner['classified_path']
        if sha((ROOT/original).read_bytes())!=owner['source_sha256']:
            errors.append('original imported source modified: '+original)
        source=src(name)
        digest=sha((ROOT/source).read_bytes())
        reg=matrix.get(source)
        if reg is None:
            errors.append('normal matrix source not registered: '+source)
            continue
        for profile in profiles(kcc):
            compiler,_,opt=profile.split('-')
            key='pdp6' if compiler=='kcc' else 'pdp6_gcc_'+opt
            if reg.get(key) not in ('semantic','fail','timeout','runtime','ok'):
                errors.append('unregistered original source/profile '+source+' '+profile)
            status=result(name,profile)
            expected[(source,profile)]=(owner,digest,status,
                'case%02d/%s-v1.log'%(index,profile))
    try:
        rows=read(ledger)
        if len(rows)!=42 or rows and tuple(rows[0])!=FIELDS:
            errors.append('wrong source profile evidence schema/count')
        seen=set()
        filenames=set()
        with tarfile.open(archive,'r:gz') as t:
            members={m.name:m for m in t.getmembers()}
            for row in rows:
                key=(row['source'],row['profile'])
                if key in seen or key not in expected:
                    errors.append('unknown/duplicate original source profile '+str(key))
                    continue
                seen.add(key)
                owner,digest,kind,member=expected[key]
                filenames.add(member)
                entry=members.get(member)
                if (row['original_source']!=owner['classified_path'] or
                        row['original_sha256']!=owner['source_sha256'] or
                        row['source_sha256']!=digest or
                        row['status']!=('pass' if kind=='pass' else 'run_fail') or
                        row['kind']!=kind or
                        row['archive_member']!=member or
                        entry is None or not entry.isfile()):
                    errors.append('fabricated source or compiler outcome '+str(key))
                    continue
                fd=t.extractfile(entry)
                blob=fd.read() if fd else b''
                if sha(blob)!=row['evidence_sha256']:
                    errors.append('PDP6 evidence checksum mismatch '+str(key))
                errors.extend(check_log(blob,row))
            if set(expected)!=seen or set(members)!=filenames:
                errors.append('missing/extra PDP6 source execution records')
    except (OSError,ValueError,KeyError,tarfile.TarError) as exc:
        errors.append('cannot audit compiler/guest logs: '+str(exc))
    return errors


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--capture',action='store_true')
    args=parser.parse_args()
    if args.capture:capture()
    failures=audit()
    for item in failures:print('ERROR: '+item)
    count=collections.Counter(r['kind'] for r in read(LEDGER)) if LEDGER.exists() else {}
    print('P1 Batch 3 native-width source oracles: %s '
          '(42 source/profile records, %d errors, %s)'%(
              'FAIL' if failures else 'PASS',len(failures),dict(count)))
    return bool(failures)

if __name__=='__main__':
    sys.exit(main())
