#!/usr/bin/env python3
"""Check arity diagnostics without executing undefined calls."""

import os
from pathlib import Path
import subprocess
import tempfile

from compiler_negative_policy_v1 import check_kcc_rejection

KCC = Path(os.environ['PDP10_PREFIX']) / 'bin/kcc'
OLD = 'int f(a,b) int a,b; {return a+b;}\n'
CASES = (
    (OLD + 'int g(void) {return f(1,2,3);}\n', True,
     "[Advisory] Number of args doesn't match function def"),
    (OLD + 'int g(void) {return f(1);}\n', True,
     "[Advisory] Number of args doesn't match function def"),
    (OLD + 'int g(void) {return f();}\n', True,
     '[Advisory] No args given to function defined with params'),
    ('int f() {return 1;}\nint g(void) {return f(1);}\n', True,
     '[Advisory] Args given to function defined without params'),
    ('int f(int,int);\n' + OLD + 'int g(void) {return f(1,2,3);}\n', False,
     "Number of args doesn't match function prototype"),
    (OLD + 'int f(int,int);\nint g(void) {return f(1,2,3);}\n', False,
     "Number of args doesn't match function prototype"),
    ('int f(int,int);\nint g(void) {return f(1);}\n', False,
     "Number of args doesn't match function prototype"),
    ('int f(void);\nint g(void) {return f(1);}\n', False,
     "Number of args doesn't match function prototype"),
    ('int g(int (*p)(int)) {return p(1,2);}\n', False,
     "Number of args doesn't match function prototype"),
    ('int f(int,...);\nint g(void) {return f(1,2,3);}\n', True, None),
)


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    count = 0
    with tempfile.TemporaryDirectory(prefix='kcc-hidden-prototype-v61l.',
                                     dir=tmp) as path:
        work = Path(path)
        source = work / 'probe.c'
        for cpu in ('pdp6', 'ka10', 'ki10', 'ks10'):
            for mode in ('c89', 'c99', 'gnu89', 'gnu99'):
                for opts in ([], ['-n']):
                    for body, accepts, diagnostic in CASES:
                        source.write_text(body, encoding='ascii')
                        result = subprocess.run(
                            [str(KCC), '-P' + mode, '-S', '-v=nostats',
                             '-x=' + cpu, '-R=unit', *opts, str(source)],
                            cwd=work, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True, timeout=20)
                        if accepts:
                            failed = result.returncode != 0
                        else:
                            failed = check_kcc_rejection(result.returncode,
                                                         result.stdout) is not None
                        if failed or (diagnostic and diagnostic not in result.stdout):
                            raise AssertionError((cpu, mode, opts, body, result.stdout))
                        count += 1
    print('PASS: %d old-style and explicit-prototype arity checks' % count)


if __name__ == '__main__':
    main()
