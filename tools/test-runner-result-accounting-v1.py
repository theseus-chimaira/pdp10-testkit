#!/usr/bin/env python3
"""Fail-closed restart, worker, and compiler-exit accounting regression.

Uses synthetic checkpoints and a mocked command exit code.  Real GCC
compiler integration is checked separately and is not a prerequisite for
running the host verification suite.
"""

import contextlib
import csv
import importlib.util
import io
import os
from pathlib import Path
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))


def load_runner():
    path = ROOT / 'tools/run-tests.py'
    spec = importlib.util.spec_from_file_location('testkit_runner_v1', str(path))
    runner = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    return runner


def require(value, description):
    if not value:
        raise AssertionError(description)


def test_restart_and_summary(runner, outroot):
    profiles = []
    src = 'tests/negative/upstream-gcc/gcc-dg-noncompile/20000901-1.c'
    for index, status in enumerate(('pass', 'compile_only', 'setup_fail',
                                    'running', 'unexpected_status', 'not_run')):
        profile = {'compiler': 'gcc', 'profile': 'gcc-pdp6-o2-%d' % index,
                   'machine': 'pdp6', 'arch': 'pdp6', 'family': 'native',
                   'opt': '-O2', 'kind': 'negative'}
        profiles.append((src, profile))
        if status != 'not_run':
            runner.write_status_file(
                outroot, [src, profile['machine'], profile['compiler'],
                          profile['profile'], profile['kind'], status,
                          '0.01', '', 'synthetic'])

    rows = runner.collect_selected_statuses(outroot, [], profiles)
    require([r['status'] for r in rows] ==
            ['pass', 'compile_only', 'setup_fail', 'running',
             'unexpected_status', 'not_run'], 'unexpected status census')
    counts = runner.status_counts(rows)
    require(runner.failure_count_from_counts(counts) == 4,
            'incomplete and unknown statuses must count as failures')
    failed = runner.write_failures(outroot, [], profiles)
    require(len(failed) == 4 and
            {r['status'] for r in failed} ==
            {'setup_fail', 'running', 'unexpected_status', 'not_run'},
            'failures.tsv silently lost an incomplete checkpoint')
    with (outroot / 'failures.tsv').open(encoding='utf8', newline='') as stream:
        recorded = list(csv.DictReader(stream, delimiter='\t'))
    require([r['status'] for r in recorded] == [r['status'] for r in failed],
            'persisted failure report disagrees with selected checkpoints')

    rerun, selected, account, _old = runner.plan_restart(
        outroot, [], profiles, skip_failures=True)
    require(not rerun and account['to_run'] == 3 and
            len(selected) == 3 and account['old_skipped'] == 3,
            '--skip-failures must retry running, invalid and missing cells')
    require({runner.read_cell_status(outroot, path, cell)['status']
             if runner.read_cell_status(outroot, path, cell) else 'not_run'
             for path, cell in selected} ==
            {'running', 'unexpected_status', 'not_run'},
            'retry selection lost incomplete checkpoints')

    rerun, selected, account, _old = runner.plan_restart(
        outroot, [], profiles, skip_failures=False)
    require(not rerun and account['to_run'] == 4 and
            len(selected) == 4 and account['old_skipped'] == 2,
            'default restart must also retry known failures')


def test_worker_failure(runner, outroot):
    source = 'tests/negative/upstream-gcc/gcc-dg-noncompile/20001228-1.c'
    cell = {'compiler': 'gcc', 'profile': 'gcc-pdp6-o2',
            'machine': 'pdp6', 'arch': 'pdp6', 'family': 'native',
            'opt': '-O2', 'kind': 'negative'}
    original = runner.run_negative_cell

    def fail(*_args, **_kwargs):
        raise RuntimeError('injected worker failure')

    runner.run_negative_cell = fail
    try:
        task = (1, 1, 'negative', source, cell, outroot, {}, None)
        result = runner.run_cell_worker(task)
        require(result[6] == 'setup_fail' and
                'injected worker failure' in result[7],
                'worker exception returned a success result')
        checkpoint = runner.read_cell_status(outroot, source, cell)
        require(checkpoint and checkpoint['status'] == 'setup_fail',
                'worker exception did not persist a failing checkpoint')
        log_path = runner.cell_dir(outroot, source, cell) / 'cell.log'
        require('WORKER_EXCEPTION' in log_path.read_text(encoding='utf8'),
                'worker exception log not persisted')
        require(runner.failure_count_from_counts({'setup_fail': 1}) == 1,
                'worker setup failure did not count as a failure')

        # The sequential and parallel paths share run_cell_worker; the
        # sequential scheduler must also record the failure, not raise it.
        with contextlib.redirect_stdout(io.StringIO()):
            _total, passed, only, failed = runner.run_cells_parallel(
                [], [(source, cell)], outroot, {}, None, jobs=1)
        require((_total, passed, only, failed) == (1, 0, 0, 1),
                'sequential worker exception was not counted as failure')
    finally:
        runner.run_negative_cell = original


def test_reserved_compiler_exits(runner, outroot):
    # The GCC output is immaterial: the mocked command return code drives
    # the compile-to-assembler exit classification.
    source = 'tests/negative/upstream-gcc/gcc-dg-noncompile/20000901-1.c'
    cell = {'compiler': 'gcc', 'profile': 'gcc-pdp6-o2',
            'machine': 'pdp6', 'arch': 'pdp6', 'family': 'native',
            'opt': '-O2', 'kind': 'negative'}
    asm = outroot / 'synthetic-v1.s'
    asm.write_text('move 1,2\n', encoding='ascii')
    log = outroot / 'synthetic-v1.log'
    original = runner.run_cmd
    try:
        for rc, expected in ((0, 'pass'), (1, 'fail'),
                             (124, 'timeout'), (125, 'setup_fail'),
                             (126, 'setup_fail'), (127, 'setup_fail'),
                             (128, 'signal'), (139, 'signal'),
                             (-11, 'signal')):
            runner.run_cmd = lambda *_args, **_kwargs: rc
            observed = runner.compile_to_asm(
                cell, source, asm, log, {'gcc': Path('/nonexistent-gcc')})
            require(observed == expected,
                    'compiler exit %d incorrectly classified as %s' %
                    (rc, observed))
    finally:
        runner.run_cmd = original

    require([runner.compile_failure_status(s) for s in
             ('fail', 'no_output', 'timeout', 'setup_fail', 'signal')] ==
            ['compile_fail', 'compile_fail', 'timeout',
             'setup_fail', 'compiler_ice'],
            'failed compilation lost setup/signal classification')
    require(runner.compile_failure_status(
                'fail', 'source.c:11: Internal compiler error in '
                'instantiate_virtual_regs_1, at function.c:4444\n') ==
            'compiler_ice',
            'source-located GCC 3.2 ICE must not be called compile_fail')
    require(runner.compile_failure_status(
                'fail', 'source.c:11: syntax error before a variable\n') ==
            'compile_fail',
            'ordinary compiler rejection must not become an ICE')
    require([runner.p10run_failure_status(rc, diagnostic) for rc, diagnostic in
             ((0, ''), (1, 'dlink: undefined symbol\np10run: link failed\n'),
              (1, 'FAIL: __test_exit: got 1 expected 0\n'),
              (124, 'p10run: link failed\n'),
              (125, ''), (126, ''), (127, ''),
              (-9, ''), (139, ''),
              (127, 'p10run: link failed\n'))] ==
            ['pass', 'link_fail', 'run_fail', 'timeout',
             'setup_fail', 'setup_fail', 'setup_fail',
             'setup_fail', 'setup_fail', 'setup_fail'],
            'p10run link, guest assertion, launcher and timeout are conflated')
    require('link_fail' in runner.FAIL_STATUSES,
            'linker failures must not be skipped as unknown status')
    report = outroot / 'step-exhausted-v1.report.txt'
    report.write_text('Step expired, PC: 001256 (JUMPGE 6,1260)\n',
                      encoding='ascii')
    require(runner.p10run_step_limit_exhausted(report),
            'SIMH step exhaustion not detected')
    require(runner.p10run_failure_status(
                1, 'FAIL: __test_exit: got 1 expected 0\n',
                runner.p10run_step_limit_exhausted(report)) == 'timeout',
            'unfinished simulator steps classified as guest assertion')
    require(runner.p10run_failure_status(
                1, 'p10run: link failed\n', True) == 'link_fail',
            'step budget masked an actual link failure')
    report.write_text('HALT instruction, PC: 000000\n', encoding='ascii')
    require(not runner.p10run_step_limit_exhausted(report) and
            runner.p10run_failure_status(1, '', False) == 'run_fail',
            'guest abort falsely classified as step exhaustion')
    report.write_text(
        '========== p10run report ==========\n'
        'machine=pdp6\nrc=124\nresult=FAIL\n'
        '========== simh output ==========\nPC: 001000\n',
        encoding='ascii')
    require(runner.p10run_simulator_wall_timeout(report),
            'SIMH rc=124 report not classified as timeout')
    require(runner.p10run_failure_status(
                1, 'FAIL: SIMH exited with status 124\n',
                runner.p10run_simulator_wall_timeout(report)) == 'timeout',
            'p10run exit 1 with SIMH wall timeout mistaken for guest failure')
    report.write_text(
        '========== p10run report ==========\n'
        'machine=pdp6\nrc=124\nresult=PASS\n'
        '========== simh output ==========\n',
        encoding='ascii')
    require(not runner.p10run_simulator_wall_timeout(report),
            'invalid PASS report with rc=124 accepted as SIMH timeout')
    report.write_text(
        '========== p10run report ==========\n'
        'machine=pdp6\nrc=0\nresult=FAIL\n'
        '========== simh output ==========\n'
        'HALT instruction, PC: 000000\n',
        encoding='ascii')
    require(not runner.p10run_simulator_wall_timeout(report),
            'completed guest abort classified as SIMH timeout')


def test_kcc_dimode_helper_ownership(runner):
    """Four compiler helper entrypoints share one real installed source."""
    symbols = ('__kcc_divdi3', '__kcc_moddi3',
               '__kcc_udivdi3', '__kcc_umoddi3')
    for symbol in symbols:
        require(symbol in runner.KCC_RUNTIME_SYMBOLS,
                'missing KCC DImode runtime helper ownership: ' + symbol)
        require(runner.kcc_runtime_fragment_name('pdp6', symbol) ==
                'kccrt-dimode-div.s', 'wrong DImode member: ' + symbol)
    files, error = runner.kcc_runtime_fragments('pdp6', symbols)
    require(error is None and len(files) == 1,
            'installed DImode runtime helper unavailable or duplicated')
    require(all(runner.runtime_defines_symbol(runner.read_text(files[0]), sym)
                for sym in symbols), 'installed DImode entrypoint absent')


def test_kcc_df_helper_ownership(runner):
    symbols = ("__kcc_dfadd_rt_v62a", "__kcc_dfsub_rt_v62a",
               "__kcc_dfmul_rt_v62a", "__kcc_dfdiv_rt_v62a")
    files, error = runner.kcc_runtime_fragments("pdp6", symbols)
    require(error is None and len(files) == 4,
            "D-format core or operation member missing or duplicated")
    for sym in symbols:
        require(any(runner.runtime_defines_symbol(runner.read_text(f), sym)
                    for f in files), "D-format entrypoint absent: " + sym)
    files, error = runner.kcc_runtime_fragments("ka10", symbols[:1])
    require(error is None and len(files) == 2,
            "D-format add must select only add and core")


def test_preserve_first_missing_libc_error(runner, outroot):
    """A valid KCC runtime helper cannot erase an earlier libc setup error."""
    source = 'tests/semantic/kcc-libc-freestanding-v1.c'
    cell = {'compiler': 'kcc', 'profile': 'kcc-pdp6-noopt',
            'machine': 'pdp6', 'arch': 'pdp6', 'family': 'native',
            'optname': 'noopt', 'kind': 'semantic'}
    old_compile = runner.compile_to_asm
    old_find = runner.find_kcc_freestanding
    old_cmd = runner.run_cmd

    def compiled(_cell, _source, asm, _log, _bins):
        asm.write_text('.text\nmain:\n pushj 17,memcpy\n'
                       ' pushj 17,__kcc_umoddi3\n popj 17,\n',
                       encoding='ascii')
        return 'pass'

    def forbidden(*_args, **_kwargs):
        raise AssertionError('p10run launched after missing libc member')

    try:
        runner.compile_to_asm = compiled
        runner.find_kcc_freestanding = lambda _name: None
        runner.run_cmd = forbidden
        status = runner.run_semantic_cell(
            1, 1, source, cell, outroot, {'p10run': Path('/unused')},
            None, announce=False)
        require(status == 'setup_fail',
                'later KCC runtime success erased a missing-libc failure')
        log = runner.cell_dir(outroot, source, cell) / 'cell.log'
        require('missing kcc freestanding libc fragment' in
                log.read_text(encoding='utf8'),
                'first missing-libc setup diagnostic was lost')
    finally:
        runner.compile_to_asm = old_compile
        runner.find_kcc_freestanding = old_find
        runner.run_cmd = old_cmd


def test_missing_gcc_libc_error(runner, outroot):
    """Missing GCC runtime members must identify the failed prerequisite."""
    source = 'tests/todo/generic/991112-1.c'
    cell = {'compiler': 'gcc', 'profile': 'gcc-pdp6-o0',
            'machine': 'pdp6', 'arch': 'pdp6', 'family': 'native',
            'opt': '-O0', 'kind': 'semantic'}
    old_compile = runner.compile_to_asm
    old_find = runner.find_gcc_freestanding
    old_cmd = runner.run_cmd

    def compiled(_cell, _source, asm, _log, _bins):
        asm.write_text('.text\nmain:\n pushj 17,isprint\n popj 17,\n',
                       encoding='ascii')
        return 'pass'

    def forbidden(*_args, **_kwargs):
        raise AssertionError('p10run launched after missing GCC libc member')

    try:
        runner.compile_to_asm = compiled
        runner.find_gcc_freestanding = lambda _name: None
        runner.run_cmd = forbidden
        status = runner.run_semantic_cell(
            1, 1, source, cell, outroot, {'p10run': Path('/unused')},
            None, announce=False)
        require(status == 'setup_fail', 'missing GCC member not a setup failure')
        log = runner.cell_dir(outroot, source, cell) / 'cell.log'
        require('SETUP_FAIL missing gcc freestanding libc fragment: '
                'kcc-libc-ctype-c-locale-v1.s' in log.read_text(encoding='utf8'),
                'missing GCC member diagnostic was lost')
    finally:
        runner.compile_to_asm = old_compile
        runner.find_gcc_freestanding = old_find
        runner.run_cmd = old_cmd


def test_real_negative_policy_path(runner, outroot):
    """Use the actual negative runner, faking only the compiler invocation."""
    source = 'tests/negative/upstream-gcc/gcc-dg-noncompile/20010425-1.c'
    cell = {'compiler': 'gcc', 'profile': 'gcc-pdp6-o0',
            'machine': 'pdp6', 'arch': 'pdp6', 'family': 'native',
            'opt': '-O0', 'kind': 'negative'}
    original = runner.compile_to_asm
    cases = (
        ('fail', 'a.c:7: syntax error before `x\'\n', 'pass'),
        ('fail', 'a.c:7: warning: implicit declaration\n', 'policy_fail'),
        ('fail', 'a.c:7: syntax error\ngcc: cannot find cc1\n', 'policy_fail'),
        ('setup_fail', 'a.c:7: syntax error\n', 'setup_fail'),
        ('signal', 'a.c:7: syntax error\n', 'compiler_ice'),
        ('timeout', 'a.c:7: syntax error\n', 'timeout'),
        ('pass', '', 'unexpected_compile_success'),
    )
    try:
        for compile_result, diagnostics, expected_status in cases:
            def compile_stub(_cell, _source, _asm, log, _bins):
                log.write_text(diagnostics, encoding='ascii')
                return compile_result

            runner.compile_to_asm = compile_stub
            actual = runner.run_negative_cell(
                1, 1, source, cell, outroot, {}, announce=False)
            require(actual == expected_status,
                    'negative runner accepted wrong classification: ' +
                    compile_result + '/' + expected_status + '/' + actual)
            row = runner.read_cell_status(outroot, source, cell)
            require(row and row['status'] == expected_status,
                    'negative runner did not persist its final status')
    finally:
        runner.compile_to_asm = original


def main():
    # A host-side test exercises only runner logic, not the installed
    # cross-compiler.  The runner still needs a prefix while importing.
    os.environ.setdefault('PDP10_PREFIX', str(Path.home() / 'cross'))
    runner = load_runner()
    scratch = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    scratch.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='runner-accounting-v1-',
                                     dir=scratch) as root:
        outroot = Path(root)
        test_restart_and_summary(runner, outroot)
        test_worker_failure(runner, outroot)
        test_reserved_compiler_exits(runner, outroot)
        test_kcc_dimode_helper_ownership(runner)
        test_kcc_df_helper_ownership(runner)
        test_preserve_first_missing_libc_error(runner, outroot)
        test_missing_gcc_libc_error(runner, outroot)
        test_real_negative_policy_path(runner, outroot)
    print('Runner result accounting: PASS (restart, failures, workers, '
          'reserved compiler exit codes, KCC DImode helper ownership)')


if __name__ == '__main__':
    main()
