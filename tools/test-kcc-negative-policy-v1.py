#!/usr/bin/env python3
"""Regression: an expected KCC rejection cannot conceal a crash or ICE."""

import os
from pathlib import Path
import subprocess
import sys
import tempfile

from compiler_negative_policy_v1 import ICE_RE, check_kcc_rejection


ROOT = Path(__file__).resolve().parents[1]
CHECK = ROOT / 'tools/check-kcc-rejection-v1.py'
NORMAL = '"bad.c", line 2: Primary expr expected\n? KCC - 1 error detected\n'


def require(ok, message):
    if not ok:
        raise AssertionError(message)


def main():
    examples = (
        ('ordinary rejected code', 1, NORMAL, True),
        ('multiple source errors', 2, '? KCC - 3 errors detected\n', True),
        ('ordinary error-limit rejection', 1,
         '"bad.c", line 9: Expected token (semicolon) not found\n'
         '? KCC - Fatal error: Too many errors\n', True),
        ('accepted invalid code', 0, NORMAL, False),
        ('signal with prior syntax error', 139, NORMAL, False),
        ('negative signal code', -11, NORMAL, False),
        ('timeout or interrupted process', 124, NORMAL, False),
        ('generic missing executable', 127, 'not found\n', False),
        ('empty diagnostics', 1, '', False),
        ('fatal without source diagnostics', 1,
         '? KCC - Fatal error: Too many errors\n', False),
        ('unrelated fatal problem', 1,
         '"bad.c", line 9: Bad syntax\n'
         '? KCC - Fatal error: Cannot open output file\n', False),
        ('warning only', 1, '% KCC - 1 warning detected\n', False),
        ('internal error with syntax summary', 1,
         '[Internal error] unexpected node\n' + NORMAL, False),
        ('internal compiler error with syntax summary', 1,
         'internal compiler error\n' + NORMAL, False),
        ('segmentation fault with syntax summary', 1,
         'Segmentation fault\n' + NORMAL, False),
        ('compiler bug report with syntax summary', 1,
         'please submit a full bug report\n' + NORMAL, False),
        ('nonnumeric error count', 1, '? KCC - xyz errors detected\n', False),
    )
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='kcc-negative-policy-v1.',
                                     dir=tmp) as dirname:
        log = Path(dirname) / 'compiler-v1.log'
        for description, status, diagnostics, valid in examples:
            decision = check_kcc_rejection(status, diagnostics)
            require((decision is None) == valid,
                    'incorrect library rejection: ' + description)
            log.write_text(diagnostics, encoding='ascii')
            result = subprocess.run(
                [sys.executable, str(CHECK), str(status), str(log)],
                stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            require((result.returncode == 0) == valid,
                    'incorrect CLI rejection: ' + description)
        for message in ('[Internal error]', 'internal compiler error',
                        'Segmentation fault'):
            require(ICE_RE.search(message) is not None,
                    'compiler matrix ICE detector dropped: ' + message)
    print('KCC negative rejection policy: PASS (%d library/CLI cases)' %
          len(examples))


if __name__ == '__main__':
    main()
