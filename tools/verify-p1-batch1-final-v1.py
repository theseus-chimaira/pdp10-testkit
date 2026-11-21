#!/usr/bin/env python3
"""Verify final Batch 1 target-policy and full-original source oracles.

Five source-pinned executable companions contribute 28 ordinary
PDP-6 compiler/mode results. Distinguish passing assertions, original
prime failures, step limits and genuine KCC linker helper absence.
Historical upstream identities and old evidence are read-only.
"""

import argparse
import csv
import gzip
import hashlib
import importlib.util
import io
import math
import os
from pathlib import Path
import re
import sys
import tarfile

ROOT = Path(__file__).resolve().parents[1]
LEDGER = ROOT / 'manifests/PDP10-P1-BATCH1-FINAL-RESULTS-20261119-v1.tsv'
ARCHIVE = ROOT / 'refs/pdp10-p1-batch1-final-20261119-v1.tar.gz'
HIST = ROOT / 'manifests/SEMANTIC-DEFERRED-DISPOSITION-20261118-v24.tsv'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'
FIELDS = ('original_source','source','source_sha256','profile','status',
          'kind','fail_id_octal','evidence_sha256','archive_member')
MATRIX_DIR = 'pdp10-p1-batch1-controls-matrix-20261119-v1'
ENTRIES = (
    ('pdp10-enum-bitfield-policy-v1','20000914-1',True),
    ('pdp10-label-offset-identity-v1','920302-1',False),
    ('pdp10-label-direct-dispatch-v1','920302-1',True),
    ('pdp10-pollard-factor-original-v1','920501-2',True),
    ('pdp10-original-prime-interval-v1','920501-6',True),
)


def read(path):
    with path.open(encoding='utf-8',newline='') as f:
        return list(csv.DictReader((ln for ln in f if ln.strip() and
                                    not ln.startswith('#')),delimiter='\t'))


def source(name):
    return 'tests/semantic/regression/'+name+'.c'


def profiles(kcc):
    return (('kcc-pdp6-opt','kcc-pdp6-noopt') if kcc else ()) + (
        'gcc-pdp6-o0','gcc-pdp6-o1','gcc-pdp6-o2','gcc-pdp6-os')


def kind_for(name,profile):
    if name in ('pdp10-enum-bitfield-policy-v1',
                'pdp10-label-offset-identity-v1',
                'pdp10-label-direct-dispatch-v1'):
        return 'pass'
    if name=='pdp10-pollard-factor-original-v1':
        if profile.startswith('kcc-'):
            return 'link_missing_umoddi3'
        return 'step_limit' if profile.endswith('-o0') else 'pass'
    if name=='pdp10-original-prime-interval-v1':
        return ('assertion_failure' if profile=='gcc-pdp6-o0'
                else 'step_limit')
    raise ValueError('unknown source '+name)


def status_for(kind):
    if kind=='pass':return 'pass'
    if kind=='link_missing_umoddi3':return 'link_fail'
    return 'run_fail'


def reference_errors():
    errors=[]
    names={n:(ROOT/source(n)).read_text(encoding='ascii') for n,_,_ in ENTRIES}
    enum=names['pdp10-enum-bitfield-policy-v1']
    expected=222 & 255
    if expected!=222 or expected-256!=-34:
        errors.append('independent 8-bit enum model is inconsistent')
    for required in ('enum code_v1 { AMBIG_CONV_V1 = 222 }',
                     'signed int signed_code : 8',
                     'unsigned int unsigned_code : 8',
                     'enum code_v1 enum_code : 8',
                     'observed_enum_v1 != 222 && observed_enum_v1 != -34',
                     'case AMBIG_CONV_V1:', 'case -34:'):
        if required not in enum:
            errors.append('lost explicit signed/unsigned enum policy: '+required)
    ident=names['pdp10-label-offset-identity-v1']
    direct=names['pdp10-label-direct-dispatch-v1']
    for required in ('labels[i] - base','base + displacement != labels[i]',
                     'short displacement;'):
        if required not in ident:
            errors.append('lost bounded short label offset identity: '+required)
    for required in ('goto *labels[0];', 'goto *labels[sequence[next++]];',
                     'static const unsigned int sequence[4] = {1U, 0U, 1U, 2U}',
                     '"xyxyz"'):
        if required not in direct:
            errors.append('lost bounded direct computed goto control: '+required)
    sequence=['x']
    for n in (1,0,1,2):sequence.append(('x','y','z')[n])
    if ''.join(sequence)!='xyxyz':
        errors.append('wrong original independent branch sequence')
    # Exact reference of original facts() under unsigned 71-bit C
    # arithmetic: (a*b) wraps modulo 2**71 before division/remainder.
    mask=(1<<71)-1
    def powmod(b,e,m):
        power=b
        for i in range(e.bit_length()-2,-1,-1):
            power=((power*power)&mask)%m
            if e&(1<<i):power=((power*b)&mask)%m
        return power
    t=(1<<27)-1
    a=mask
    x=y=3
    q=1
    j=1
    jj=0
    found=[]
    for i in range(1,10000):
        x=(powmod(x,27,t)+a)&mask
        y=(powmod(y,27,t)+a)&mask
        y=(powmod(y,27,t)+a)&mask
        q=((q*abs(x-y))&mask)%t
        if i==j:
            jj+=1
            j+=jj
            factor=math.gcd(q,t)
            if factor!=1:
                found.append((i,factor))
                t//=factor
                if t==1:break
    if found!=[(1,7),(4,73),(277,262657)]:
        errors.append('incorrect independent 71-bit Pollard reference')
    pollard=names['pdp10-pollard-factor-original-v1']
    for required in ('facts_v1((1ULL << 27) - 1ULL, -1, 3, 27U)',
                     'power * power % m','powmod_ll_v1(x, p, t) + a',
                     'factab_v1[0] != 7UL','factab_v1[1] != 73UL',
                     'factab_v1[2] != 262657UL',
                     'for (i = 1; i < 10000; i++)'):
        if required not in pollard:
            errors.append('original factor-search operation lost: '+required)
    start=1234111111
    stop=1234111127
    expected_primes=[]
    for value in range(start,stop+1,2):
        if all(value%d for d in range(3,math.isqrt(value)+1,2)):
            expected_primes.append(value)
    if expected_primes!=[1234111117,1234111121,1234111127]:
        errors.append('incorrect independent prime interval reference')
    primes=names['pdp10-original-prime-interval-v1']
    for required in ('str2llu_v1("1234111111")',
                     'str2llu_v1("1234111127")',
                     'sqrtllu_v1(p)',
                     'p % d == 0ULL',
                     'count != 3',
                     'prime_results_v1[0] != 1234111117ULL',
                     'prime_results_v1[1] != 1234111121ULL',
                     'prime_results_v1[2] != 1234111127ULL'):
        if required not in primes:
            errors.append('original prime interval operation lost: '+required)
    return errors


def check_payload(blob,row):
    problems=[]
    for value in ('SOURCE: %s\n'%row['source'],
                  'SHA256: %s\n'%row['source_sha256'],
                  'PROFILE: %s\n'%row['profile'],
                  'STATUS: %s\n'%row['status'],
                  'KIND: %s\n'%row['kind']):
        if value.encode('ascii') not in blob:
            problems.append('missing original captured identity: '+value.strip())
    text=blob.decode('utf-8','replace')
    kind=row['kind']
    if kind=='pass':
        if 'PASS tests_' not in text or '--expect __test_exit=0' not in text:
            problems.append('no real guest PASS')
    elif kind=='link_missing_umoddi3':
        if ('dlink: undefined symbol: __kcc_umoddi3' not in text or
                'p10run: link failed' not in text):
            problems.append('missing real KCC unsigned modulo linker failure')
    elif kind=='step_limit':
        if 'Step expired, PC:' not in text or 'FAIL: __test_exit:' not in text:
            problems.append('missing real guest instruction limit')
    elif kind=='assertion_failure':
        result=re.search(r'FAIL: fail_id: got ([0-7]+) expected [0-7]+',text)
        if ('FAIL: __test_exit: got ' not in text or result is None or
                int(result.group(1),8)!=1 or
                row['fail_id_octal']!=result.group(1)):
            problems.append('missing numeric prime assertion (checkpoint 1)')
    else:
        problems.append('unsupported evidence status '+kind)
    if kind!='assertion_failure' and row['fail_id_octal']:
        problems.append('nonassertion cannot claim a numeric fail_id')
    return problems


def capture():
    sys.path.insert(0,str(ROOT/'tools'))
    spec=importlib.util.spec_from_file_location('matrix_runner',
                                                ROOT/'tools/run-tests.py')
    runner=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    output=Path(os.environ.get('TMPDIR') or Path.home()/'tmp')/MATRIX_DIR
    originals={Path(r['classified_path']).stem:r for r in read(HIST)}
    entries=[]
    archive={}
    for n,(name,original,kcc) in enumerate(ENTRIES,1):
        src=source(name)
        digest=hashlib.sha256((ROOT/src).read_bytes()).hexdigest()
        for profile in runner.all_profiles():
            if profile['machine']!='pdp6' or profile['family']!='native':continue
            if profile['compiler']=='kcc' and not kcc:continue
            kind=kind_for(name,profile['profile'])
            cell=dict(profile,kind='semantic')
            actual=runner.read_cell_status(output,src,cell)
            if actual is None or actual['status']!=status_for(kind):
                raise ValueError('real matrix observation missing: '+src+' '+
                                 profile['profile']+' '+repr(actual))
            folder=runner.cell_dir(output,src,cell)
            log=(folder/'cell.log').read_bytes()
            reports=sorted((folder/'run').glob('*.report.txt'))
            if len(reports)>1:
                raise ValueError('ambiguous original guest report: '+str(folder))
            for report in reports:
                log+=b'\n=== GUEST REPORT ===\n'+report.read_bytes()
            header=('SOURCE: %s\nSHA256: %s\nPROFILE: %s\nSTATUS: %s\n'
                    'KIND: %s\n\n'%(src,digest,profile['profile'],
                                     actual['status'],kind)).encode('ascii')
            blob=header+log
            checkpoint=''
            if kind=='assertion_failure':
                item=re.search(rb'FAIL: fail_id: got ([0-7]+)',blob)
                if not item:raise ValueError('no numeric assertion reached')
                checkpoint=item.group(1).decode('ascii')
            member='source%02d/%s-v1.log'%(n,profile['profile'])
            row=dict(original_source=originals[original]['classified_path'],
                     source=src,source_sha256=digest,
                     profile=profile['profile'],status=actual['status'],
                     kind=kind,fail_id_octal=checkpoint,
                     evidence_sha256=hashlib.sha256(blob).hexdigest(),
                     archive_member=member)
            errors=check_payload(blob,row)
            if errors:raise ValueError('; '.join(errors)+' '+src)
            entries.append(row)
            archive[member]=blob
    if len(entries)!=28:raise ValueError('wrong normal matrix cell count')
    with LEDGER.open('w',encoding='ascii',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=FIELDS,delimiter='\t',
                              lineterminator='\n')
        writer.writeheader()
        writer.writerows(entries)
    with ARCHIVE.open('wb') as f:
        with gzip.GzipFile(fileobj=f,mode='wb',mtime=0) as gz:
            with tarfile.open(fileobj=gz,mode='w') as t:
                for name,blob in sorted(archive.items()):
                    item=tarfile.TarInfo(name)
                    item.size=len(blob)
                    item.mtime=0
                    item.mode=0o644
                    t.addfile(item,io.BytesIO(blob))
    print('CAPTURED %d real PDP6 matrix profiles'%len(entries))


def audit(ledger=LEDGER,archive=ARCHIVE):
    errors=reference_errors()
    originals={Path(r['classified_path']).stem:r for r in read(HIST)}
    matrix={r['test']:r for r in read(MATRIX)}
    expect={}
    for n,(name,original,kcc) in enumerate(ENTRIES,1):
        original_row=originals[original]
        original_path=original_row['classified_path']
        if (hashlib.sha256((ROOT/original_path).read_bytes()).hexdigest()
                !=original_row['source_sha256']):
            errors.append('historical upstream original changed: '+original_path)
        src=source(name)
        digest=hashlib.sha256((ROOT/src).read_bytes()).hexdigest()
        registration=matrix.get(src)
        if registration is None:
            errors.append('normal matrix registration missing: '+src)
            continue
        for profile in profiles(kcc):
            compiler,_,opt=profile.split('-')
            column='pdp6' if compiler=='kcc' else 'pdp6_gcc_'+opt
            if registration.get(column) not in ('semantic','fail','timeout'):
                errors.append('missing active matrix compiler profile: '+src+' '+profile)
            expect[(src,profile)]=(n,original_path,digest,kind_for(name,profile))
    try:
        records=read(ledger)
        if len(records)!=28 or records and tuple(records[0])!=FIELDS:
            errors.append('wrong source/profile result schema or count')
        seen=set()
        names=set()
        with tarfile.open(archive,'r:gz') as t:
            files={item.name:item for item in t.getmembers()}
            for row in records:
                key=(row['source'],row['profile'])
                if key in seen or key not in expect:
                    errors.append('unknown/duplicated profile '+str(key))
                    continue
                seen.add(key)
                n,original,digest,kind=expect[key]
                member='source%02d/%s-v1.log'%(n,row['profile'])
                names.add(member)
                item=files.get(member)
                if (row['original_source']!=original or
                        row['source_sha256']!=digest or
                        row['status']!=status_for(kind) or
                        row['kind']!=kind or
                        row['archive_member']!=member or
                        item is None or not item.isfile()):
                    errors.append('original source/profile result changed: '+str(key))
                    continue
                file=t.extractfile(item)
                blob=file.read() if file else b''
                if hashlib.sha256(blob).hexdigest()!=row['evidence_sha256']:
                    errors.append('original simulator log checksum changed: '+str(key))
                errors.extend(check_payload(blob,row))
            if seen!=set(expect) or names!=set(files):
                errors.append('incomplete/extra archived compiler profile')
    except (OSError,KeyError,ValueError,tarfile.TarError) as exc:
        errors.append('unable to audit historical execution log: '+str(exc))
    return errors


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--capture',action='store_true')
    args=parser.parse_args()
    if args.capture:capture()
    issues=audit()
    for item in issues:print('ERROR:',item)
    print('P1 Batch 1 final semantic oracles: %s (28 native cells, %d issues)'%
          ('FAIL' if issues else 'PASS',len(issues)))
    return bool(issues)


if __name__=='__main__':
    sys.exit(main())
