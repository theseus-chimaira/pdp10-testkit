#!/usr/bin/env python3
"""Fail-closed host coverage for every registered codegen source directive.

The registration audit never invokes compilers.  Small synthetic assembly
fragments verify both the individual predicates and their runner dispatch.
Real compiler-profile probes are separate, focused integration checks.
"""

import csv
import importlib.util
import os
from pathlib import Path
import re
import shlex
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
import codegen_declared_oracles_v1 as oracles
import kcc_assembly_checks
import kcc_special_checks


DIRECTIVES = frozenset((
    'codegen-policy', 'codegen-require-regex', 'codegen-forbid-regex',
    'codegen-kcc-check', 'codegen-kcc-expect-compile-fail',
    'codegen-kcc-diagnostic-require-regex', 'codegen-kcc-preprocess',
    'codegen-forbid', 'codegen-require', 'codegen-forbid-form',
    'codegen-kcc-extra', 'codegen-expect-compile-fail',
    'codegen-kcc-special', 'codegen-kcc-diagnostic-forbid-regex',
    'codegen-require-macro', 'codegen-forbid-macro',
    'codegen-require-symbol', 'codegen-kcc-diagnostic-count-regex',
    'codegen-gcc-extra', 'codegen-kcc-policy-only'))
REGEX_DIRECTIVES = frozenset((
    'codegen-require-regex', 'codegen-forbid-regex',
    'codegen-kcc-diagnostic-require-regex',
    'codegen-kcc-diagnostic-forbid-regex'))


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def load_runner():
    os.environ.setdefault('PDP10_PREFIX', str(Path.home() / 'cross'))
    spec = importlib.util.spec_from_file_location(
        'codegen_declared_oracle_runner_v1', str(ROOT / 'tools/run-tests.py'))
    runner = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(runner)
    return runner


def test_assembly_checks():
    forms = sorted(oracles.FORMS)
    require(not oracles.form_failures('POP 17,6\nJFCL 0,0\n'
                                      'SETZ 1,7\nSETO 2,17\n', forms),
            'valid accumulator forms incorrectly forbidden')
    bad = ('label: POP 017,17 ; same stack register\n'
           'jfcl 1,0\nset 1,foo\n'
           'setz 2,-1(17)\nseto 4,@bar\n')
    failures = oracles.form_failures(bad, forms)
    require(len(failures) == len(forms),
            'failed to detect each original forbidden instruction form: ' +
            repr(failures))
    require(oracles.form_failures('move 1,2\n', ['UNRECOGNIZED']) ==
            ['unknown forbidden instruction form: UNRECOGNIZED'],
            'unknown form silently accepted')
    symbols = ['$KDFAD', '$KDFSB', '$KDFMP', '$KDFDV']
    asm = ('.globl $KDFAD\n'
           'PUSHJ 17,$KDFAD\nPUSHJ 17,$KDFSB\n'
           'PUSHJ 17,$KDFMP\nPUSHJ 17,$KDFDV\n')
    require(not oracles.required_symbol_failures(asm, symbols),
            'real instruction references were not recognized')
    require(oracles.required_symbol_failures('.globl $KDFAD\n', ['$KDFAD']) ==
            ['missing referenced symbol: $KDFAD'],
            'a declaration satisfied the required call oracle')
    require(oracles.required_symbol_failures('PUSHJ 17,$KDFADX\n',
                                              ['$KDFAD']) ==
            ['missing referenced symbol: $KDFAD'],
            'partial symbol falsely satisfied original assertion')


def test_macro_source():
    source, errors = oracles.macro_probe_source(
        ['__PDP10_PDP10__'], ['__PDP10_166__'])
    require(not errors and '#ifndef __PDP10_PDP10__' in source and
            '#ifdef __PDP10_166__' in source and
            source.count('#endif') == 2,
            'macro oracle failed to preserve both source directives')
    require(oracles.macro_probe_source(['X'], ['X'])[1],
            'contradictory macro assertions silently accepted')
    require(oracles.macro_probe_source(['bad-name'], [])[1],
            'invalid C preprocessor identifier accepted')


def audit_registered_directives(runner):
    with (ROOT / 'COMPILER_MATRIX.tsv').open(encoding='utf8',newline='') as f:
        rows = list(csv.DictReader((line for line in f if line.strip() and
                                    not line.startswith('#')),delimiter='\t'))
    counted = 0
    asserted = 0
    for row in rows:
        src = ROOT / row['test']
        parsed = runner.directives(src)
        expected = {}
        for line in src.read_text(encoding='utf8', errors='replace').splitlines():
            if re.search(r'codegen-[a-z-]+\s*:',line):
                match = runner.DIRECTIVE_RE.match(line)
                require(match is not None, 'unparsed codegen assertion in ' +
                        row['test'] + ': ' + line.strip()[:100])
                expected.setdefault(match.group(1), []).extend(
                    shlex.split(match.group(2)))
        require(parsed == expected,
                'commented codegen assertion silently skipped: ' +
                row['test'])
        for name, arguments in parsed.items():
            counted += 1
            require(name in DIRECTIVES,
                    'codegen directive not executed/audited: ' +
                    row['test'] + ' ' + name)
            if name in REGEX_DIRECTIVES:
                for pattern in arguments:
                    try:
                        re.compile(pattern)
                    except re.error as exc:
                        raise AssertionError('%s: invalid regex %s: %s' %
                                             (row['test'],name,exc))
            if name == 'codegen-kcc-check':
                require(all(k in kcc_assembly_checks.CHECKS for k in arguments),
                        'unimplemented KCC assembly oracle: ' + row['test'])
            if name == 'codegen-kcc-special':
                require(all(k in kcc_special_checks.CHECKS for k in arguments),
                        'unimplemented special KCC oracle: ' + row['test'])
            if name == 'codegen-forbid-form':
                require(arguments and set(arguments) <= oracles.FORMS,
                        'unknown/empty forbidden form for ' + row['test'])
            if name == 'codegen-require-symbol':
                require(arguments and all(oracles.SYMBOL.fullmatch(s)
                                          for s in arguments),
                        'invalid required symbol for ' + row['test'])
            if name in ('codegen-require-macro','codegen-forbid-macro'):
                require(arguments and all(oracles.IDENTIFIER.fullmatch(s)
                                          for s in arguments),
                        'invalid macro check for ' + row['test'])
            if name == 'codegen-kcc-preprocess':
                require(len(arguments) == 1 and arguments[0] in
                        ('source','long-macro','long-string'),
                        'unhandled KCC preprocess variant ' + row['test'])
            if name in ('codegen-kcc-extra','codegen-gcc-extra'):
                for option in arguments:
                    if option.startswith('-I'):
                        include = Path(option[2:])
                        if not include.is_absolute():
                            include = ROOT / include
                        require(include.is_dir(), 'missing include prerequisite: '
                                + row['test'] + ' ' + option)
            if name in ('codegen-require-macro','codegen-forbid-macro',
                        'codegen-forbid-form','codegen-require-symbol'):
                asserted += len(arguments)

        # This fixture requires the generic PDP-10 target-selection macro.
        # Native KI10/KS10 GCC profiles do not define it, so those are
        # inapplicable rather than misleadingly successful codegen tests.
        if row['test'] == 'tests/codegen/pdp10/pdp10_no_pdp6_macro.c':
            for cpu in ('ki10','ks10'):
                for opt in ('o0','o1','o2','os'):
                    key = cpu + '_gcc_' + opt
                    require(row[key] == 'no_test',
                            'generic PDP-10 macro test misregistered as ' + key)
            for cpu in ('ka10','ki10','ks10'):
                for opt in ('o0','o1','o2','os'):
                    require(row[cpu + '_gcc_pdp10_' + opt] == 'codegen',
                            'original PDP-10 GCC macro oracle lost registration')
                require(row[cpu + '_pdp10'] == 'codegen',
                        'KCC PDP-10 macro failure cannot be silently hidden')
    # Six form-bearing fixtures supply 16 individual forbidden forms;
    # one fixture supplies four helper symbols; one supplies two macros.
    require(counted > 400 and asserted == 16 + 4 + 2,
            'unexpected loss of declarative codegen test inventory: '
            '%d directives, %d args' % (counted, asserted))
    return counted, asserted


def test_runner_wiring(runner, scratch):
    # Multiline C comments and single-line comment directives must both
    # survive parsing.  Text outside a C comment is never a policy.
    sample = scratch / 'directive-parse-v1.c'
    sample.write_text('/* original fixture\n'
                      ' * codegen-require-regex: "foo\\\\bar"\n'
                      ' */\n'
                      '/* codegen-forbid: JFCL */\n'
                      'int var;\n', encoding='ascii')
    parsed = runner.directives(sample)
    require(parsed.get('codegen-forbid') == ['JFCL'] and
            len(parsed.get('codegen-require-regex', [])) == 1,
            'multiline GCC assembly assertions lost during parsing')
    for name in ('asm-2.c', 'asm-3.c'):
        source_path = ROOT / 'tests/codegen/gcc-historical-b04-v1' / name
        require(len(runner.directives(source_path).get(
            'codegen-require-regex', [])) == 1,
            'historical GCC inline-assembler scan was ignored: ' + name)

    source = 'tests/codegen/pdp10/pdp10_double_helpers_required.c'
    profiles = runner.all_profiles()
    selected = [p for p in profiles if p['compiler']=='kcc' and
                p['family']=='pdp10' and p['machine']=='ka10' and
                p['optname']=='noopt']
    require(len(selected)==1,'missing PDP-10 KCC codegen profile')
    cell = dict(selected[0],kind='codegen')
    original = runner.compile_to_asm
    asm = ('PUSHJ 17,$KDFAD\nPUSHJ 17,$KDFSB\n'
           'PUSHJ 17,$KDFMP\nPUSHJ 17,$KDFDV\n')
    try:
        for text, expected in ((asm,'pass'),
                               ('PUSHJ 17,$KDFAD\n','policy_fail')):
            def emit_asm(_cell,_source,output,log,_bins):
                output.write_text(text,encoding='ascii')
                return 'pass'
            runner.compile_to_asm = emit_asm
            result = runner.run_codegen_cell(1,1,source,cell,scratch,
                                             {},announce=False)
            require(result==expected,'runner skipped referenced-symbol oracle')
    finally:
        runner.compile_to_asm = original

    source = 'tests/codegen/pdp10/pdp10_no_pdp6_macro.c'
    original_compile = runner.compile_to_asm
    original_command = runner.run_cmd
    try:
        def emit_asm(_cell,_source,output,log,_bins):
            output.write_text('move 1,2\n',encoding='ascii')
            return 'pass'
        runner.compile_to_asm = emit_asm
        for rc, expected in ((0,'pass'),(1,'policy_fail'),
                             (124,'timeout'),(127,'setup_fail'),
                             (139,'compiler_ice')):
            def fake_command(args,cwd,log,timeout=None):
                generated = (Path(cwd)/'macro-oracle-v1.c').read_text()
                require('#ifndef __PDP10_PDP10__' in generated and
                        '#ifdef __PDP10_166__' in generated,
                        'runner lost original macro assertions')
                return rc
            runner.run_cmd = fake_command
            result = runner.run_codegen_cell(1,1,source,cell,scratch,
                                             {'kcc':Path('/fake-kcc')},
                                             announce=False)
            require(result==expected,'macro probe rc %d became %s' %
                    (rc,result))
    finally:
        runner.compile_to_asm = original_compile
        runner.run_cmd = original_command


def main():
    runner = load_runner()
    test_assembly_checks()
    test_macro_source()
    count, asserted = audit_registered_directives(runner)
    tmp = Path(os.environ.get('TMPDIR') or Path.home()/'tmp')
    tmp.mkdir(parents=True,exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='codegen-oracles-v1-',dir=tmp) as p:
        test_runner_wiring(runner, Path(p))
    print('Codegen declared oracles: PASS (%d directives, %d previously '
          'unhandled assertions, synthetic runner mutation checks)' %
          (count, asserted))


if __name__ == '__main__':
    main()
