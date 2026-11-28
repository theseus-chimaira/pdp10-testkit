#!/usr/bin/env python3
"""Preserve strict-mode rejection of the GNU literal difference."""

import os
from pathlib import Path
import subprocess
import tempfile

from compiler_negative_policy_v1 import check_kcc_rejection

ROOT = Path(__file__).resolve().parents[1]
KCC = Path(os.environ['PDP10_PREFIX']) / 'bin/kcc'
SOURCE = ROOT / 'tests/codegen/upstream-gcc/compile/20001116-1.c'


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='kcc-literal-difference-v61k.',
                                     dir=tmp) as work:
        for cpu in ('pdp6', 'ka10', 'ki10', 'ks10'):
            for mode in ('c89', 'c99', 'gnu89', 'gnu99'):
                for opts in ([], ['-n']):
                    result = subprocess.run(
                        [str(KCC), '-P' + mode, '-S', '-v=nostats',
                         '-x=' + cpu, '-R=unit', *opts, str(SOURCE)],
                        cwd=work, stdout=subprocess.PIPE,
                        stderr=subprocess.STDOUT, text=True, timeout=20)
                    if mode.startswith('gnu'):
                        if result.returncode:
                            raise AssertionError((cpu, mode, opts, result.stdout))
                    else:
                        decision = check_kcc_rejection(result.returncode,
                                                       result.stdout)
                        if decision is not None or 'Integer constant required as initializer' not in result.stdout:
                            raise AssertionError((cpu, mode, opts, decision, result.stdout))
    print('PASS: 16 GNU accepts and 16 strict rejections')


if __name__ == '__main__':
    main()
