#!/usr/bin/env python3
"""Verify optimized volatile field accesses, including discarded reads."""
import os
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'tests/semantic/regression/gcc-volatile-indexed-bitfields-v60a.c'
# These are explicit architectural memory operations. A DPB itself
# performs the required containing-word read/modify/write.
EXPECTED = {
    'volatile_store': ('data', (0, 1)),
    'volatile_signed_store': ('data', (0, 1)),
    'volatile_reads': ('data', (2, 0)),
    'volatile_discard': ('data', (1, 0)),
    'volatile_update': ('data', (1, 1)),
    'volatile_middle16': ('mixed', (1, 1)),
}


def validate(asm):
    for name, (symbol, expected) in EXPECTED.items():
        body = asm.split('\n' + name + ':\n', 1)[1].split('\n\t.globl', 1)[0]
        reads = writes = 0
        for line in body.splitlines():
            assert not re.match(r'^\s*ibp\s', line), (name, line)
            if not re.search(r'\b' + symbol + r'\b', line):
                continue
            op = line.split()[0].lower()
            if op in ('move', 'movn', 'movm', 'ldb', 'hrrz', 'hlrz',
                      'hrre', 'hlre', 'hrr', 'hlr'):
                reads += 1
            elif op in ('dpb', 'movem'):
                writes += 1
            else:
                raise AssertionError((name, 'unclassified memory reference', line))
        assert (reads, writes) == expected, (name, reads, writes, expected)


def main():
    cc = Path(os.environ['PDP10_PREFIX']) / 'bin/pdp10-dec-none-gcc'
    tmp = Path(os.environ.get('TMPDIR') or str(Path.home() / 'tmp'))
    tmp.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='volatile-bitfield-v60a.', dir=tmp) as root:
        for cpu in ('pdp6', 'ka10', 'ki10', 'ks10'):
            asm = Path(root) / (cpu + '.s')
            subprocess.run([str(cc), '-S', '-O2', '-march=' + cpu,
                            '-munextended', str(SOURCE), '-o', str(asm)],
                           check=True, timeout=30)
            validate(asm.read_text())
            print('PASS: %s volatile field access counts (six functions)' % cpu)
        # Repeated read elimination and assignment readback must both
        # be rejected by the audit itself, not just by the compiler.
        good = asm.read_text()
        start = good.index('\nvolatile_reads:\n')
        end = good.index('\n\t.globl', start)
        body = good[start:end]
        lines = body.splitlines(keepends=True)
        index = next(i for i, line in enumerate(lines) if 'data(' in line)
        del lines[index]
        bad = good[:start] + ''.join(lines) + good[end:]
        start = good.index('\nvolatile_store:\n')
        end = good.index('\n\t.globl', start)
        body = good[start:end]
        bad2 = good[:start] + body.replace('\tpopj', '\tmove 1,data(1)\n\tpopj', 1) + good[end:]
        for mutant in (bad, bad2):
            try:
                validate(mutant)
            except AssertionError:
                continue
            raise AssertionError('volatile access-count mutant accepted')
        print('PASS: both access-count mutation controls')


if __name__ == '__main__':
    main()
