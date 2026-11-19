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
import subprocess
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

    # A single selected test must never implicitly launch its entire group
    # or turn one of the 19 explicit manual roots into automatic coverage.
    by_id = {r['id']: r for r in registered}
    require(len(by_id) == len(registered), 'duplicate registered test ID')
    enabled_id = 'test-script-ownership-v4'
    manual_id = 'kcc-pdp6-rounded-fp-boundaries-v2'
    nested_id = next(r['id'] for r in registered
                     if r['group'] == 'das' and r['profile'] == 'nested')
    require(by_id[enabled_id]['enabled'] == 'yes', 'enabled fixture changed')
    require(by_id[manual_id]['enabled'] == 'manual', 'manual fixture changed')

    def rejected(fn, expected):
        try:
            fn()
        except SystemExit as exc:
            require(expected in str(exc), 'wrong single-test rejection: ' +
                    str(exc))
            return
        raise AssertionError('single-test guard did not reject: ' + expected)

    observed[:] = []
    dispatcher.run = record
    try:
        with contextlib.redirect_stdout(io.StringIO()):
            dispatcher.run_selected(enabled_id)
        require(observed == [('python3', str(ROOT / by_id[enabled_id]['path']))],
                'single enabled test was not dispatched exactly once')
        observed[:] = []
        rejected(lambda: dispatcher.run_selected(manual_id),
                 'requires explicit --manual')
        require(not observed, 'manual test executed without flag')
        with contextlib.redirect_stdout(io.StringIO()):
            dispatcher.run_selected(manual_id, allow_manual=True)
        require(observed == [('sh', str(ROOT / by_id[manual_id]['path']))],
                'selected manual test was not dispatched exactly once')
        observed[:] = []
        rejected(lambda: dispatcher.run_selected(nested_id, True),
                 'nested DAS helper')
        with contextlib.redirect_stdout(io.StringIO()):
            dispatcher.run_selected('das-build-das-native', allow_manual=True)
        require(observed == [('sh', str(ROOT / by_id['das-build-das-native']['path']))],
                'self-contained manual DAS native build was not dispatched once')
        observed[:] = []
        source_var = 'PDP10_DEFERRED_LIBC_SOURCE'
        previous_source = os.environ.pop(source_var, None)
        try:
            rejected(lambda: dispatcher.run_selected('deferred-libc-probe-v1', True),
                     'requires PDP10_DEFERRED_LIBC_SOURCE')
            require(not observed, 'unspecified deferred source was executed')
            source = 'tests/semantic/upstream/generic/20000910-2.c'
            os.environ[source_var] = source
            with contextlib.redirect_stdout(io.StringIO()):
                dispatcher.run_selected('deferred-libc-probe-v1', True)
            require(observed == [('python3',
                                  str(ROOT / by_id['deferred-libc-probe-v1']['path']),
                                  '--source', source)],
                    'explicit deferred source was not dispatched exactly once')
        finally:
            if previous_source is None:
                os.environ.pop(source_var, None)
            else:
                os.environ[source_var] = previous_source
        observed[:] = []
        rejected(lambda: dispatcher.run_selected('does-not-exist-v1', True),
                 'unknown or duplicate')
        require(not observed, 'an invalid or nested selected test ran')
        # A root requiring a prepared build or media must not be run in a
        # made-up environment.  Run its named suite instead.
        tools_id = next(r['id'] for r in registered
                        if r['group'] == 'tools' and r['enabled'] == 'yes')
        rejected(lambda: dispatcher.run_selected(tools_id),
                 'requires suite preparation')
        require(not observed, 'suite-prepared test executed without setup')
    finally:
        dispatcher.run = original_run

    listing = subprocess.run(['sh', str(ROOT / 'run-misc-tests.sh'),
                              'list-manual'], cwd=ROOT, env=os.environ,
                             text=True, stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, check=True)
    expected_manual = [r['id'] for r in registered
                       if r['enabled'] == 'manual']
    listed = [line.split('\t', 1)[0] for line in
              listing.stdout.splitlines()]
    require(listed == expected_manual,
            'list-manual dropped, reordered or invented manual roots')
    require(len(listed) == 18,
            'current standalone manual gate count changed; review policy')

    total_enabled = sum(r['enabled'] == 'yes' and
                        not (r['group'] == 'das' and r['profile'] == 'nested')
                        for r in registered)
    require(checked == total_enabled,
            'not every enabled direct registration has a route')
    print('Special suite dispatch: PASS (%d direct enabled tests, '
          '%d suite entrypoints, %d manually gated roots, '
          'exact-ID selection with no nested/manual double dispatch)' %
          (checked, len(expected_routes) + 1, len(listed)))


if __name__ == '__main__':
    main()
