#!/usr/bin/env python3
"""Confirm gate 15 actually exercises both structure arguments and memcpy.

Run the immutable original under PDP-6 KCC -n and optimized KCC, then
mutate each call path separately in a temporary source copy.  A successful
mutant or an optimized-away call fails the regression, not the compiler.
No modified source is written to the repository.
"""

import hashlib
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'tests/todo/generic/20011113-1.c'
ORIGINAL_SHA256 = 'dc6368537064e8504888743d81c0f9e1ae1007420b398cda8d0e3c3cbea23bcd'
PREFIX = Path(os.environ.get('PDP10_PREFIX') or (Path.home() / 'cross'))
TMPDIR = Path(os.environ.get('TMPDIR') or (Path.home() / 'tmp'))
CALLS = '  baz (&t);\n  foo (&t);'
CASES = {
    'original': CALLS,
    'bad-baz': '  t.d[2] = 0;\n  baz (&t);\n'
               '  t.d[2] = 22;\n  foo (&t);',
    'bad-foo': '  baz (&t);\n  t.d[2] = 0;\n  foo (&t);',
}


def command(args, cwd=ROOT, timeout=60):
    proc = subprocess.run([str(v) for v in args], cwd=cwd,
                          capture_output=True, text=True, timeout=timeout)
    return proc.returncode, proc.stdout + proc.stderr


def check_assembly(source):
    for label in ('foo', 'baz', 'bar', 'main'):
        if not re.search(r'(?mi)^\s*' + label + r':\s*$', source):
            raise ValueError('missing compiled function: ' + label)
    for symbol in ('foo', 'baz', 'bar', 'memcpy', 'abort'):
        if not re.search(r'(?mi)^\s*pushj\s+17\s*,\s*' + symbol +
                         r'\b', source):
            raise ValueError('original oracle call removed: ' + symbol)


def main():
    data = SOURCE.read_bytes()
    if hashlib.sha256(data).hexdigest() != ORIGINAL_SHA256:
        raise ValueError('original gate-15 source identity changed')
    original = data.decode('ascii')
    if original.count(CALLS) != 1:
        raise ValueError('original two-call sequence missing')
    if original.count('  memcpy (&u, &x->d[1], sizeof u);') != 2:
        raise ValueError('original has lost either structure copy')
    TMPDIR.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='p10tk-p1-gate15-v1-',
                                     dir=TMPDIR) as directory:
        work = Path(directory)
        for mode in ('noopt', 'opt'):
            for name, replacement in CASES.items():
                src = work / ('gate15-' + mode + '-' + name + '-v1.c')
                assembly = src.with_suffix('.s')
                src.write_text(original.replace(CALLS, replacement),
                               encoding='ascii')
                cmd = [PREFIX / 'bin/kcc', '-S', '-v=nostats', '-x=pdp6',
                       '-R=unit', '-o', assembly, src]
                if mode == 'noopt':
                    cmd.insert(3, '-n')
                rc, message = command(cmd)
                if rc:
                    raise ValueError('KCC %s %s compile failed: %s' %
                                     (mode, name, message[-800:]))
                if name == 'original':
                    check_assembly(assembly.read_text(encoding='ascii'))
                guest = work / ('run-' + mode + '-' + name)
                rc, message = command([
                    PREFIX / 'bin/p10run', '--machine', 'pdp6', '--mode',
                    'deposit', '--exec-mode', 'step', '--step-limit',
                    '100000000', '--timeout', '18', '--workdir', guest,
                    '--name', 'gate15-' + mode + '-' + name + '-v1',
                    '--expect', '__test_exit=0',
                    ROOT / 'support/crt0-upstream-v1.s', assembly,
                    ROOT / 'support/exit-v1.s', ROOT / 'support/abort-v1.s',
                    PREFIX / 'lib/kcc/freestanding/kcc-libc-memcpy-v1.s',
                ], timeout=35)
                report = (guest / ('gate15-' + mode + '-' + name +
                                   '-v1.report.txt'))
                if not report.is_file():
                    raise ValueError('missing simulator report: ' + message[-600:])
                result = report.read_text(encoding='ascii', errors='replace')
                observed = re.search(
                    r'__P10RUN_EXPECT__ __test_exit [0-7]+ 000000000000\s*\n'
                    r'[0-7]+:\s*00000000000([01])\b', result)
                if name == 'original':
                    good = (rc == 0 and 'result=PASS' in result and
                            observed is not None and observed.group(1) == '0')
                else:
                    good = (rc != 0 and 'result=FAIL' in result and
                            observed is not None and observed.group(1) == '1')
                if not good:
                    raise ValueError('unexpected gate15 result for %s %s: %s'
                                     % (mode, name, result[-650:]))
                print('PASS gate15 %s %s: %s' %
                      (mode, name, 'original succeeds' if name == 'original'
                       else 'mutant detected'), flush=True)
    print('P1 gate15 complete: original passes twice, two call-path '
          'mutants rejected in each mode')


if __name__ == '__main__':
    sys.exit(main())
