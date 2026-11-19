#!/usr/bin/env python3
"""Audit six original Batch 2 source intents and 38 genuine PDP6 runs.

The source hash, imported source owner, active compiler profile and
exact class of passing/failing guest outcome are individually pinned.
No compiler/runtime repair or false promotion is performed here.
"""

import argparse
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

ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT/'docs/PDP10-P1-BATCH2-FIRST-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT/'refs/pdp10-p1-batch2-first-20261119-v1.tar.gz'
MATRIX = ROOT/'COMPILER_MATRIX.tsv'
HIST = ROOT/'docs/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
MATRIX_DIR = 'pdp10-batch2-admission-matrix-20261119-v1'
FIELDS = ('original_source','source','source_sha256','profile',
          'status','kind','fail_id_octal','evidence_sha256','archive_member')
ENTRIES = (
 ('pdp10-large-index-relocation-v1','index-1',True),
 ('pdp10-wide-shifted-accumulator-v1','961122-1',True),
 ('pdp10-nested-closure-calls-v1','931002-1',False),
 ('pdp10-builtin-strcmp-9bit-v1','921007-1',False),
 ('pdp10-bitfield-36bit-promotions-v1','bf-sign-2',True),
 ('pdp10-signed-right-shifts-v1','20020108-1',True),
 ('pdp10-width-shifts-v1','20020108-1',True),
)


def read_tsv(path):
    with path.open(encoding='utf-8',newline='') as fd:
        return list(csv.DictReader((line for line in fd if line.strip() and
                                    not line.startswith('#')),delimiter='\t'))


def src(name):
    return 'tests/semantic/regression/'+name+'.c'


def profiles(kcc):
    return (('kcc-pdp6-opt','kcc-pdp6-noopt') if kcc else ()) + (
        'gcc-pdp6-o0','gcc-pdp6-o1','gcc-pdp6-o2','gcc-pdp6-os')


def kind_for(name,profile):
    if name=='pdp10-large-index-relocation-v1':
        return 'pass' if profile=='kcc-pdp6-noopt' else 'rh18_link_overflow'
    if name=='pdp10-wide-shifted-accumulator-v1':
        return 'assertion_failure'
    if name=='pdp10-nested-closure-calls-v1':
        return 'pass' if profile=='gcc-pdp6-o0' else 'simh_wall_timeout'
    if name=='pdp10-builtin-strcmp-9bit-v1':
        return 'pass' if profile=='gcc-pdp6-o0' else 'assertion_failure'
    if name in ('pdp10-bitfield-36bit-promotions-v1',
                'pdp10-signed-right-shifts-v1',
                'pdp10-width-shifts-v1'):
        return 'pass'
    raise ValueError('unclassified source '+name)


def status_for(kind):
    if kind=='pass':return 'pass'
    if kind=='rh18_link_overflow':return 'link_fail'
    return 'run_fail'


def reference_errors():
    errors=[]
    bodies={name:(ROOT/src(name)).read_text(encoding='ascii')
            for name,_,_ in ENTRIES}
    idx=bodies['pdp10-large-index-relocation-v1']
    values=[int(x) for x in re.findall(r'\b\d+\b',
        idx[idx.index('static int values_v1[40] = {'):
            idx.index('};')])][-40:]
    if values!=list(range(40)) or values[100030-100000]!=30:
        errors.append('independent forty-element large-index oracle mismatch')
    for text in ('values_v1[n - 100000L]',
                 'lookup_v1(index_v1) != 30',
                 'lookup_v1(index_v1) != 0',
                 'lookup_v1(index_v1) != 39'):
        if text not in idx:errors.append('missing original large index: '+text)
    wide=bodies['pdp10-wide-shifted-accumulator-v1']
    expected=int('ffff00000000',16) + (1<<32)
    if expected!=int('1000000000000',16):
        errors.append('incorrect 71-bit high-word reference')
    for text in ('0xffff00000000LL','0x1000000000000LL',
                 '+= (signed long long)a << 32',
                 '-= (signed long long)a << 32'):
        if text not in wide:errors.append('missing original wide shift '+text)
    closure=bodies['pdp10-nested-closure-calls-v1']
    for text in ('void t0_v1(void)', 'void t1_v1(void)',
                 'void t2_v1(void)','t1_v1();','t2_v1();',
                 'callback_calls_v1 != 3U','nested_calls_v1 != 3U',
                 'captured_v1 != 3U'):
        if text not in closure:errors.append('missing nested closure edge: '+text)
    builtin=bodies['pdp10-builtin-strcmp-9bit-v1']
    for text in ('__builtin_strcmp(first_v1, second_v1) >= 0',
                 '"X\\376"','(unsigned char)second_v1[1] != 254U'):
        if text not in builtin:errors.append('missing nine-bit string check: '+text)
    bits=bodies['pdp10-bitfield-36bit-promotions-v1']
    for text in ('unsigned int u31 : 31;','unsigned int u32 : 32;',
                 'unsigned int u36 : 36;',
                 'widths_v1.u32 - 2 >= 0','widths_v1.u36 - 2U <= 0U'):
        if text not in bits:errors.append('missing 36-bit promotion reference: '+text)
    if bits.count('fail_id = ')!=7:
        errors.append('missing seven promoted integer checkpoints')
    # Recompute the generated signed and unsigned 9/18/36-bit tables
    # from Python arbitrary-precision arithmetic and exact source text.
    generators=(('pdp10-signed-right-shifts-v1',
                 'tools/generate-pdp10-signed-shifts-v1.py','source'),
                ('pdp10-width-shifts-v1',
                 'tools/generate-pdp10-width-shifts-v1.py','generate'))
    for name,filename,fn in generators:
        spec=importlib.util.spec_from_file_location(name.replace('-','_'),
                                                    ROOT/filename)
        obj=importlib.util.module_from_spec(spec)
        spec.loader.exec_module(obj)
        if bodies[name]!=getattr(obj,fn)():
            errors.append('independent width oracle changed: '+name)
    return errors


def verify_blob(blob,row):
    errors=[]
    required=(('SOURCE: %s\n'%row['source']),
              ('SHA256: %s\n'%row['source_sha256']),
              ('PROFILE: %s\n'%row['profile']),
              ('STATUS: %s\n'%row['status']),
              ('KIND: %s\n'%row['kind']))
    for req in required:
        if req.encode('ascii') not in blob:
            errors.append('missing captured source/profile identity '+req.strip())
    kind=row['kind']
    data=blob.decode('utf-8','replace')
    if kind=='pass':
        if 'PASS tests_' not in data or '--expect __test_exit=0' not in data:
            errors.append('no real PDP6 test completion')
    elif kind=='rh18_link_overflow':
        if 'dlink: RH18 relocation overflow' not in data or 'dlink: link failed' not in data:
            errors.append('real RH18 relocation failure not recorded')
    elif kind=='simh_wall_timeout':
        if ('FAIL: SIMH exited with status 124' not in data or
                'no readable examine output' not in data):
            errors.append('wall timeout falsely described as assertion')
    elif kind=='assertion_failure':
        match=re.search(r'FAIL: fail_id: got ([0-7]+) expected [0-7]+',data)
        expected=3 if 'builtin-strcmp' in row['source'] else 1
        if (match is None or int(match.group(1),8)!=expected or
                row['fail_id_octal']!=match.group(1) or
                'FAIL: __test_exit: got ' not in data):
            errors.append('no genuine expected arithmetic/string assertion')
    else:
        errors.append('unknown guest classification '+kind)
    if kind!='assertion_failure' and row['fail_id_octal']:
        errors.append('nonassertion has fabricated numbered failure')
    return errors


def capture():
    sys.path.insert(0,str(ROOT/'tools'))
    spec=importlib.util.spec_from_file_location('p10_runner_batch2',
                                                ROOT/'tools/run-tests.py')
    runner=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    root=Path(os.environ.get('TMPDIR') or Path.home()/'tmp')/MATRIX_DIR
    original={Path(r['classified_path']).stem:r for r in read_tsv(HIST)}
    rows=[]
    logs={}
    for i,(name,orig,kcc) in enumerate(ENTRIES,1):
        source=src(name)
        sha=hashlib.sha256((ROOT/source).read_bytes()).hexdigest()
        for p in runner.all_profiles():
            if p['machine']!='pdp6' or p['family']!='native':continue
            if p['compiler']=='kcc' and not kcc:continue
            kind=kind_for(name,p['profile'])
            cell=dict(p,kind='semantic')
            info=runner.read_cell_status(root,source,cell)
            if not info or info['status']!=status_for(kind):
                raise ValueError('missing exact matrix result: '+source+' '+p['profile']+' '+repr(info))
            directory=runner.cell_dir(root,source,cell)
            payload=(directory/'cell.log').read_bytes()
            reports=sorted((directory/'run').glob('*.report.txt'))
            if len(reports)>1:
                raise ValueError('ambiguous PDP6 report: '+str(directory))
            for report in reports:
                payload+=b'\n=== SIMULATOR REPORT ===\n'+report.read_bytes()
            header=('SOURCE: %s\nSHA256: %s\nPROFILE: %s\nSTATUS: %s\n'
                    'KIND: %s\n\n'%(source,sha,p['profile'],
                                     info['status'],kind)).encode('ascii')
            payload=header+payload
            fail_id=''
            if kind=='assertion_failure':
                m=re.search(rb'FAIL: fail_id: got ([0-7]+)',payload)
                if not m:raise ValueError('no assertion checkpoint: '+source)
                fail_id=m.group(1).decode('ascii')
            member='case%02d/%s-v1.log'%(i,p['profile'])
            row=dict(original_source=original[orig]['classified_path'],
                     source=source,source_sha256=sha,
                     profile=p['profile'],status=info['status'],kind=kind,
                     fail_id_octal=fail_id,
                     evidence_sha256=hashlib.sha256(payload).hexdigest(),
                     archive_member=member)
            issues=verify_blob(payload,row)
            if issues:raise ValueError('; '.join(issues)+' '+source)
            rows.append(row)
            logs[member]=payload
    if len(rows)!=38:raise ValueError('expected 38 actual compiler matrix cells')
    with LEDGER.open('w',encoding='ascii',newline='') as fd:
        writer=csv.DictWriter(fd,fieldnames=FIELDS,delimiter='\t',
                              lineterminator='\n')
        writer.writeheader();writer.writerows(rows)
    with ARCHIVE.open('wb') as fd:
        with gzip.GzipFile(fileobj=fd,mode='wb',mtime=0) as compressed:
            with tarfile.open(fileobj=compressed,mode='w') as tar:
                for member,payload in sorted(logs.items()):
                    item=tarfile.TarInfo(member)
                    item.size=len(payload)
                    item.mode=0o644
                    item.mtime=0
                    tar.addfile(item,io.BytesIO(payload))
    print('CAPTURED 38 Batch2 normal PDP-6 profile outputs')


def audit(ledger=LEDGER,archive=ARCHIVE):
    problems=reference_errors()
    original={Path(r['classified_path']).stem:r for r in read_tsv(HIST)}
    matrix={r['test']:r for r in read_tsv(MATRIX)}
    expected={}
    for index,(name,orig,kcc) in enumerate(ENTRIES,1):
        orig_row=original[orig]
        orig_path=orig_row['classified_path']
        if (hashlib.sha256((ROOT/orig_path).read_bytes()).hexdigest()!=
                orig_row['source_sha256']):
            problems.append('original source SHA256 changed: '+orig_path)
        source=src(name)
        sha=hashlib.sha256((ROOT/source).read_bytes()).hexdigest()
        reg=matrix.get(source)
        if reg is None:
            problems.append('missing registered normal matrix source '+source)
            continue
        for profile in profiles(kcc):
            compiler,_,opt=profile.split('-')
            column='pdp6' if compiler=='kcc' else 'pdp6_gcc_'+opt
            if reg.get(column) not in ('semantic','fail','timeout'):
                problems.append('unregistered matrix execution '+source+' '+profile)
            expected[(source,profile)]=(index,orig_path,sha,kind_for(name,profile))
    try:
        records=read_tsv(ledger)
        if len(records)!=38 or records and tuple(records[0])!=FIELDS:
            problems.append('bad compiler result count/header')
        seen=set()
        names=set()
        with tarfile.open(archive,'r:gz') as tar:
            files={m.name:m for m in tar.getmembers()}
            for row in records:
                key=(row['source'],row['profile'])
                if key in seen or key not in expected:
                    problems.append('unknown/duplicate PDP6 record '+str(key))
                    continue
                seen.add(key)
                index,orig,sha,kind=expected[key]
                member='case%02d/%s-v1.log'%(index,row['profile'])
                names.add(member)
                item=files.get(member)
                if (row['original_source']!=orig or
                        row['source_sha256']!=sha or
                        row['status']!=status_for(kind) or
                        row['kind']!=kind or
                        row['archive_member']!=member or
                        item is None or not item.isfile()):
                    problems.append('wrong original/source/profile outcome '+str(key))
                    continue
                fd=tar.extractfile(item)
                blob=fd.read() if fd else b''
                if hashlib.sha256(blob).hexdigest()!=row['evidence_sha256']:
                    problems.append('original simulator evidence checksum changed '+str(key))
                problems.extend(verify_blob(blob,row))
            if seen!=set(expected) or names!=set(files):
                problems.append('missing/extra compiler profile evidence')
    except (OSError,KeyError,ValueError,tarfile.TarError) as exc:
        problems.append('could not verify archived original tool output '+str(exc))
    return problems


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--capture',action='store_true')
    args=ap.parse_args()
    if args.capture:capture()
    failures=audit()
    for error in failures:print('ERROR:',error)
    print('P1 Batch 2 initial source oracles: %s (38 native cells, %d errors)'%
          ('FAIL' if failures else 'PASS',len(failures)))
    return bool(failures)


if __name__=='__main__':
    sys.exit(main())
