#!/usr/bin/env python3
"""Host-only contract checks for pinned GCC and KCC diagnostic oracles.

No compiler invocation. The selected five-cell integration pilot is
recorded separately and is not run from the host verification subgroup.
"""

import csv
import importlib.util
import os
from pathlib import Path
import re
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
import diagnostic_oracles_v1 as diagnostic


def require(test, detail):
    if not test:
        raise AssertionError(detail)


def runner():
    os.environ.setdefault('PDP10_PREFIX', str(Path.home() / 'cross'))
    spec = importlib.util.spec_from_file_location(
        'registered_diagnostic_runner_v1', str(ROOT / 'tools/run-tests.py'))
    loaded = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(loaded)
    return loaded


def matrix():
    with (ROOT / 'COMPILER_MATRIX.tsv').open(encoding='ascii') as file:
        return list(csv.DictReader((line for line in file if
                                    not line.startswith('#')),delimiter='\t'))


def check_registry():
    rows = diagnostic.read_oracles()
    registered = matrix()
    require(len(rows) == 4, 'unexpected change to initial diagnostic pilot')
    require(not diagnostic.validate_registry(rows, registered),
            'invalid source hash, compiler ownership or diagnostic syntax')
    by_source = {}
    for row in rows:
        original = (ROOT / row['original']).read_text(encoding='latin1')
        if row['compiler'] == 'gcc':
            # GCC assertions must retain the exact original dg regexp,
            # source line and dg-options, rather than using an easy synonym.
            match = re.search(r'dg-' + row['severity'] +
                              r'\s+"([^"]+)"', original)
            require(match is not None and row['regex'] == match.group(1),
                    'GCC original diagnostic regexp changed: '+row['source'])
            options = re.search(r'dg-options\s+"([^"]*)"', original)
            require(row['options'] == (options.group(1) if options else ''),
                    'GCC original dg-options changed: '+row['source'])
            source_lines = original.splitlines()
            require('dg-' + row['severity'] in source_lines[int(row['line'])-1],
                    'GCC original diagnostic line changed: '+row['source'])
        by_source.setdefault(row['source'],set()).add(row['compiler'])
    require(len(by_source) == 3 and
            sum(len(c) for c in by_source.values()) == 4,
            'incorrect original-source ownership')
    # A missing original source or a removed KCC cross-compiler diagnostic
    # must not become unobserved when a new fixture is registered.
    expected = {
        'tests/diagnostic/gcc-historical-v1/cpp-19990413-1.c':
            ('pdp6','pdp6_gcc_o0'),
        'tests/diagnostic/gcc-historical-v1/return-type-1.c':
            ('pdp6_gcc_o1',),
        'tests/diagnostic/gcc-historical-v1/unused-1.c':
            ('pdp6_gcc_o1',)}
    for row in registered:
        if row['test'] not in expected:
            continue
        actual={k for k,v in row.items() if v=='pending'}
        require(actual == set(expected[row['test']]),
                'diagnostic profile assertion silently changed: '+row['test'])
    return rows


def check_decisions(rows):
    by = {(r['source'].split('/')[-1],r['compiler']):r for r in rows}
    gcc = by['return-type-1.c','gcc']
    good = ('tests/diagnostic/gcc-historical-v1/return-type-1.c:9: '
            'warning: control reaches end of non-void function\n')
    for status,output,expected in (
            ('pass',good,'pass'),
            ('pass',good.replace(':9:',':8:'),'policy_fail'),
            ('pass',good.replace('warning:','note:'),'policy_fail'),
            ('pass',good.replace('return-type-1.c:','unrelated.c:'),
             'policy_fail'),
            ('fail',good,'policy_fail'),
            ('timeout',good,'timeout'),
            ('signal',good,'compiler_ice'),
            ('setup_fail',good,'setup_fail'),
            ('pass',good+'internal compiler error\n','compiler_ice')):
        result,_why = diagnostic.check_diagnostics(
            'gcc','accept',[gcc],status,output)
        require(result==expected,'GCC diagnostic status/line regression: '+
                status+'/'+expected+'/'+result)

    kcc = by['cpp-19990413-1.c','kcc']
    prefix='"tests/diagnostic/gcc-historical-v1/cpp-19990413-1.c", line 12: '
    source = prefix + 'Primary expr expected\n? KCC - 2 errors detected\n'
    for status,output,expected in (
            ('fail',source,'pass'),
            ('fail',source.replace('line 12','line 11'),'policy_fail'),
            ('pass',source,'policy_fail'),
            ('fail',source.replace('? KCC - 2 errors detected',''),
             'policy_fail'),
            ('fail',source.replace('Primary expr expected',
                                   '[Note] Primary expr expected'),
             'policy_fail')):
        result,_why=diagnostic.check_diagnostics(
            'kcc','reject',[kcc],status,output)
        require(result==expected,'KCC diagnostic source-line test failed: '+
                repr((status,expected,result)))

    gcc_bad = by['cpp-19990413-1.c','gcc']
    old = ('tests/diagnostic/gcc-historical-v1/cpp-19990413-1.c:12: '
           'parse error before "else"\n')
    current=old.replace('parse error','syntax error')
    require(diagnostic.check_diagnostics('gcc','reject',[gcc_bad],
                                         'fail',old)[0]=='pass',
            'original GCC source-line error no longer matches')
    require(diagnostic.check_diagnostics('gcc','reject',[gcc_bad],
                                         'fail',current)[0]=='policy_fail',
            'GCC changed wording incorrectly made green')

    bogus=dict(gcc,severity='bogus')
    require(diagnostic.check_diagnostics('gcc','accept',[bogus],
                                         'pass',good)[0]=='policy_fail',
            'forbidden diagnostic was ignored')
    require(diagnostic.check_diagnostics('gcc','accept',[bogus],
                                         'pass','')[0]=='pass',
            'absence of forbidden diagnostic incorrectly failed')


def check_runner_wiring(r, temporary):
    source='tests/diagnostic/gcc-historical-v1/return-type-1.c'
    chosen=[p for p in r.all_profiles() if p['compiler']=='gcc' and
            p['machine']=='pdp6' and p['family']=='native' and
            p['optname']=='o1']
    require(len(chosen)==1,'missing targeted GCC source profile')
    cell=dict(chosen[0],kind='diagnostic')
    original=r.compile_to_asm
    observed=[]
    try:
        for emitted,expected in ((True,'pass'),(False,'policy_fail')):
            def fake_compile(_cell,_source,asm,log,_bins,extra_options=()):
                observed.append(tuple(extra_options))
                asm.write_text('move 1,2\n',encoding='ascii')
                if emitted:
                    log.write_text(source+':9: warning: control reaches '
                                   'end of non-void function\n')
                return 'pass'
            r.compile_to_asm=fake_compile
            result=r.run_diagnostic_cell(1,1,source,cell,temporary,
                                         {},announce=False)
            require(result==expected,'diagnostic runner skipped original oracle')
            status=r.read_cell_status(temporary,source,cell)
            require(status and status['status']==result and
                    status['kind']=='diagnostic',
                    'restart checkpoint lost diagnostic outcome')
    finally:
        r.compile_to_asm=original
    require(observed==[('-O','-Wreturn-type')]*2,
            'diagnostic runner dropped original GCC command options')


def main():
    rows=check_registry()
    check_decisions(rows)
    r=runner()
    temporary=Path(os.environ.get('TMPDIR') or Path.home()/'tmp')
    temporary.mkdir(parents=True,exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='diagnostic-oracles-v1-',
                                     dir=temporary) as path:
        check_runner_wiring(r,Path(path))
    print('Diagnostic oracles v1: PASS (3 original sources, 4 compiler '
          'oracles, line/severity/options mutations, runner checkpoints)')


if __name__=='__main__':
    main()
