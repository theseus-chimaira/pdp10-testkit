#!/usr/bin/env python3
"""Check literal size syntax and invalid contexts without running bad C."""
import os
from pathlib import Path
import subprocess
import tempfile
from compiler_negative_policy_v1 import check_kcc_rejection

KCC = Path(os.environ['PDP10_PREFIX']) / 'bin/kcc'
GOOD = (
    'typedef unsigned int T __attribute__((size(0x7U))); T a;',
    'typedef unsigned __attribute__((__size__(010))) T; T a;',
    'typedef signed int T __attribute__((size(18), unused)); T a;',
    'typedef unsigned int T __attribute__((size(9), size(9))); T a;',
    'unsigned char6; int f(void) { return sizeof(char6); }',
    'typedef signed _KCCtype_char6 char6; char6 a;',
    'char6 a; int f(void) { return sizeof(char6) + (char6)-1; }',
)
BAD = (
    'typedef unsigned T __attribute__((size(0)));',
    'typedef unsigned T __attribute__((size(5)));',
    'typedef unsigned T __attribute__((size(72)));',
    'typedef unsigned T __attribute__((size(68719476743ULL)));',
    'typedef unsigned T __attribute__((size(7+1)));',
    'typedef unsigned T __attribute__((size(7,8)));',
    'typedef unsigned T __attribute__((size()));',
    'typedef unsigned T __attribute__((size(-7)));',
    'typedef unsigned T __attribute__((size(foo)));',
    'typedef unsigned T __attribute__((size));',
    'typedef unsigned T __attribute__((size(7), size(8)));',
    'typedef float T __attribute__((size(7)));',
    'typedef int *T __attribute__((size(7)));',
    'typedef unsigned T[2] __attribute__((size(7)));',
    'int f(void) __attribute__((size(7)));',
    'int x = 1 __attribute__((size(7))); int y;',
    '__attribute__((size(7))) struct S { int member; } x;',
)

def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    count = 0
    with tempfile.TemporaryDirectory(prefix='kcc-size-attribute-v61n.', dir=tmp) as path:
        work = Path(path)
        source = work / 'probe.c'
        for cpu in ('pdp6', 'ka10', 'ki10', 'ks10'):
            for opts in ([], ['-n']):
                for accepts, cases in ((True, GOOD), (False, BAD)):
                    for body in cases:
                        source.write_text(body+'\n', encoding='ascii')
                        result = subprocess.run([str(KCC), '-Pgnu99', '-S', '-v=nostats', '-x='+cpu,
                            '-R=unit', *opts, str(source)], cwd=work, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True, timeout=20)
                        failed = result.returncode != 0 if accepts else check_kcc_rejection(result.returncode, result.stdout) is not None
                        if failed:
                            raise AssertionError((cpu, opts, body, result.stdout))
                        count += 1
    print('PASS: %d literal-size and scope checks' % count)

if __name__ == '__main__':
    main()
