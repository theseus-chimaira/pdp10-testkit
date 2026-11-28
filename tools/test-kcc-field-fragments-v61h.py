#!/usr/bin/env python3
"""Ensure known crossing fields use native fragments, not bit loops."""

import collections
import os
from pathlib import Path
import subprocess
import tempfile

from codegen_declared_oracles_v1 import instructions


SOURCE = '''struct fields {
    unsigned int pad:12;
    unsigned int field:32;
    unsigned int tail:28;
};
unsigned int read(struct fields *p) { return p->field; }
void write(struct fields *p, unsigned int v) { p->field = v; }
'''


def main():
    kcc = Path(os.environ['PDP10_PREFIX']) / 'bin/kcc'
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='kcc-field-fragments-v61h.',
                                     dir=tmp) as path:
        work = Path(path)
        source = work / 'probe.c'
        source.write_text(SOURCE, encoding='ascii')
        for cpu in ('pdp6', 'ka10', 'ki10', 'ks10'):
            for opts in ([], ['-n']):
                result = subprocess.run(
                    [str(kcc), '-Pgnu99', '-S', '-v=nostats', '-x=' + cpu,
                     '-R=unit', *opts, str(source)], cwd=work,
                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                    text=True, timeout=20)
                if result.returncode:
                    raise AssertionError(result.stdout)
                asm = (work / 'unit.s').read_text(encoding='ascii')
                counts = collections.Counter(op.upper() for op, _ in instructions(asm))
                if counts['LDB'] != 2 or counts['DPB'] != 2:
                    raise AssertionError((cpu, opts, counts))
                if any(counts[op] for op in ('IBP', 'ILDB', 'IDPB', 'ADJBP')):
                    raise AssertionError((cpu, opts, 'unexpected byte stepping', counts))
                if '%ADJBPH' in asm.upper():
                    raise AssertionError((cpu, opts, 'unnecessary ADJBP helper'))
    print('PASS: native bitfield fragment generation (8 configurations)')


if __name__ == '__main__':
    main()
