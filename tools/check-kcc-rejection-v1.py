#!/usr/bin/env python3
"""Fail-closed checker for standalone KCC expected-rejection scripts."""

import sys
from pathlib import Path
from compiler_negative_policy_v1 import check_kcc_rejection


def main(argv):
    if len(argv) < 2:
        raise SystemExit('usage: check-kcc-rejection-v1.py EXIT_CODE LOG...')
    try:
        status = int(argv[0], 10)
    except ValueError:
        raise SystemExit('invalid numeric compiler exit code')
    diagnostics = '\n'.join(Path(p).read_text(encoding='utf-8',
                             errors='replace') for p in argv[1:])
    cause = check_kcc_rejection(status, diagnostics)
    if cause:
        print('KCC rejection policy: FAIL: ' + cause, file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
