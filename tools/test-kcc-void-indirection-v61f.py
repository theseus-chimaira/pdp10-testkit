#!/usr/bin/env python3
"""Check GNU void indirection against discarded pointer evaluation."""

import os
from pathlib import Path
import re
import subprocess
import tempfile

from codegen_declared_oracles_v1 import instructions
from compiler_negative_policy_v1 import check_kcc_rejection


ROOT = Path(__file__).resolve().parents[1]
KCC = Path(os.environ['PDP10_PREFIX']) / 'bin/kcc'
SOURCE = '''extern void *volatile saved;
extern volatile void *qualified(void);
void plain(void *p) { *p; }
void plainref(void *p) { (void)p; }
void pointed(volatile void *p) { *p; }
void pointedref(volatile void *p) { (void)p; }
void pointer(void) { *saved; }
void pointerref(void) { (void)saved; }
void side(void) { *qualified(); }
void sideref(void) { (void)qualified(); }
'''
NAMES = ('plain', 'pointed', 'pointer', 'side')


def compile_source(directory, source, cpu, mode, opts):
    result = subprocess.run(
        [str(KCC), '-P' + mode, '-S', '-v=nostats', '-x=' + cpu,
         '-R=unit', *opts, str(source)], cwd=directory,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True,
        timeout=20)
    return result


def body(asm, name):
    match = re.search(r'^' + re.escape(name) + r':\s*\n(.*?)'
                      r'(?=^[A-Za-z_.$%][\w.$%]*:|\Z)',
                      asm, re.M | re.S)
    if match is None:
        raise AssertionError('missing function: ' + name)
    result = list(instructions(match.group(1)))
    if not result:
        raise AssertionError('missing instructions: ' + name)
    return result


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='kcc-void-indirection-v61f.',
                                     dir=tmp) as path:
        work = Path(path)
        source = work / 'probe.c'
        source.write_text(SOURCE, encoding='ascii')
        for cpu in ('pdp6', 'ka10', 'ki10', 'ks10'):
            for opts in ([], ['-n']):
                result = compile_source(work, source, cpu, 'gnu99', opts)
                if result.returncode:
                    raise AssertionError(result.stdout)
                asm = (work / 'unit.s').read_text(encoding='ascii')
                for name in NAMES:
                    actual = body(asm, name)
                    expected = body(asm, name + 'ref')
                    if actual != expected:
                        raise AssertionError((cpu, opts, name, actual, expected))
                for name, symbol in (('pointer', 'saved'), ('side', 'qualified')):
                    if not any(re.search(r'\b' + symbol + r'\b', args)
                               for _, args in body(asm, name)):
                        raise AssertionError('lost pointer side effect: ' + name)
        # Rejection must be an ordinary source diagnostic, not an ICE
        # triggered later by address folding of an integer error dummy.
        strict_source = ROOT / 'tests/semantic/regression/kcc-void-indirection-v61f.c'
        for mode in ('c89', 'c99'):
            for opts in ([], ['-n']):
                result = compile_source(work, strict_source, 'pdp6', mode, opts)
                decision = check_kcc_rejection(result.returncode, result.stdout)
                if decision is not None:
                    raise AssertionError((mode, opts, decision, result.stdout))
    print('PASS: 32 void-indirection codegen comparisons and 4 strict rejections')


if __name__ == '__main__':
    main()
