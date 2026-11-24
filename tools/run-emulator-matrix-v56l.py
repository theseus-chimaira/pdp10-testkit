#!/usr/bin/env python3
"""Independent execution dimension of the canonical compiler test matrix.

Replay the *same* p10run deposit image on additional emulators. Do not
recompile or overwrite primary compiler checkpoints. Only actual guest
expectations count as a pass. Pending backends and missing images are
reported separately, not misclassified as compiler runtime failures.
"""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import csv
import hashlib
import importlib.util
import os
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
FIELDS = ('test', 'machine', 'compiler', 'profile', 'kind')
OUTPUT = FIELDS + ('emulator', 'address_model', 'status', 'primary_status',
                   'image_sha256', 'oracle_sha256', 'emulator_sha256',
                   'report', 'detail')


def sha(data):
    return hashlib.sha256(data).hexdigest()


def capabilities():
    with (ROOT/'EMULATOR_MATRIX.tsv').open() as f:
        rows = list(csv.DictReader((s for s in f if not s.startswith('#')), delimiter='\t'))
    keys = [(r['cpu'],r['address_model'],r['emulator']) for r in rows]
    if len(set(keys)) != len(keys):
        raise ValueError('duplicate emulator capability')
    for r in rows:
        if r['state'] not in ('active','pending_profile','pending_adapter'):
            raise ValueError('unknown backend state')
        if r['state']=='active' and r['adapter'] not in ('primary','klh10-local'):
            raise ValueError('active backend has no implemented adapter')
        if r['adapter']=='klh10-local' and (r['emulator']!='klh10' or r['address_model']!='local'):
            raise ValueError('invalid KLH10 local adapter mapping')
    return rows


def canonical_cells():
    spec = importlib.util.spec_from_file_location('compiler_matrix', ROOT/'tools/run-tests.py')
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    cells, _, missing, ignored = m.build_cells(m.split_rows(), m.all_profiles(), 'semantic')
    if missing or ignored:
        raise ValueError(f'invalid compiler matrix: {missing}, {ignored}')
    return {(src,c['machine'],c['compiler'],c['profile'],c['kind']):c for src,c in cells}


def executable(cap):
    return Path(os.environ.get(cap['override_env']) or
                Path(os.environ['PDP10_PREFIX'])/'bin'/cap['executable']).resolve()


def checkpoints(directory, admitted):
    found = {}
    for p in sorted((directory/'cells').glob('*/status')):
        r = dict(line.split('=',1) for line in p.read_text().splitlines()
                 if '=' in line and not line.startswith('#'))
        if r.get('kind') != 'semantic':
            continue
        key = tuple(r.get(k,'') for k in FIELDS)
        if key not in admitted or key in found:
            raise ValueError(f'unregistered or duplicate checkpoint: {p}')
        found[key] = (r,p.parent)
    if not found:
        raise ValueError(f'no semantic checkpoints in {directory}')
    return found


def image_contract(cell, directory):
    # Only replay the simple, explicitly physical local deposit format.
    # Reject any unrecognized command instead of silently skipping it.
    scripts = list((directory/'run').glob('*-run.ini'))
    images = list((directory/'run').glob('*.simh'))
    if len(scripts)!=1 or len(images)!=1:
        raise ValueError('missing or ambiguous linked deposit image')
    raw = images[0].read_bytes()
    memory = {}
    for line in raw.decode('ascii').splitlines():
        m = re.fullmatch(r'deposit ([0-7]+) ([0-7]+)',line)
        if not m:
            raise ValueError('unsupported image command: '+line)
        addr,word = (int(v,8) for v in m.groups())
        if addr in memory or addr >= 1<<18 or word >= 1<<36:
            raise ValueError('invalid/duplicate local deposit')
        memory[addr] = word
    script = scripts[0].read_text(encoding='ascii')
    loads = re.findall(r'^do (.+)$',script,re.M)
    if len(loads)!=1 or Path(loads[0]).name!=images[0].name:
        raise ValueError('script does not load the selected deposit image')
    entry = re.findall(r'^deposit PC ([0-7]+)$',script,re.M)
    if len(entry)!=1 or int(entry[0],8) not in memory:
        raise ValueError('invalid entry')
    expects = re.findall(r'^echo __P10RUN_EXPECT__ (\S+) ([0-7]+) ([0-7]+)\nexamine \2$',script,re.M)
    if len(expects)!=script.count('echo __P10RUN_EXPECT__ ') or not expects:
        raise ValueError('missing or unsupported expectation')
    values = {int(a,8):int(w,8) for _,a,w in expects}
    if len(values)!=len(expects) or any(a>=1<<18 or w>=1<<36 for a,w in values.items()):
        raise ValueError('invalid/duplicate expectation')
    if not any(n=='__test_exit' for n,_,_ in expects):
        raise ValueError('missing guest exit oracle')
    # Only zero destination HALT is supported by the local C startup.
    if 0o254200000000 not in memory.values():
        raise ValueError('no explicit guest HALT in image')
    oracle = '\n'.join(' '.join(x) for x in expects).encode('ascii')
    return memory,int(entry[0],8),values,sha(raw),sha(oracle)


def klh10_local(exe, work, memory, entry, expected, timeout):
    script = work/'replay.ini'
    # Zero-filled BSS and all untouched memory are part of the original
    # image contract. Fresh processes guarantee no previous guest state.
    lines = [f'deposit P{a:o} {w:012o}' for a,w in sorted(memory.items())]
    lines += [f'go {entry:o}']+[f'examine P{a:o}' for a in expected]+['quit','']
    script.write_text('\n'.join(lines),encoding='ascii')
    log = work/'replay.log'
    try:
        with log.open('wb') as out:
            p = subprocess.run([str(exe),str(script)],cwd=work,stdin=subprocess.DEVNULL,
                               stdout=out,stderr=subprocess.STDOUT,timeout=timeout)
    except subprocess.TimeoutExpired:
        return 'emulator_timeout','wall timeout',log
    s = log.read_text(encoding='ascii',errors='replace')
    halts = re.findall(r'\[HALTED: Program Halt, PC = ([0-7]+)\]',s)
    if p.returncode or len(halts)!=1 or int(halts[0],8)!=0:
        return 'emulator_stop','missing expected HALT',log
    if re.search(r'(?im)^\s*(?:\?[^\n]*|error:|invalid |unknown command)',s):
        return 'backend_error','monitor command error',log
    got = {}
    for m in re.finditer(r'^[ \t]*(?:P[ \t]+)?([0-7]+)/[ \t]+([0-7]+)(?:,,([0-7]+))?',s,re.M):
        addr=int(m[1],8)
        val=int(m[2],8) if m[3] is None else (int(m[2],8)<<18)|int(m[3],8)
        if addr in got:
            return 'backend_error','duplicate examine output',log
        got[addr]=val
    if set(expected)-set(got):
        return 'backend_error','missing examine output',log
    bad=[f'{a:o}: {got[a]:012o} != {w:012o}' for a,w in expected.items() if got[a]!=w]
    return ('run_fail' if bad else 'pass'),'; '.join(bad),log


def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--from-dir',type=Path,help='existing compiler sweep checkpoints (unchanged)')
    ap.add_argument('--out-dir',type=Path,required=True,help='new independent execution result directory')
    ap.add_argument('--emulator',choices=('all','simh','klh10','kx10','ts10'),default='all')
    ap.add_argument('--cpu',choices=('all','pdp6','ka10','ki10','ks10','kl10a','kl10b'),default='all')
    ap.add_argument('--plan',action='store_true',help='list every eligible canonical semantic cell; do not execute')
    ap.add_argument('-j',type=int,default=1)
    ap.add_argument('--timeout',type=int,default=20)
    args=ap.parse_args()
    if args.j<1 or args.timeout<1 or not (args.plan or args.from_dir):
        ap.error('positive jobs/timeout and --plan or --from-dir required')
    caps=[c for c in capabilities() if args.emulator in ('all',c['emulator']) and args.cpu in ('all',c['cpu'])]
    admitted=canonical_cells()
    source={} if args.plan else checkpoints(args.from_dir,admitted)
    selected=admitted if args.plan else source
    out=args.out_dir.resolve()
    out.mkdir(parents=True,exist_ok=False)
    with (out/'capabilities.tsv').open('w') as f:
        fields=list(caps[0]) if caps else list(capabilities()[0])
        w=csv.DictWriter(f,fieldnames=fields+['executable_present','compiler_cells'],delimiter='\t',lineterminator='\n');w.writeheader()
        for c in caps:
            w.writerow(dict(c,executable_present=int(executable(c).is_file()),compiler_cells=sum(k[1]==c['cpu'] for k in admitted)))
    tasks=[]
    for key in sorted(selected):
        for cap in caps:
            if key[1]==cap['cpu'] and cap['address_model']=='local':
                tasks.append((key,cap))
    if not tasks and not args.plan:
        ap.error('no supported runtime cell selected; see capabilities.tsv')
    bins={}
    for c in caps:
        e=executable(c)
        if e.is_file() and os.access(e,os.X_OK):
            bins[(c['cpu'],c['emulator'])]=(e,sha(e.read_bytes()))

    def run(task):
        key,cap=task
        row=dict(zip(FIELDS,key),emulator=cap['emulator'],address_model=cap['address_model'],status='not_run')
        if args.plan:
            row['status']='planned' if cap['state']=='active' else cap['state'];return row
        cell,directory=source[key]
        row['primary_status']=cell['status']
        if cap['adapter']=='primary':
            # Report existing result as provenance, never a fresh replay.
            row.update(status='primary_recorded',report=cell.get('report',''));return row
        if cap['state']!='active':
            row['status']=cap['state'];return row
        tool=bins.get((cap['cpu'],cap['emulator']))
        if tool is None:
            row['status']='backend_unavailable';return row
        if cell['status'] not in ('pass','run_fail','timeout'):
            row['status']='no_runtime_image';return row
        try:
            memory,entry,expected,image_hash,oracle_hash=image_contract(cell,directory)
            work=out/'cells'/directory.name/cap['emulator'];work.mkdir(parents=True)
            exe,exe_hash=tool
            row.update(image_sha256=image_hash,oracle_sha256=oracle_hash,emulator_sha256=exe_hash)
            status,detail,log=klh10_local(exe,work,memory,entry,expected,args.timeout)
            row.update(status=status,detail=detail,report=str(log))
        except (OSError,ValueError,UnicodeError) as e:
            row.update(status='backend_error',detail=str(e))
        return row

    counts=Counter()
    with (out/'results.tsv').open('w') as f, ThreadPoolExecutor(max_workers=args.j) as pool:
        w=csv.DictWriter(f,fieldnames=OUTPUT,delimiter='\t',lineterminator='\n');w.writeheader()
        for i,row in enumerate(pool.map(run,tasks),1):
            w.writerow(row);f.flush();counts[row['emulator'],row['status']]+=1
            if i%(10000 if args.plan else 44)==0 or i==len(tasks):print(f'{i}/{len(tasks)} {dict(counts)}',flush=True)
    print('results:',out/'results.tsv',flush=True)
    for (emu,status),n in sorted(counts.items()):print(f'{emu}\t{status}\t{n}')
    return int(any(s in ('run_fail','backend_error','emulator_stop','emulator_timeout','backend_unavailable') for _,s in counts))


if __name__=='__main__':
    raise SystemExit(main())
