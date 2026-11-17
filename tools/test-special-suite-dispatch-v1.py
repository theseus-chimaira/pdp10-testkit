#!/usr/bin/env python3
"""Check real special-suite routing without executing guest/toolchain jobs.

The registry is authoritative.  A fake execution function records each
subprocess that the installed dispatcher would invoke.  This tests routing,
ordering, isolation and profile filtering, not a script's own assertions.
"""

import contextlib
import csv
import importlib.util
import io
import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
os.environ.setdefault('PDP10_PREFIX', str(Path.home() / 'cross'))
MODULE = ROOT / 'tools/run-misc-suites.py'


def require(condition, reason):
    if not condition:
        raise AssertionError(reason)


def main():
    spec = importlib.util.spec_from_file_location('testkit_special_dispatch_v1',
                                                  str(MODULE))
    dispatcher = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(dispatcher)
    with (ROOT / 'SPECIAL_TESTS.tsv').open(encoding='ascii', newline='') as stream:
        registered = list(csv.DictReader(stream, delimiter='\t'))

    # Check actual registry-to-execution mapping, not hypothetical files.
    observed = []
    original_run = dispatcher.run

    def record(*args, **kwargs):
        observed.append(tuple(str(s) for s in args))

    dispatcher.run = record
    checked = 0
    try:
        for group in sorted(set(r['group'] for r in registered)):
            cases = [r for r in registered if r['group'] == group]
            if group == 'das':
                selections = [{'fast'}, {'full'}, {'native'}]
            else:
                selections = [None]
            for profiles in selections:
                observed[:] = []
                with contextlib.redirect_stdout(io.StringIO()):
                    failures = dispatcher.run_special(group, profiles=profiles)
                require(failures == 0,
                        'special suite rejected an enabled registered script: ' + group)
                expected = [r for r in cases
                            if r['enabled'] == 'yes' and
                            (profiles is None or r['profile'] in profiles)]
                commands = [(r['runner'], str(ROOT / r['path'])) for r in expected]
                require(observed == commands,
                        'registered scripts are not dispatched once, in order: ' +
                        group + '/' + str(profiles))
                checked += len(expected)
        # Fast/full/native routes were checked above against exact expected
        # paths.  Confirm separately that the registry still defines the
        # nested-only helpers and never marks them as direct manual runs.
        nested = [row for row in registered
                  if row['group'] == 'das' and row['profile'] == 'nested']
        require(len(nested) == 6 and all(row['enabled'] == 'yes'
                                         for row in nested),
                'DAS nested helper ownership changed unexpectedly')
        routes = []
        original_special = dispatcher.run_special

        def record_special(group, env=None, profiles=None):
            routes.append((group, tuple(sorted(profiles or ()))))
            return 0

        dispatcher.run_special = record_special
        try:
            expected_routes = {
                'verify': [('verify', ()), ('compat', ()),
                           ('validation', ())],
                'compat': [('compat', ())],
                'das-fast': [('das', ('fast',))],
                'das': [('das', ('fast',)), ('das', ('full',))],
                'das-native': [('das', ('native',))],
                'gcc-bare-libgcc': [('gcc-bare-libgcc', ())],
                'pdp10-tools': [('tools', ())],
                'kcc-regression': [('kcc-regression', ())],
                'kcc-host': [('kcc-host', ())],
                'kcc-all': [('kcc-regression', ()), ('kcc-host', ())],
            }
            # These suite entrypoints depend on real sibling repositories
            # existing; such prerequisites are separate from route logic.
            for suite, expected in expected_routes.items():
                routes[:] = []
                try:
                    with contextlib.redirect_stdout(io.StringIO()):
                        dispatcher.main(suite)
                except SystemExit as e:
                    raise AssertionError('suite prerequisite missing: %s: %s' %
                                         (suite, e))
                require(routes == expected,
                        'suite entrypoint changed registered groups: ' + suite)
            routes[:] = []
            observed[:] = []
            with contextlib.redirect_stdout(io.StringIO()):
                dispatcher.main('kcc-semantic')
            require(routes == [] and observed == [('./run-tests.sh',
                                                     '--kind', 'semantic')],
                    'kcc-semantic should delegate only to matrix runner')
        finally:
            dispatcher.run_special = original_special
    finally:
        dispatcher.run = original_run

    total_enabled = sum(r['enabled'] == 'yes' and
                        not (r['group'] == 'das' and r['profile'] == 'nested')
                        for r in registered)
    require(checked == total_enabled,
            'not every enabled direct registration has a route')
    print('Special suite dispatch: PASS (%d direct enabled tests, '
          '%d suite entrypoints, no nested/manual double dispatch)' %
          (checked, len(expected_routes) + 1))


if __name__ == '__main__':
    main()
