#!/usr/bin/env python3
"""Audit archived compiler output without recompiling C or editing checkpoints.

Compare only matching source/compiler/machine/profile-family within one run.
DOBJ section extents are target words, not host file sizes. Speed is SIMH
time units, not hardware cycles. Failed cells are never speed benchmarks.
"""
import argparse
import collections
import csv
import hashlib
import os
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import re
import struct
import subprocess
import tempfile

FIELDS = ['run', 'test', 'compiler', 'machine', 'family', 'opt', 'kind',
          'status', 'asm', 'object', 'size_status', 'text', 'data', 'bss',
          'words', 'library', 'ini', 'report', 'ticks', 'speed_status']
MAGIC = 0
for ch in 'DOBJ1 ':
    MAGIC = (MAGIC << 6) | (ord(ch) - 32)
SIM = {'pdp6': 'pdp6', 'ka10': 'pdp10-ka', 'ki10': 'pdp10-ki',
       'ks10': 'pdp10-ks'}
PASS = {'pass', 'compile_only', 'ok'}

# One definition drives comparisons, replay selection and acceptance.
# Text words are diagnostic; total object words are the RAM-size criterion.
KCC_RULES = (('noopt', 'opt', 'words', 'strict'),
             ('noopt', 'opt', 'text', 'diagnostic'))
GCC_RULES = (('o0', 'o1', 'ticks', 'strict'),
             ('o1', 'o2', 'ticks', 'nonincreasing'),
             ('os', 'o2', 'ticks', 'nonincreasing'),
             ('o0', 'os', 'ticks', 'strict'),
             ('o0', 'os', 'words', 'strict'),
             ('o0', 'os', 'text', 'diagnostic'))


def acceptance(verdict, rule):
    if rule == 'diagnostic':
        return 'diagnostic'
    if verdict == 'improved':
        return 'pass'
    if verdict == 'equal':
        return 'pass' if rule == 'nonincreasing' else 'fail'
    if verdict == 'regressed':
        return 'fail'
    return 'unverified'



def read_object(path):
    with path.open('rb') as f:
        h = struct.unpack('<5Q', f.read(40))
    if h[0] != MAGIC or any(x >> 36 for x in h):
        raise ValueError('invalid DOBJ1 header')
    text, data, bss = h[1] >> 18, h[1] & 0o777777, h[2] >> 18
    if path.stat().st_size < 8 * (5 + text + data):
        raise ValueError('truncated DOBJ1 sections')
    return text, data, bss


def checkpoint(path):
    return dict(line.rstrip('\n').split('=', 1)
                for line in path.read_text(errors='replace').splitlines()
                if '=' in line and not line.startswith('#'))


def scan(root, prefix, reassemble):
    for run in sorted(root.iterdir()):
        if not (run / 'cells').is_dir():
            continue
        print('Scan', run.name, flush=True)
        for cell in (run / 'cells').iterdir():
            p = cell / 'status'
            if not p.is_file():
                continue
            r = checkpoint(p)
            asm = Path(r.get('asm') or '.')
            if not asm.is_file():
                continue
            prof = r.get('profile', '').rsplit('-', 1)
            if len(prof) != 2:
                continue
            row = dict(run=run.name, test=r['test'], compiler=r['compiler'],
                       machine=r['machine'], family=prof[0], opt=prof[1],
                       kind=r['kind'], status=r['status'], asm=str(asm),
                       library=r.get('runtime_library_sha256', ''),
                       report=r.get('report', ''), size_status='missing',
                       speed_status='not_measured')
            # p10run puts the primary test assembly after crt0. Match its
            # exact basename, not the startup or auxiliary library objects.
            obj = cell / 'run' / ('p10run-002-' + asm.stem + '.dobj')
            try:
                if obj.is_file() and obj.stat().st_mtime_ns >= asm.stat().st_mtime_ns:
                    sizes = read_object(obj)
                    row.update(object=str(obj), size_status='archived')
                elif reassemble:
                    with tempfile.TemporaryDirectory(prefix='object-v1-') as d:
                        dest = Path(d) / 'test.dobj'
                        proc = subprocess.run([str(prefix / 'bin/pdp10-dec-none-as'),
                                               '-c', '-o', str(dest), str(asm)],
                                              stdout=subprocess.DEVNULL,
                                              stderr=subprocess.DEVNULL, timeout=30)
                        if proc.returncode:
                            raise ValueError('assembler failed')
                        sizes = read_object(dest)
                    row.update(size_status='reassembled')
                else:
                    sizes = None
                if sizes is not None:
                    row.update(zip(('text', 'data', 'bss'), sizes))
                    row['words'] = sum(sizes)
            except (OSError, ValueError, struct.error, subprocess.TimeoutExpired):
                row['size_status'] = 'invalid_or_assembly_failed'
            if row['status'] == 'pass' and row['kind'] == 'semantic':
                ini = list((cell / 'run').glob('*-run.ini'))
                if len(ini) == 1 and ini[0].stat().st_mtime_ns >= asm.stat().st_mtime_ns:
                    row['ini'] = str(ini[0])
            yield row


def assemble_missing(row, prefix):
    if row['size_status'] not in ('missing', 'invalid_or_assembly_failed'):
        return
    try:
        with tempfile.TemporaryDirectory(prefix='object-v1-') as d:
            dest = Path(d) / 'test.dobj'
            proc = subprocess.run([str(prefix / 'bin/pdp10-dec-none-as'),
                                   '-c', '-o', str(dest), row['asm']],
                                  stdout=subprocess.DEVNULL,
                                  stderr=subprocess.DEVNULL, timeout=30)
            if proc.returncode:
                raise ValueError('assembler failed')
            sizes = read_object(dest)
        row.update(zip(('text', 'data', 'bss'), sizes))
        row.update(words=sum(sizes), size_status='reassembled')
    except (OSError, ValueError, struct.error, subprocess.TimeoutExpired):
        row['size_status'] = 'invalid_or_assembly_failed'


def write_table(path, fields, rows):
    with path.open('w', newline='') as f:
        w = csv.DictWriter(f, fields, extrasaction='ignore',
                           delimiter='\t', lineterminator='\n')
        w.writeheader()
        for row in rows:
            w.writerow(row)


def read_table(path):
    with path.open(newline='') as f:
        return list(csv.DictReader(f, delimiter='\t'))


def group_key(r):
    return tuple(r[k] for k in ('run', 'test', 'compiler', 'machine',
                                'family', 'kind'))


def groups(rows):
    out = collections.defaultdict(dict)
    for r in rows:
        out[group_key(r)][r['opt']] = r
    return out


def result(old, new):
    if old in ('', None) or new in ('', None):
        return 'missing'
    old, new = int(old), int(new)
    return 'improved' if new < old else 'equal' if new == old else 'regressed'


def comparisons(rows):
    for key, g in groups(rows).items():
        specs = KCC_RULES if key[2] == 'kcc' else GCC_RULES
        for a, b, metric, rule in specs:
            if a not in g or b not in g:
                continue
            old, new = g[a], g[b]
            val0, val1 = old.get(metric, ''), new.get(metric, '')
            verdict = result(val0, val1)
            if old['status'] not in PASS or new['status'] not in PASS:
                verdict = 'correctness_unverified'
            if metric == 'ticks' and (not old['library'] or
                                      old['library'] != new['library']):
                verdict = 'library_unverified'
            yield dict(zip(('run', 'test', 'compiler', 'machine', 'family', 'kind'), key),
                       baseline=a, candidate=b, metric=metric, before=val0,
                       after=val1, verdict=verdict, raw_verdict=result(val0, val1),
                       rule=rule, acceptance=acceptance(verdict, rule),
                       before_status=old['status'], after_status=new['status'],
                       before_text=old.get('text', ''), after_text=new.get('text', ''))


def replay(row, prefix, timeout):
    """Use the saved linked image and original test expectations."""
    ini = Path(row['ini'])
    lines = ini.read_text().splitlines()
    script = []
    count = 0
    for line in lines:
        if re.match(r'^(step|go|run)\s', line, re.I):
            script.append('show time')
            count += 1
        script.append(line)
        if line == 'echo __P10RUN_AFTER_RUN__':
            script.append('show time')
    if count != 1 or 'echo __P10RUN_AFTER_RUN__' not in lines:
        raise ValueError('unsupported saved run script')
    # Only replay generated deposit scripts with the original oracle.
    if not any(x.startswith('echo __P10RUN_EXPECT__ __test_exit ') for x in lines):
        raise ValueError('missing termination oracle')
    with tempfile.TemporaryDirectory(prefix='replay-v1-') as d:
        p = Path(d) / 'run.ini'
        p.write_text('\n'.join(script) + '\n')
        proc = subprocess.run([str(prefix / 'bin' / SIM[row['machine']]), str(p)],
                              stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                              timeout=timeout, text=True, errors='replace')
    out = proc.stdout
    times = re.findall(r'^Time:\s*(\d+)\s*$', out, re.M)
    if proc.returncode or len(times) != 2 or 'HALT instruction' not in out:
        raise ValueError('replay did not halt normally')
    for line in lines:
        m = re.match(r'echo __P10RUN_EXPECT__ (\S+) ([0-7]+) ([0-7]+)$', line)
        if m:
            name, addr, expected = m.groups()
            # Match the actual value printed following this oracle marker.
            pattern = (r'__P10RUN_EXPECT__ ' + re.escape(name) +
                       r' [0-7]+ [0-7]+\s*\n\s*0*' +
                       re.escape(addr.lstrip('0') or '0') +
                       r':\s*([0-7]+)')
            actual = re.search(pattern, out)
            if not actual or int(actual.group(1), 8) != int(expected, 8):
                raise ValueError('replay oracle failed: ' + name)
    ticks = int(times[1]) - int(times[0])
    if ticks <= 0:
        raise ValueError('invalid simulated time delta')
    return ticks


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--workdir', type=Path, default=Path('workdir'))
    ap.add_argument('--out-dir', type=Path, required=True)
    ap.add_argument('--resume', action='store_true')
    ap.add_argument('--reassemble', action='store_true')
    ap.add_argument('--replay-limit', type=int, default=0,
                    help='maximum saved-image replays per invocation')
    ap.add_argument('--run', action='append', help='limit speed replay to these runs')
    ap.add_argument('--timeout', type=int, default=20)
    ap.add_argument('-j', '--jobs', type=int, default=1)
    args = ap.parse_args()
    if args.jobs < 1 or args.replay_limit < 0:
        ap.error('jobs must be positive and replay limit nonnegative')
    prefix = Path(os.environ['PDP10_PREFIX']).resolve()
    os.environ.setdefault('TMPDIR', str(Path.home() / 'tmp'))
    Path(os.environ['TMPDIR']).mkdir(parents=True, exist_ok=True)
    args.out_dir.mkdir(parents=True, exist_ok=True)
    table = args.out_dir / 'cells.tsv'
    if args.resume:
        rows = read_table(table)
        if args.reassemble:
            pending = [r for r in rows if r['size_status'] in ('missing', 'invalid_or_assembly_failed')]
            print('Reassemble missing objects:', len(pending), flush=True)
            with ThreadPoolExecutor(max_workers=args.jobs) as pool:
                for n, _ in enumerate(pool.map(lambda r: assemble_missing(r, prefix), pending), 1):
                    if n % 100 == 0:
                        print('Reassembled/attempted:', n, flush=True)
    else:
        if table.exists():
            ap.error('output exists; use --resume or a versioned output directory')
        rows = list(scan(args.workdir, prefix, args.reassemble))
        write_table(table, FIELDS, rows)
    speed_table = args.out_dir / 'speed-replay.tsv'
    if args.replay_limit:
        ident = args.out_dir / 'simulator-sha256.tsv'
        hashes = {machine: hashlib.sha256((prefix / 'bin' / binary).read_bytes()).hexdigest()
                  for machine, binary in SIM.items()}
        content = ''.join(machine + '\t' + h + '\n'
                          for machine, h in sorted(hashes.items()))
        if ident.exists() and ident.read_text() != content:
            ap.error('simulator builds changed; use a new output directory')
        ident.write_text(content)
    speed_fields = ['run', 'test', 'compiler', 'machine', 'family', 'kind',
                    'opt', 'ticks', 'speed_status']
    if speed_table.is_file():
        saved = {(group_key(r), r['opt']): r for r in read_table(speed_table)}
        for r in rows:
            old = saved.get((group_key(r), r['opt']))
            if old:
                r.update(ticks=old['ticks'], speed_status=old['speed_status'])
    print('Assembly cells:', len(rows), flush=True)
    print('Size coverage:', collections.Counter(r['size_status'] for r in rows), flush=True)
    # Prioritize complete successful comparison groups, newest run names
    # are not proof of compiler provenance; never mix across run directories.
    selected = []
    for key, g in groups(rows).items():
        if len(selected) >= args.replay_limit:
            break
        if key[2] != 'gcc' or key[5] != 'semantic':
            continue
        if args.run and key[0] not in args.run:
            continue
        available = set()
        for a, b, metric, rule in GCC_RULES:
            if metric != 'ticks':
                continue
            if all(o in g and g[o].get('ini') and g[o]['status'] == 'pass'
                   for o in (a, b)) and g[a]['library'] and g[a]['library'] == g[b]['library']:
                available.update((a, b))
        for opt in ('o0', 'o1', 'o2', 'os'):
            if opt not in available:
                continue
            r = g[opt]
            if len(selected) >= args.replay_limit:
                break
            if r['speed_status'] != 'not_measured':
                continue
            selected.append(r)

    def measure(r):
        try:
            r['ticks'] = replay(r, prefix, args.timeout)
            r['speed_status'] = 'measured'
        except (OSError, ValueError, subprocess.TimeoutExpired) as e:
            r['speed_status'] = 'replay_failed: ' + str(e)
        return r

    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        for n, r in enumerate(pool.map(measure, selected), 1):
            exists = speed_table.is_file()
            with speed_table.open('a', newline='') as f:
                w = csv.DictWriter(f, speed_fields, extrasaction='ignore',
                                   delimiter='\t', lineterminator='\n')
                if not exists:
                    w.writeheader()
                w.writerow(r)
            print('Replay', n, r['run'], r['test'], r['machine'], r['family'],
                  r['opt'], r.get('ticks', ''), r['speed_status'], flush=True)
    temp = table.with_suffix('.new')
    write_table(temp, FIELDS, rows)
    temp.replace(table)
    comp = list(comparisons(rows))
    fields = ['run','test','compiler','machine','family','kind','baseline',
              'candidate','metric','before','after','verdict','raw_verdict',
              'before_status','after_status','before_text','after_text',
              'rule','acceptance']
    write_table(args.out_dir / 'comparisons.tsv', fields, comp)
    counts = collections.Counter((r['compiler'],r['baseline'],r['candidate'],
                                  r['metric'],r['verdict']) for r in comp)
    with (args.out_dir / 'summary.txt').open('w') as f:
        for key, n in sorted(counts.items()):
            print(*key, n, sep='\t', file=f)
            print(*key, n, sep='\t')
    required = [r for r in comp if r['rule'] != 'diagnostic']
    policy = collections.Counter((r['compiler'], r['baseline'], r['candidate'],
                                  r['metric'], r['acceptance']) for r in required)
    with (args.out_dir / 'acceptance-summary.tsv').open('w') as f:
        print('compiler', 'baseline', 'candidate', 'metric', 'acceptance',
              'count', sep='\t', file=f)
        for key, n in sorted(policy.items()):
            print(*key, n, sep='\t', file=f)
    write_table(args.out_dir / 'acceptance-failures.tsv', fields,
                (r for r in required if r['acceptance'] == 'fail'))
    print('Archive provenance: per-run pairing only; historic compiler hashes not recorded.')
    print('Speed coverage:', collections.Counter(r['speed_status'] for r in rows))


if __name__ == '__main__':
    main()
