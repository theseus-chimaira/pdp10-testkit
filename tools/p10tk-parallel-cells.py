#!/usr/bin/env python3
"""Compatibility wrapper for the old cell-log replay helper.

Cell-log replay is intentionally disabled.  It was brittle because recorded
cell.log commands may depend on the original checkout path, PATH, and shell
setup, which can make every replayed cell fail with rc=127.

Use the native restartable runner instead:

    ./run-tests.sh -j 32 --compiler gcc --family all --cpu all --opt os
"""
from __future__ import print_function

import argparse
import os
import subprocess
import sys


def map_profile_glob(value):
    if value is None:
        return None
    v = value.strip()
    maps = {
        '*-os': 'os', '*-o2': 'o2', '*-o1': 'o1', '*-o0': 'o0',
        '*-opt': 'opt', '*-noopt': 'noopt',
    }
    return maps.get(v)


def main(argv):
    ap = argparse.ArgumentParser(description='compatibility wrapper for native parallel run-tests.py')
    ap.add_argument('-j', '--jobs', type=int, default=int(os.environ.get('P10_SWEEP_JOBS', '1')))
    ap.add_argument('--compiler', choices=('gcc', 'kcc'))
    ap.add_argument('--machine')
    ap.add_argument('--kind', choices=('semantic', 'codegen'))
    ap.add_argument('--profile-glob')
    ap.add_argument('--sweep', default='workdir/full-sweep-current')
    ap.add_argument('--skip-pass', action='store_true')
    ap.add_argument('--skip-failures', action='store_true')
    ap.add_argument('--keep-old-log', action='store_true')
    ap.add_argument('--cell-glob')
    ap.add_argument('--limit', type=int, default=0)
    ap.add_argument('--root-map', action='append', default=[])
    ap.add_argument('--progress', type=int, default=100)
    ap.add_argument('-v', '--verbose', action='store_true')
    ap.add_argument('--self-test', action='store_true')
    args = ap.parse_args(argv)

    if args.self_test:
        cmd = ['./run-tests.sh', '--list-only', '-j', str(args.jobs)]
        return subprocess.call(cmd)

    if args.cell_glob or args.limit or args.root_map or args.keep_old_log:
        print('error: cell-log replay options are no longer supported; use ./run-tests.sh -j N', file=sys.stderr)
        return 2

    cmd = ['./run-tests.sh', '-j', str(args.jobs), '--out-dir', args.sweep]
    if args.compiler:
        cmd += ['--compiler', args.compiler]
    if args.machine:
        cmd += ['--cpu', args.machine]
    if args.kind:
        cmd += ['--kind', args.kind]
    opt = map_profile_glob(args.profile_glob)
    if opt:
        cmd += ['--opt', opt]
    elif args.profile_glob:
        print('error: cannot map --profile-glob %s to --opt; use ./run-tests.sh directly' % args.profile_glob, file=sys.stderr)
        return 2
    if args.skip_failures:
        cmd += ['--skip-failures']
    print('exec: ' + ' '.join(cmd))
    return subprocess.call(cmd)


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
