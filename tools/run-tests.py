#!/usr/bin/env python3
from __future__ import print_function
import argparse
import csv
import multiprocessing
import os
import re
import shutil
import shlex
import signal
import subprocess
import sys
import time
from pathlib import Path
from stubselect import STUB_SYMBOLS, selected_test_stubs

ROOT = Path(__file__).resolve().parents[1]


def required_prefix():
    val = os.environ.get('PDP10_PREFIX')
    if not val:
        print('ERROR: PDP10_PREFIX must be set', file=sys.stderr)
        sys.exit(2)
    return Path(val).expanduser()


PDP10_PREFIX = required_prefix()
DEFAULT_OUTROOT = ROOT / 'workdir' / 'full-sweep-current'
MACHINES = ('pdp6', 'ka10', 'ki10', 'ks10')
GCC_OPTS = (('o0', '-O0'), ('o1', '-O1'), ('o2', '-O2'), ('os', '-Os'))
KCC_OPTS = (('opt', []), ('noopt', ['-n']))
COMPILE_TIMEOUT = int(os.environ.get('P10_SWEEP_COMPILE_TIMEOUT', '20'))
CELL_TIMEOUT = int(os.environ.get('P10_SWEEP_CELL_TIMEOUT', '20'))
P10_TIMEOUT = os.environ.get('P10_SWEEP_TIMEOUT', str(max(1, CELL_TIMEOUT - 2)))

# TEST_MATRIX.tsv is the only suite matrix.  Everything under workdir is a
# restart checkpoint or a report for the currently selected cells.
PASS_STATUSES = set(['pass', 'compile_only', 'ok'])
FAIL_STATUSES = set(['compile_fail', 'run_fail', 'timeout', 'policy_fail', 'setup_fail'])
SEMANTIC_MATRIX_STATUSES = set(['semantic', 'run', 'runtime', 'ok', 'pending', 'fail', 'timeout', 'error'])
CODEGEN_MATRIX_STATUSES = set(['codegen', 'ok', 'pending', 'fail', 'timeout', 'error'])
INACTIVE_MATRIX_STATUSES = set(['', 'no_test', 'unsupported', 'obsolete'])
STATUS_FIELDS = ['test', 'machine', 'compiler', 'profile', 'kind', 'status', 'elapsed', 'asm', 'report']
FAILURE_FIELDS = STATUS_FIELDS

FORBID_BASE = set('''
ADJBP ADJSP JFFO
DMOVE DMOVEM DMOVN DMOVNM
DFAD DFSB DFMP DFDV DFIX DFLTR
GFAD GFSB GFMP GFDV GFIX GFLTR
DDFIX GDFIX DDFLTR DGFLTR
FIX FIXR FLTR
XMOVEI XMOVEM XJRST XJEN XPCW XHLLI XHLLM XHLL XHLR XHRL XHRR
GSNGL GDBLE GSNGLR GDBLER
'''.split())
FORBID_PDP10 = FORBID_BASE - set(['JFFO'])
FORBID_KI10 = set('''
XMOVEI XMOVEM XJRST XJEN XPCW XHLLI XHLLM XHLL XHLR XHRL XHRR
'''.split())

DIRECTIVE_RE = re.compile(r'^\s*/\*\s*(codegen-[a-z-]+)\s*:\s*(.*?)\s*\*/\s*$')
LABEL_RE = re.compile(r'^\s*(?:[A-Za-z_.$%][A-Za-z0-9_.$%]*:\s*)?([A-Za-z][A-Za-z0-9_.]*)\b')
KCC_RUNTIME_SYMBOLS = ('$ADJBP', '$KDFAD', '$KDFSB', '$KDFMP', '$KDFDV', '$ZERO')
KCC_RUNTIME_MACHINE_STEMS = {
    '$ADJBP': 'adjbp',
    '$KDFAD': 'kdfad',
    '$KDFSB': 'kdfsb',
    '$KDFMP': 'kdfmp',
    '$KDFDV': 'kdfdv',
}
KCC_RUNTIME_COMMON_FILES = {
    '$ZERO': 'kccrt-zero.s',
}
KCC_RUNTIME_MACHINE_PREFIX = {
    'pdp6': 'pdp6rt',
    'ka10': 'ka10rt',
    'ki10': 'ka10rt',
    'ks10': 'ks10rt',
}


def die(msg):
    print('ERROR: ' + msg, file=sys.stderr)
    sys.exit(2)


def split_rows():
    with open(ROOT / 'TEST_MATRIX.tsv', 'r', encoding='utf-8', errors='replace') as f:
        reader = csv.DictReader((l for l in f if l.strip() and not l.startswith('#')), delimiter='\t')
        return list(reader)


def safe_name(s):
    s = s.replace('/', '_').replace('.c', '')
    return re.sub(r'[^A-Za-z0-9_.-]+', '_', s)


def read_text(path):
    try:
        return Path(path).read_text(errors='ignore')
    except OSError:
        return ''


def write_text(path, text):
    Path(path).write_text(text, encoding='utf-8')






def label_exists(asm_text, name):
    return re.search(r'(?m)^' + re.escape(name) + r':', asm_text) is not None


def needed_kcc_runtime_symbols(asm_text):
    return sorted(sym for sym in KCC_RUNTIME_SYMBOLS if sym in asm_text)


def runtime_defines_symbol(rt_text, name):
    return re.search(r'(?m)^\s*' + re.escape(name) + r'\s*:', rt_text) is not None


def kcc_runtime_fragment_name(machine, symbol):
    common = KCC_RUNTIME_COMMON_FILES.get(symbol)
    if common:
        return common
    stem = KCC_RUNTIME_MACHINE_STEMS.get(symbol)
    prefix = KCC_RUNTIME_MACHINE_PREFIX.get(machine)
    if stem is None or prefix is None:
        return None
    return '%s-%s.s' % (prefix, stem)


def kcc_runtime_fragments(machine, required_symbols):
    paths = []
    missing_files = []
    wrong_files = []
    for symbol in required_symbols:
        name = kcc_runtime_fragment_name(machine, symbol)
        path = find_kcc_rt(name) if name else None
        if path is None:
            missing_files.append('%s:%s' % (symbol, name or 'unmapped'))
            continue
        if not runtime_defines_symbol(read_text(path), symbol):
            wrong_files.append('%s:%s' % (symbol, path))
            continue
        if path not in paths:
            paths.append(path)
    if missing_files:
        return paths, 'missing runtime fragment(s): %s' % ','.join(missing_files)
    if wrong_files:
        return paths, 'runtime fragment(s) do not define requested symbol: %s' % ','.join(wrong_files)
    return paths, None


def normalize_kcc_multiline_literals(asm_text):
    """Rewrite KCC two-word bracket literals into private data labels.

    Some KCC KI output uses MACRO-style two-word literals such as:
        dmove   1,[202400000000
                0]
    The current test assembler does not accept that syntax.  Normalize it to a
    local data label, preserving the original file as *.raw when changed.
    """
    lines = asm_text.splitlines()
    out = []
    data_defs = []
    i = 0
    n = 0
    pat = re.compile(r'^(?P<prefix>.*)\[(?P<w1>[0-7]+)\s*$')
    pat2 = re.compile(r'^\s*(?P<w2>[0-7]+)\]\s*(?P<tail>.*)$')
    while i < len(lines):
        m = pat.match(lines[i])
        if m and i + 1 < len(lines):
            m2 = pat2.match(lines[i + 1])
            if m2:
                label = '$KLIT%04d' % n
                n += 1
                out.append('%s%s%s' % (m.group('prefix'), label, m2.group('tail')))
                data_defs.append((label, m.group('w1'), m2.group('w2')))
                i += 2
                continue
        out.append(lines[i])
        i += 1
    if not data_defs:
        return asm_text
    out.append('')
    out.append('\t.data')
    for label, w1, w2 in data_defs:
        out.append('%s:' % label)
        out.append('\t%s' % w1)
        out.append('\t%s' % w2)
    out.append('\t.text')
    return '\n'.join(out) + '\n'


def normalize_kcc_asm_file(asm_path, log_path):
    text = read_text(asm_path)
    norm = normalize_kcc_multiline_literals(text)
    if norm != text:
        raw_path = Path(str(asm_path) + '.raw')
        try:
            raw_path.write_text(text)
            Path(asm_path).write_text(norm)
            with open(log_path, 'a') as log:
                log.write('normalized KCC multi-word literals: raw=%s normalized=%s\n' %
                          (raw_path, asm_path))
        except OSError as e:
            with open(log_path, 'a') as log:
                log.write('normalization write failed: %s\n' % e)


def normalize_asm_line(line):
    line = re.sub(r'[;!].*$', '', line)
    return line.strip()


def asm_mnemonics(asm_text):
    out = []
    for line in asm_text.splitlines():
        s = normalize_asm_line(line)
        if not s or s.startswith('.'):
            continue
        if re.match(r'^\s*[A-Za-z_.$%][A-Za-z0-9_.$%]*:\s*$', s):
            continue
        m = LABEL_RE.match(s)
        if not m:
            continue
        op = m.group(1).upper()
        if op.endswith(':') or op.startswith('.'):
            continue
        out.append(op)
    return set(out)


def directives(src):
    out = {}
    try:
        with open(src, 'r', encoding='utf-8', errors='replace') as f:
            for line in f:
                m = DIRECTIVE_RE.match(line)
                if m:
                    out.setdefault(m.group(1), []).extend(shlex.split(m.group(2)))
    except OSError:
        pass
    return out


def default_forbidden(arch):
    if arch == 'base':
        return set(FORBID_BASE)
    if arch == 'pdp10':
        return set(FORBID_PDP10)
    return set()


def policy_for(src, arch):
    d = directives(src)
    forb = default_forbidden(arch)
    if 'codegen-forbid' in d:
        forb |= set(x.upper() for x in d['codegen-forbid'])
    if 'codegen-allow' in d:
        forb -= set(x.upper() for x in d['codegen-allow'])
    req = set(x.upper() for x in d.get('codegen-require', []))
    forbid_regex = d.get('codegen-forbid-regex', [])
    require_regex = d.get('codegen-require-regex', [])
    return forb, req, forbid_regex, require_regex


def regex_policy_failures(asm_text, forbid_regex, require_regex):
    bad = []
    miss = []
    invalid = []
    for pattern in forbid_regex:
        try:
            if re.search(pattern, asm_text):
                bad.append(pattern)
        except re.error as e:
            invalid.append('%s: %s' % (pattern, e))
    for pattern in require_regex:
        try:
            if re.search(pattern, asm_text) is None:
                miss.append(pattern)
        except re.error as e:
            invalid.append('%s: %s' % (pattern, e))
    return bad, miss, invalid


def wait_process_after_signal(proc, seconds):
    deadline = time.time() + seconds
    while time.time() < deadline:
        rc = proc.poll()
        if rc is not None:
            return rc
        time.sleep(0.05)
    return None


def report_file_result(path):
    if path is None:
        return None
    try:
        text = Path(path).read_text(errors='ignore')
    except OSError:
        return None
    m = re.search(r'(?m)^result=([A-Z_]+)\s*$', text)
    if not m:
        return None
    return m.group(1)


def kill_process_group(proc, sig):
    try:
        os.killpg(proc.pid, sig)
    except OSError:
        pass


def run_cmd(cmd, cwd, log_path, stdin_text=None, timeout=None, done_report_path=None):
    with open(log_path, 'a') as log:
        log.write('$ ' + ' '.join(shlex.quote(str(x)) for x in cmd) + '\n')
        log.flush()
        try:
            if stdin_text is not None:
                p = subprocess.run([str(x) for x in cmd], cwd=str(cwd), input=stdin_text,
                                   text=True, stdout=log, stderr=subprocess.STDOUT,
                                   timeout=timeout)
                return p.returncode
            p = subprocess.Popen([str(x) for x in cmd], cwd=str(cwd),
                                 stdout=log, stderr=subprocess.STDOUT,
                                 start_new_session=True)
            deadline = None
            if timeout is not None:
                deadline = time.time() + timeout
            while True:
                rc = p.poll()
                if rc is not None:
                    return rc
                result = report_file_result(done_report_path)
                if result in ('PASS', 'FAIL'):
                    log.write('PY_REPORT_DONE result=%s; terminating process group %s\n' %
                              (result, p.pid))
                    log.flush()
                    kill_process_group(p, signal.SIGTERM)
                    rc = wait_process_after_signal(p, 1.0)
                    if rc is None:
                        kill_process_group(p, signal.SIGKILL)
                        wait_process_after_signal(p, 1.0)
                    return 0 if result == 'PASS' else 1
                if deadline is not None and time.time() >= deadline:
                    log.write('PY_TIMEOUT after %s seconds; terminating process group %s\n' %
                              (timeout, p.pid))
                    log.flush()
                    kill_process_group(p, signal.SIGTERM)
                    rc = wait_process_after_signal(p, 2.0)
                    if rc is None:
                        log.write('PY_TIMEOUT: SIGTERM did not finish; killing process group %s\n' %
                                  p.pid)
                        log.flush()
                        kill_process_group(p, signal.SIGKILL)
                        wait_process_after_signal(p, 2.0)
                    return 124
                time.sleep(0.05)
        except OSError as e:
            log.write('EXEC_ERROR %s\n' % e)
            return 127


def binary_candidates():
    b = PDP10_PREFIX / 'bin'
    return {
        'kcc': [b / 'kcc', b / 'kcc10', b / 'pdp10-kcc'],
        'gcc': [b / 'pdp10-dec-none-gcc', b / 'pdp10-gcc'],
        'p10run': [b / 'p10run'],
    }


def find_one(name):
    for p in binary_candidates()[name]:
        if p.is_file():
            return p
    die('cannot find %s under %s/bin' % (name, PDP10_PREFIX))




def find_libgcc1():
    cands = [
        PDP10_PREFIX / 'share/gcc-pdp10/config/pdp10/libgcc1.s',
        PDP10_PREFIX / 'lib/gcc-lib/pdp10-dec-none/3.2/libgcc1.s',
        PDP10_PREFIX / 'lib/gcc/pdp10-dec-none/3.2/libgcc1.s',
        PDP10_PREFIX / 'lib/gcc/pdp10-dec-none/libgcc1.s',
    ]
    for p in cands:
        if p.is_file():
            return p
    return None


def setup_prefix_env():
    os.environ['PATH'] = str(PDP10_PREFIX / 'bin') + os.pathsep + os.environ.get('PATH', '')
    # Normalize every legacy installed-tool path variable.  They remain in the
    # child environment only for older helper compatibility, never as inputs.
    os.environ['PDP10_PREFIX'] = str(PDP10_PREFIX)
    os.environ['KCC'] = str(find_one('kcc'))
    os.environ['PDP10_GCC'] = str(find_one('gcc'))
    os.environ['PDP10_AS'] = str(PDP10_PREFIX / 'bin' / 'pdp10-dec-none-as')
    os.environ['PDP10_ASM'] = os.environ['PDP10_AS']
    os.environ['P10RUN'] = str(find_one('p10run'))
    os.environ['KCC_LIBDIR'] = str(PDP10_PREFIX / 'lib' / 'kcc')
    os.environ['KCC_RT'] = str(PDP10_PREFIX / 'lib' / 'kcc' / 'ks10rt.s')


def find_kcc_rt(name):
    cands = [
        PDP10_PREFIX / 'lib/kcc' / name,
        PDP10_PREFIX / 'share/kcc' / name,
    ]
    for p in cands:
        if p.is_file():
            return p
    return None


def asm_defines_symbol_text(asm_text, name):
    return re.search(r'(?m)^\s*' + re.escape(name) + r':', asm_text) is not None


def libgcc_defined_runtime_symbols(libgcc1, names):
    if libgcc1 is None:
        return set()
    text = read_text(libgcc1)
    return set(name for name in names if asm_defines_symbol_text(text, name))


def test_stubs(asm_text, outdir, exclude=None):
    return selected_test_stubs(asm_text, outdir, exclude=exclude)


def matrix_kind(group):
    if group.startswith('semantic') or group.startswith('validation'):
        return 'semantic'
    if group.startswith('codegen'):
        return 'codegen'
    return None




def source_exists(test):
    return (ROOT / test).is_file()


def known_test_counts(rows):
    semantic = set()
    codegen = set()
    for row in rows:
        test = row.get('test', '')
        if not test or not source_exists(test):
            continue
        kind = matrix_kind(row.get('group', ''))
        if kind == 'semantic':
            semantic.add(test)
        elif kind == 'codegen':
            codegen.add(test)
    return len(semantic), len(codegen)


FILTER_CHOICES = {
    'family': set(['native', 'base', 'pdp10']),
    'cpu': set(MACHINES),
    'opt': set(['opt', 'noopt', 'o0', 'o1', 'o2', 'os']),
}


def parse_csv_set(value, label=None, allowed=None):
    if value is None or value == '' or value == 'all':
        return None
    out = set()
    for part in value.split(','):
        part = part.strip().lower()
        if part:
            out.add(part)
    if allowed is not None:
        bad = sorted(out - allowed)
        if bad:
            die('invalid %s filter value(s): %s; expected all or comma-list from: %s' %
                (label, ','.join(bad), ','.join(sorted(allowed))))
    return out or None


def parse_args(argv):
    ap = argparse.ArgumentParser(
        description='Restartable local PDP-10 semantic/codegen sweep runner.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''\
Selection model:
  TEST_MATRIX.tsv is the only matrix and the source of truth.
  --family chooses native, base, pdp10, or all.
  --cpu chooses pdp6, ka10, ki10, or all.
  --opt chooses compiler optimization profile.
  pdp10-family cells are never scheduled on pdp6.

Default output:
  summary.txt          current selected-cell totals only
  failures.tsv         current selected-cell failures only
  cells/*/status       per-cell restart checkpoint
  cells/*/cell.log     per-cell details

Common examples:
  ./run-tests.sh --list-only --compiler kcc --family all --cpu all --opt all
  ./run-tests.sh --compiler kcc --family base --cpu pdp6 --opt noopt
  ./run-tests.sh --compiler gcc --family pdp10 --cpu ka10,ki10 --opt o2,os
  ./run-tests.sh --compiler gcc --family base --cpu pdp6 --opt os --kind codegen -j 32
  ./run-tests.sh --skip-failures

Restart behavior:
  Existing pass/compile_only cells are skipped.
  Existing failures are rerun by default.
  Add --skip-failures to skip existing failures too.
  Add --reset to remove selected cell checkpoints and reports.
''')
    ap.add_argument('--out-dir', default=os.environ.get('P10_SWEEP_OUTDIR', str(DEFAULT_OUTROOT)),
                    help='stable restart/output directory; default: workdir/full-sweep-current')
    ap.add_argument('--compiler', default=os.environ.get('P10_SWEEP_COMPILER', 'all'),
                    choices=('all', 'kcc', 'gcc'), help='compiler family to run; default: all')
    ap.add_argument('--family', default=os.environ.get('P10_SWEEP_FAMILY', 'all'),
                    metavar='LIST',
                    help='compiler target family/families: all,native,base,pdp10 or comma list')
    ap.add_argument('--cpu', default=os.environ.get('P10_SWEEP_CPU', 'all'),
                    metavar='LIST',
                    help='emulator/runtime CPU(s): all,pdp6,ka10,ki10 or comma list')
    ap.add_argument('--opt', '--optlevel', default=os.environ.get('P10_SWEEP_OPT', 'all'),
                    metavar='LIST',
                    help='optimization profile(s): all,opt,noopt,o0,o1,o2,os or comma list')
    ap.add_argument('--kind', default=os.environ.get('P10_SWEEP_KIND', 'all'),
                    choices=('all', 'semantic', 'codegen'),
                    help='test kind to run; default: all')
    ap.add_argument('--skip-failures', action='store_true',
                    help='also skip old failing cells, not only pass/compile_only cells')
    ap.add_argument('--reset', action='store_true',
                    help='remove selected cell checkpoints and current reports, then exit')
    ap.add_argument('--list-only', action='store_true',
                    help='print selected cell count and exit without running')
    ap.add_argument('-j', '--jobs', type=int, default=int(os.environ.get('P10_SWEEP_JOBS', '1')),
                    help='parallel test cells; default: 1')
    return ap.parse_args(argv)


def profile_selected(cell, compiler_filter, family_filter, cpu_filter, opt_filter):
    if compiler_filter != 'all' and cell.get('compiler') != compiler_filter:
        return False
    if family_filter is not None and cell.get('family') not in family_filter:
        return False
    if cpu_filter is not None and cell.get('machine') not in cpu_filter:
        return False
    if opt_filter is not None and cell.get('optname') not in opt_filter:
        return False
    return True


def validate_filter_combo(family_filter, cpu_filter):
    if family_filter == set(['pdp10']) and cpu_filter == set(['pdp6']):
        die('invalid filter combination: family pdp10 cannot run on cpu pdp6')


def kcc_profiles():
    out = []
    for optname, extra in KCC_OPTS:
        for mach in MACHINES:
            out.append({'compiler': 'kcc', 'profile': 'kcc-' + mach + '-' + optname,
                        'family': 'native', 'arch': mach, 'machine': mach,
                        'extra': extra, 'optname': optname, 'matrix_column': mach})
        for mach in MACHINES:
            out.append({'compiler': 'kcc', 'profile': 'kcc-base-' + optname,
                        'family': 'base', 'arch': 'base', 'machine': mach,
                        'extra': extra, 'optname': optname, 'matrix_column': mach + '_base'})
        for mach in ('ka10', 'ki10', 'ks10'):
            out.append({'compiler': 'kcc', 'profile': 'kcc-pdp10-' + optname,
                        'family': 'pdp10', 'arch': 'pdp10', 'machine': mach,
                        'extra': extra, 'optname': optname, 'matrix_column': mach + '_pdp10'})
    return out


def gcc_profiles():
    out = []
    for optname, optflag in GCC_OPTS:
        for mach in MACHINES:
            out.append({'compiler': 'gcc', 'profile': 'gcc-' + mach + '-' + optname,
                        'family': 'native', 'arch': mach, 'machine': mach,
                        'opt': optflag, 'optname': optname, 'matrix_column': mach + '_gcc_' + optname})
        for mach in MACHINES:
            out.append({'compiler': 'gcc', 'profile': 'gcc-base-' + optname,
                        'family': 'base', 'arch': 'base', 'machine': mach,
                        'opt': optflag, 'optname': optname, 'matrix_column': mach + '_gcc_base_' + optname})
        for mach in ('ka10', 'ki10', 'ks10'):
            out.append({'compiler': 'gcc', 'profile': 'gcc-pdp10-' + optname,
                        'family': 'pdp10', 'arch': 'pdp10', 'machine': mach,
                        'opt': optflag, 'optname': optname, 'matrix_column': mach + '_gcc_pdp10_' + optname})
    return out


def all_profiles():
    return kcc_profiles() + gcc_profiles()


def active_matrix_status(kind, value):
    value = (value or '').strip().lower()
    if kind == 'semantic':
        return value in SEMANTIC_MATRIX_STATUSES
    if kind == 'codegen':
        return value in CODEGEN_MATRIX_STATUSES
    return False


def build_cells(rows, profiles, kind_filter=None):
    semantic_cells = []
    codegen_cells = []
    missing = []
    ignored_status = {}
    for row in rows:
        test = row.get('test', '')
        kind = matrix_kind(row.get('group', ''))
        if not kind or not test:
            continue
        if kind_filter is not None and kind != kind_filter:
            continue
        if not source_exists(test):
            missing.append(test)
            continue
        for profile in profiles:
            col = profile.get('matrix_column', '')
            value = (row.get(col, '') or '').strip().lower()
            if active_matrix_status(kind, value):
                cell = dict(profile)
                cell['kind'] = kind
                cell['matrix_status'] = value
                cell['matrix_column'] = col
                if kind == 'semantic':
                    semantic_cells.append((test, cell))
                else:
                    codegen_cells.append((test, cell))
            elif value not in INACTIVE_MATRIX_STATUSES:
                ignored_status[value] = ignored_status.get(value, 0) + 1
    return semantic_cells, codegen_cells, sorted(set(missing)), ignored_status


def cell_key(src, cell, kind=None):
    return (src, cell.get('machine', ''), cell.get('compiler', ''), cell.get('profile', ''), kind or cell.get('kind', ''))


def cell_dir(outroot, src, cell):
    name = safe_name('%s__%s__%s__%s' % (cell['compiler'], cell['profile'], cell['machine'], src))
    return outroot / 'cells' / name


def status_path(outroot, src, cell):
    return cell_dir(outroot, src, cell) / 'status'


def read_status_file(path):
    if not path.is_file():
        return None
    row = {}
    try:
        with open(path, 'r', encoding='utf-8', errors='replace') as f:
            for line in f:
                line = line.rstrip('\n')
                if not line or line.startswith('#') or '=' not in line:
                    continue
                key, value = line.split('=', 1)
                row[key] = value
    except OSError:
        return None
    return row or None

def read_cell_status(outroot, src, cell):
    row = read_status_file(status_path(outroot, src, cell))
    if not row:
        return None
    key = (row.get('test', ''), row.get('machine', ''), row.get('compiler', ''),
           row.get('profile', ''), row.get('kind', ''))
    if key != cell_key(src, cell):
        return None
    return row


def write_status_file(outroot, line):
    src, machine, compiler, profile, kind = line[:5]
    cdir = outroot / 'cells' / safe_name('%s__%s__%s__%s' % (compiler, profile, machine, src))
    cdir.mkdir(parents=True, exist_ok=True)
    path = cdir / 'status'
    row = dict(zip(STATUS_FIELDS, line))
    with open(path, 'w', encoding='utf-8') as f:
        f.write('# transient restart checkpoint; TEST_MATRIX.tsv is the only matrix\n')
        for key in STATUS_FIELDS:
            f.write('%s=%s\n' % (key, row.get(key, '')))



def collect_selected_statuses(outroot, semantic_cells, codegen_cells):
    rows = []
    for src, cell in semantic_cells + codegen_cells:
        row = read_cell_status(outroot, src, cell)
        if row:
            rows.append(row)
        else:
            rows.append({'test': src, 'machine': cell['machine'], 'compiler': cell['compiler'],
                         'profile': cell['profile'], 'kind': cell['kind'], 'status': 'not_run',
                         'elapsed': '', 'asm': '', 'report': ''})
    return rows


def write_rows_tsv(path, fields, rows):
    with open(path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fields, delimiter='\t', lineterminator='\n', extrasaction='ignore')
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def write_failures(outroot, semantic_cells, codegen_cells):
    rows = [r for r in collect_selected_statuses(outroot, semantic_cells, codegen_cells)
            if r.get('status') in FAIL_STATUSES]
    write_rows_tsv(outroot / 'failures.tsv', FAILURE_FIELDS, rows)
    return rows



def plan_restart(outroot, semantic_cells, codegen_cells, skip_failures):
    counts = {
        'selected': len(semantic_cells) + len(codegen_cells),
        'old_green': 0,
        'old_fail': 0,
        'old_other': 0,
        'old_skipped': 0,
        'new_missing': 0,
        'to_run': 0,
    }
    old_status_counts = {}
    semantic_run = []
    codegen_run = []

    def classify(src, cell):
        row = read_cell_status(outroot, src, cell)
        if not row:
            counts['new_missing'] += 1
            counts['to_run'] += 1
            return True
        status = row.get('status', '')
        old_status_counts[status] = old_status_counts.get(status, 0) + 1
        if status in PASS_STATUSES:
            counts['old_green'] += 1
            counts['old_skipped'] += 1
            return False
        if status in FAIL_STATUSES:
            counts['old_fail'] += 1
            if skip_failures:
                counts['old_skipped'] += 1
                return False
        else:
            counts['old_other'] += 1
        counts['to_run'] += 1
        return True

    for src, cell in semantic_cells:
        if classify(src, cell):
            semantic_run.append((src, cell))
    for src, cell in codegen_cells:
        if classify(src, cell):
            codegen_run.append((src, cell))
    return semantic_run, codegen_run, counts, old_status_counts


def remove_selected_cells(outroot, semantic_cells, codegen_cells):
    removed = 0
    for src, cell in semantic_cells + codegen_cells:
        cdir = cell_dir(outroot, src, cell)
        if cdir.exists():
            shutil.rmtree(str(cdir))
            removed += 1
    for name in ('summary.txt', 'failures.tsv', 'all-results.tsv', 'selected-cells.tsv', 'results.tsv'):
        try:
            (outroot / name).unlink()
        except OSError:
            pass
    return removed


def compile_to_asm(cell, src, asm_path, log_path, bins):
    if cell['compiler'] == 'kcc':
        stem = str(asm_path)
        if stem.endswith('.s'):
            stem = stem[:-2]
        stem = os.path.relpath(stem, ROOT)
        cmd = [str(bins['kcc']), '-S', '-v=nostats'] + list(cell.get('extra', [])) + [
            '-x=' + cell['arch'],
            '-Isupport/kcc/',
            '-Isupport/common/',
            '-Isupport/include/',
            '-R=' + stem,
            src,
        ]
    elif cell['compiler'] == 'gcc':
        cmd = [str(bins['gcc']), '-S', cell['opt'], '-march=' + cell['arch'],
               '-I' + str(ROOT / 'support/gcc'),
               '-I' + str(ROOT / 'support/common'),
               '-I' + str(ROOT / 'support/include'),
               str(ROOT / src), '-o', str(asm_path)]
    else:
        raise RuntimeError('unsupported compiler family: %s' % cell['compiler'])
    rc = run_cmd(cmd, ROOT, log_path, timeout=COMPILE_TIMEOUT)
    if rc == 124:
        return 'timeout'
    return 'pass' if rc == 0 and asm_path.is_file() else 'fail'


def write_cell_result(outroot, line):
    write_status_file(outroot, line)


def begin_cell_run(outroot, src, cell, kind):
    """Prepare a selected cell for a fresh attempt.

    A cell directory may contain stale asm, logs, and p10run report files from
    an earlier failed or timed-out attempt.  Delete the directory before each
    real attempt so a current timeout cannot be paired with an old PASS report.
    Write a transient running checkpoint immediately after the cleanup; if the
    runner is killed, restart planning sees old_other/running and retries it.
    """
    cdir = cell_dir(outroot, src, cell)
    if cdir.exists():
        shutil.rmtree(str(cdir))
    cdir.mkdir(parents=True, exist_ok=True)
    write_status_file(outroot, [src, cell['machine'], cell['compiler'],
                                cell['profile'], kind, 'running', '0.00', '', ''])
    return cdir


def run_semantic_cell(idx, total, src, cell, outroot, bins, libgcc1, announce=True):
    cdir = begin_cell_run(outroot, src, cell, 'semantic')
    adir = cdir / 'asm'
    rdir = cdir / 'run'
    adir.mkdir(parents=True, exist_ok=True)
    rdir.mkdir(parents=True, exist_ok=True)
    log_path = cdir / 'cell.log'
    log_path.write_text('')
    asm_path = adir / (safe_name(src) + '.s')
    if announce:
        print('[%06d/%06d] semantic %-3s %-18s %-5s %s' % (idx, total, cell['compiler'], cell['profile'], cell['machine'], src))
        sys.stdout.flush()
    t0 = time.time()
    compile_status = compile_to_asm(cell, src, asm_path, log_path, bins)
    if compile_status != 'pass':
        status = 'timeout' if compile_status == 'timeout' else 'compile_fail'
        report = str(log_path)
    else:
        if cell['compiler'] == 'kcc':
            normalize_kcc_asm_file(asm_path, log_path)
        asm_text = read_text(asm_path)
        if not label_exists(asm_text, 'main'):
            status = 'compile_only'
            report = str(asm_path)
        else:
            cmd = [str(bins['p10run']), '--machine', cell['machine'], '--mode', 'deposit', '--exec-mode', 'step',
                   '--step-limit', os.environ.get('P10_SWEEP_STEP_LIMIT', '100000000'),
                   '--timeout', P10_TIMEOUT,
                   '--workdir', str(rdir), '--name', safe_name(src)]
            if label_exists(asm_text, '__test_exit'):
                cmd += ['--expect', '__test_exit=0']
            if label_exists(asm_text, 'fail_id'):
                cmd += ['--expect', 'fail_id=0']
            if label_exists(asm_text, 'semantic_fail_id'):
                cmd += ['--expect', 'semantic_fail_id=0']
            for label in ('got', 'got1', 'got2', 'got3', 'got4', 'got5', 'semantic_sink'):
                if label_exists(asm_text, label):
                    cmd += ['--examine', label]
            stub_exclude = set()
            if cell['compiler'] == 'gcc':
                # p10run links the canonical GCC libgcc archive automatically.
                # __main is owned there; do not manufacture a testkit stub.
                stub_exclude.add('__main')
            cmd += [str(ROOT / 'support/crt0.s'), str(asm_path)] + test_stubs(asm_text, rdir, exclude=stub_exclude)
            setup_error = None
            if cell['compiler'] == 'kcc':
                required = needed_kcc_runtime_symbols(asm_text)
                runtime_files = []
                if required:
                    runtime_files, setup_error = kcc_runtime_fragments(cell['machine'], required)
                    cmd += [str(path) for path in runtime_files]
                with open(log_path, 'a') as log:
                    log.write('kcc_runtime_required=%s\n' % (','.join(required) if required else 'none'))
                    log.write('kcc_runtime_files=%s\n' %
                              (','.join(str(path) for path in runtime_files) if runtime_files else 'none'))
                    if setup_error:
                        log.write('SETUP_FAIL %s\n' % setup_error)
            else:
                pass
            if setup_error:
                status = 'setup_fail'
                report = str(log_path)
            else:
                report_path = rdir / (safe_name(src) + '.report.txt')
                rc = run_cmd(cmd, ROOT, log_path, timeout=CELL_TIMEOUT,
                             done_report_path=report_path)
                report = str(report_path if report_path.is_file() else log_path)
                status = 'pass' if rc == 0 else ('timeout' if rc == 124 else 'run_fail')
    elapsed = '%.2f' % (time.time() - t0)
    line = [src, cell['machine'], cell['compiler'], cell['profile'], 'semantic', status, elapsed, str(asm_path), report]
    write_cell_result(outroot, line)
    return status


def run_codegen_cell(idx, total, src, cell, outroot, bins, announce=True):
    cdir = begin_cell_run(outroot, src, cell, 'codegen')
    adir = cdir / 'asm'
    adir.mkdir(parents=True, exist_ok=True)
    log_path = cdir / 'cell.log'
    log_path.write_text('')
    asm_path = adir / (safe_name(src) + '.s')
    if announce:
        print('[%06d/%06d] codegen  %-3s %-18s %-5s %s' % (idx, total, cell['compiler'], cell['profile'], cell['machine'], src))
        sys.stdout.flush()
    t0 = time.time()
    compile_status = compile_to_asm(cell, src, asm_path, log_path, bins)
    if compile_status != 'pass':
        status = 'timeout' if compile_status == 'timeout' else 'compile_fail'
        report = str(log_path)
    else:
        if cell['compiler'] == 'kcc':
            normalize_kcc_asm_file(asm_path, log_path)
        asm_text = read_text(asm_path)
        mnems = asm_mnemonics(asm_text)
        forbidden, required, forbid_regex, require_regex = policy_for(
            ROOT / src, cell['arch'])
        bad = sorted(mnems & forbidden)
        miss = sorted(required - mnems)
        bad_regex, miss_regex, invalid_regex = regex_policy_failures(
            asm_text, forbid_regex, require_regex)
        if bad or miss or bad_regex or miss_regex or invalid_regex:
            status = 'policy_fail'
            rpt = cdir / 'policy.report.txt'
            with open(rpt, 'w') as f:
                f.write('test=%s\ncompiler=%s\nprofile=%s\nmachine=%s\narch=%s\nasm=%s\n' %
                        (src, cell['compiler'], cell['profile'], cell['machine'], cell['arch'], asm_path))
                if bad:
                    f.write('forbidden_mnemonics=%s\n' % ','.join(bad))
                if miss:
                    f.write('missing_required_mnemonics=%s\n' % ','.join(miss))
                if bad_regex:
                    f.write('forbidden_regex_matches=%s\n' %
                            ' | '.join(bad_regex))
                if miss_regex:
                    f.write('missing_required_regex=%s\n' %
                            ' | '.join(miss_regex))
                if invalid_regex:
                    f.write('invalid_regex=%s\n' %
                            ' | '.join(invalid_regex))
            report = str(rpt)
        else:
            status = 'pass'
            report = str(log_path)
    elapsed = '%.2f' % (time.time() - t0)
    line = [src, cell['machine'], cell['compiler'], cell['profile'], 'codegen', status, elapsed, str(asm_path), report]
    write_cell_result(outroot, line)
    return status



def run_cell_worker(task):
    idx, total, kind, src, cell, outroot, bins, libgcc1 = task
    try:
        if kind == 'semantic':
            status = run_semantic_cell(idx, total, src, cell, outroot, bins, libgcc1, announce=False)
        else:
            status = run_codegen_cell(idx, total, src, cell, outroot, bins, announce=False)
        return (idx, kind, src, cell.get('compiler', ''), cell.get('profile', ''),
                cell.get('machine', ''), status, None)
    except BaseException as e:
        return (idx, kind, src, cell.get('compiler', ''), cell.get('profile', ''),
                cell.get('machine', ''), 'setup_fail', repr(e))


def run_cells_parallel(semantic_run, codegen_run, outroot, bins, libgcc1, jobs):
    tasks = []
    total = len(semantic_run) + len(codegen_run)
    idx = 0
    for src, cell in semantic_run:
        idx += 1
        tasks.append((idx, total, 'semantic', src, cell, outroot, bins, libgcc1))
    for src, cell in codegen_run:
        idx += 1
        tasks.append((idx, total, 'codegen', src, cell, outroot, bins, libgcc1))

    if jobs < 1:
        jobs = 1
    if jobs == 1:
        passed = 0
        compile_only = 0
        failed = 0
        for task in tasks:
            idx, total, kind, src, cell, _outroot, _bins, _libgcc1 = task
            if kind == 'semantic':
                status = run_semantic_cell(idx, total, src, cell, outroot, bins, libgcc1)
                if status == 'pass':
                    passed += 1
                elif status == 'compile_only':
                    compile_only += 1
                else:
                    failed += 1
            else:
                status = run_codegen_cell(idx, total, src, cell, outroot, bins)
                if status == 'pass':
                    passed += 1
                else:
                    failed += 1
        return total, passed, compile_only, failed

    passed = 0
    compile_only = 0
    failed = 0
    completed = 0
    progress_step = int(os.environ.get('P10_SWEEP_PROGRESS', '100'))
    if progress_step < 1:
        progress_step = 100

    print('parallel jobs:     %d' % jobs)
    sys.stdout.flush()
    pool = multiprocessing.Pool(processes=jobs)
    try:
        for result in pool.imap_unordered(run_cell_worker, tasks):
            idx, kind, src, compiler, profile, machine, status, error = result
            completed += 1
            if status == 'pass':
                passed += 1
            elif status == 'compile_only':
                compile_only += 1
            else:
                failed += 1
            if error:
                print('[%06d/%06d] %-8s %-3s %-18s %-5s %s %s %s' %
                      (idx, total, kind, compiler, profile, machine, status, src, error))
            elif status not in PASS_STATUSES:
                print('[%06d/%06d] %-8s %-3s %-18s %-5s %s %s' %
                      (idx, total, kind, compiler, profile, machine, status, src))
            if completed == total or completed % progress_step == 0:
                print('progress: %d/%d pass=%d compile_only=%d fail=%d' %
                      (completed, total, passed, compile_only, failed))
            sys.stdout.flush()
    except KeyboardInterrupt:
        pool.terminate()
        pool.join()
        raise
    else:
        pool.close()
        pool.join()
    return total, passed, compile_only, failed

def selected_counts_by_compiler(semantic_cells, codegen_cells):
    counts = {}
    for _src, cell in semantic_cells + codegen_cells:
        comp = cell.get('compiler', 'unknown')
        counts[comp] = counts.get(comp, 0) + 1
    return counts

def status_counts(rows):
    out = {}
    for row in rows:
        st = row.get('status', 'not_run') or 'not_run'
        out[st] = out.get(st, 0) + 1
    return out


def failure_count_from_counts(counts):
    return sum(v for k, v in counts.items() if k in FAIL_STATUSES)


def write_summary(path, outroot, args, semantic_test_count, codegen_test_count, scheduled_total,
                  selected_by_compiler, account, skipped, ran, new_pass, new_compile_only, new_fail, final_counts,
                  missing_sources, ignored_status):
    final_fail = failure_count_from_counts(final_counts)
    with open(path, 'w', encoding='utf-8') as f:
        f.write('output=%s\n' % outroot)
        f.write('compiler_filter=%s\n' % args.compiler)
        f.write('family_filter=%s\n' % args.family)
        f.write('cpu_filter=%s\n' % args.cpu)
        f.write('opt_filter=%s\n' % args.opt)
        f.write('kind_filter=%s\n' % args.kind)
        f.write('kind_filter=%s\n' % args.kind)
        f.write('checkpoint_model=per-cell status\n')
        f.write('matrix=TEST_MATRIX.tsv\n')
        f.write('semantic_tests=%d\n' % semantic_test_count)
        f.write('codegen_tests=%d\n' % codegen_test_count)
        f.write('selected_cells=%d\n' % scheduled_total)
        for comp in sorted(selected_by_compiler):
            f.write('selected_%s=%d\n' % (comp, selected_by_compiler[comp]))
        f.write('old_green=%d\n' % account['old_green'])
        f.write('old_fail=%d\n' % account['old_fail'])
        f.write('old_other=%d\n' % account['old_other'])
        f.write('old_skipped=%d\n' % account['old_skipped'])
        f.write('new_missing=%d\n' % account['new_missing'])
        f.write('planned_to_run=%d\n' % account['to_run'])
        f.write('skipped_existing=%d\n' % skipped)
        f.write('ran_this_invocation=%d\n' % ran)
        f.write('new_pass=%d\n' % new_pass)
        f.write('new_compile_only=%d\n' % new_compile_only)
        f.write('new_fail=%d\n' % new_fail)
        for st in sorted(final_counts):
            f.write('%s=%d\n' % (st, final_counts[st]))
        f.write('fail=%d\n' % final_fail)
        f.write('failures=%s\n' % (outroot / 'failures.tsv'))
        f.write('missing_source_rows=%d\n' % len(missing_sources))
        if missing_sources:
            f.write('missing_sources=%s\n' % ','.join(missing_sources))
        if ignored_status:
            f.write('ignored_nonactive_statuses=%s\n' % ','.join('%s:%d' % (k, ignored_status[k]) for k in sorted(ignored_status)))


def print_selection(args, outroot, semantic_test_count, codegen_test_count, profiles,
                    scheduled_total, selected_by_compiler, account, old_status_counts, missing_sources, ignored_status):
    print('output:         %s' % outroot)
    print('compiler:       %s' % args.compiler)
    print('family:         %s' % args.family)
    print('cpu:            %s' % args.cpu)
    print('opt:            %s' % args.opt)
    print('kind:           %s' % args.kind)
    print('semantic tests: %d' % semantic_test_count)
    print('codegen tests:  %d' % codegen_test_count)
    print('profiles:       %d' % len(profiles))
    print('test cells:     %d' % scheduled_total)
    if selected_by_compiler:
        print('by compiler:    %s' % ' '.join('%s=%d' % (k, selected_by_compiler[k]) for k in sorted(selected_by_compiler)))
    print('old green:      %d' % account['old_green'])
    print('old failures:   %d' % account['old_fail'])
    print('old other:      %d' % account['old_other'])
    print('old skipped:    %d' % account['old_skipped'])
    print('new missing:    %d' % account['new_missing'])
    print('to run now:     %d' % account['to_run'])
    if old_status_counts:
        print('old status:     %s' % ' '.join('%s=%d' % (k, old_status_counts[k]) for k in sorted(old_status_counts)))
    if missing_sources:
        print('missing sources:%d' % len(missing_sources))
    if ignored_status:
        print('ignored status: %s' % ' '.join('%s=%d' % (k, ignored_status[k]) for k in sorted(ignored_status)))














def main():
    args = parse_args(sys.argv[1:])
    outroot = Path(args.out_dir).expanduser()
    compiler_filter = args.compiler
    family_filter = parse_csv_set(args.family, 'family', FILTER_CHOICES['family'])
    cpu_filter = parse_csv_set(args.cpu, 'cpu', FILTER_CHOICES['cpu'])
    opt_filter = parse_csv_set(args.opt, 'opt', FILTER_CHOICES['opt'])
    validate_filter_combo(family_filter, cpu_filter)

    setup_prefix_env()

    rows = split_rows()
    profiles_all = all_profiles()
    profiles = [p for p in profiles_all if profile_selected(p, compiler_filter, family_filter, cpu_filter, opt_filter)]
    kind_filter = None if args.kind == 'all' else args.kind
    semantic_cells, codegen_cells, missing_sources, ignored_status = build_cells(rows, profiles, kind_filter)
    scheduled_total = len(semantic_cells) + len(codegen_cells)
    selected_by_compiler = selected_counts_by_compiler(semantic_cells, codegen_cells)
    semantic_test_count, codegen_test_count = known_test_counts(rows)

    outroot.mkdir(parents=True, exist_ok=True)

    semantic_run, codegen_run, account, old_status_counts = plan_restart(
        outroot, semantic_cells, codegen_cells, args.skip_failures)

    if args.reset:
        removed = remove_selected_cells(outroot, semantic_cells, codegen_cells)
        print('reset output:    %s' % outroot)
        print('compiler:        %s' % compiler_filter)
        print('family:          %s' % args.family)
        print('cpu:             %s' % args.cpu)
        print('opt:             %s' % args.opt)
        print('selected cells:  %d' % scheduled_total)
        print('removed cells:   %d' % removed)
        return 0

    if args.list_only:
        print_selection(args, outroot, semantic_test_count, codegen_test_count, profiles,
                        scheduled_total, selected_by_compiler, account, old_status_counts, missing_sources, ignored_status)
        return 0

    needed_compilers = set(p['compiler'] for _, p in semantic_cells + codegen_cells)
    bins = {'p10run': find_one('p10run')}
    if 'kcc' in needed_compilers:
        bins['kcc'] = find_one('kcc')
    if 'gcc' in needed_compilers:
        bins['gcc'] = find_one('gcc')

    setup_log = outroot / 'setup.log'
    with setup_log.open('a', encoding='utf-8') as f:
        f.write('--- run %s ---\n' % time.strftime('%Y%m%d-%H%M%S'))
        f.write('pdp10_prefix=%s\n' % PDP10_PREFIX)
        f.write('outroot=%s\n' % outroot)
        f.write('compiler_filter=%s\n' % compiler_filter)
        f.write('family_filter=%s\n' % args.family)
        f.write('cpu_filter=%s\n' % args.cpu)
        f.write('opt_filter=%s\n' % args.opt)
        f.write('kind_filter=%s\n' % args.kind)
        f.write('skip_failures=%s\n' % ('yes' if args.skip_failures else 'no'))
        f.write('jobs=%d\n' % args.jobs)
        f.write('matrix=TEST_MATRIX.tsv\n')
        f.write('checkpoint_model=per-cell status\n')
        f.write('kcc=%s\n' % bins.get('kcc', 'not-selected'))
        f.write('gcc=%s\n' % bins.get('gcc', 'not-selected'))
        f.write('p10run=%s\n' % bins['p10run'])
        f.write('compile_timeout=%s\ncell_timeout=%s\np10_timeout=%s\n' %
                (COMPILE_TIMEOUT, CELL_TIMEOUT, P10_TIMEOUT))
        if 'kcc' in needed_compilers:
            f.write('kcc_libdir=%s\n' % (PDP10_PREFIX / 'lib/kcc'))
            for machine in MACHINES:
                files = []
                for symbol in KCC_RUNTIME_SYMBOLS:
                    name = kcc_runtime_fragment_name(machine, symbol)
                    if name and name not in files:
                        files.append(name)
                found = [str(find_kcc_rt(name) or ('not-found:' + name)) for name in files]
                f.write('kcc_%s_runtime=%s\n' % (machine, ','.join(found)))

    libgcc1 = None
    if 'gcc' in needed_compilers:
        with setup_log.open('a', encoding='utf-8') as f:
            f.write('libgcc=canonical driver archive via p10run\n')

    print('full sweep output: %s' % outroot)
    print('compiler filter:   %s' % compiler_filter)
    print('family filter:     %s' % args.family)
    print('cpu filter:        %s' % args.cpu)
    print('opt filter:        %s' % args.opt)
    print('kind filter:       %s' % args.kind)
    print('semantic tests:    %d' % semantic_test_count)
    print('codegen tests:     %d' % codegen_test_count)
    print('selected cells:    %d' % scheduled_total)
    if selected_by_compiler:
        print('by compiler:       %s' % ' '.join('%s=%d' % (k, selected_by_compiler[k]) for k in sorted(selected_by_compiler)))
    print('old green skipped: %d' % account['old_green'])
    print('old failures:      %d%s' % (account['old_fail'], ' skipped' if args.skip_failures else ' to retry'))
    print('old other to retry:%d' % account['old_other'])
    print('new missing cells: %d' % account['new_missing'])
    print('to run now:        %d' % account['to_run'])
    print('jobs:              %d' % args.jobs)
    if old_status_counts:
        print('old status counts: %s' % ' '.join('%s=%d' % (k, old_status_counts[k]) for k in sorted(old_status_counts)))

    skipped = account['old_skipped']
    idx, passed, compile_only, failed = run_cells_parallel(
        semantic_run, codegen_run, outroot, bins, libgcc1, args.jobs)

    write_failures(outroot, semantic_cells, codegen_cells)
    selected_rows = collect_selected_statuses(outroot, semantic_cells, codegen_cells)
    final_counts = status_counts(selected_rows)
    summary = outroot / 'summary.txt'
    write_summary(summary, outroot, args, semantic_test_count, codegen_test_count, scheduled_total,
                  selected_by_compiler, account, skipped, idx, passed, compile_only, failed, final_counts,
                  missing_sources, ignored_status)
    final_fail = failure_count_from_counts(final_counts)
    print('complete: selected=%d old_green_skipped=%d ran=%d skipped=%d new_pass=%d new_compile_only=%d new_fail=%d' %
          (scheduled_total, account['old_green'], idx, skipped, passed, compile_only, failed))
    print('selected latest status: %s' % ' '.join('%s=%d' % (k, final_counts[k]) for k in sorted(final_counts)))
    print('summary:  %s' % summary)
    print('failures: %s' % (outroot / 'failures.tsv'))
    return 0 if final_fail == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
