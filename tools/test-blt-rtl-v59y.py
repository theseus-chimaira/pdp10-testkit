#!/usr/bin/env python3
"""Check real installed GCC BLT/XBLT instructions and their RTL effects."""
import os
from pathlib import Path
import re
import subprocess
import tempfile

SOURCE = """struct record { unsigned long words[8]; };
void copy(struct record *dst, const struct record *src)
{
    *dst = *src;
}
"""


def main():
    cc = Path(os.environ['PDP10_PREFIX']) / 'bin/pdp10-dec-none-gcc'
    tmp = Path(os.environ.get('TMPDIR') or str(Path.home() / 'tmp'))
    tmp.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='blt-rtl-v59y.', dir=tmp) as root:
        for cpu, address, opcode, insn in (
            ('pdp6', '-munextended', 1, r'^\s*blt\s'),
            ('kl10', '-mextended', 2, r'^\s*extend\s+.*\[xblt\]'),
        ):
            for opt in ('O0', 'O2'):
                work = Path(root) / (cpu + '-' + opt)
                work.mkdir()
                (work / 'copy.c').write_text(SOURCE, encoding='ascii')
                subprocess.run([str(cc), '-S', '-da', '-march=' + cpu,
                                address, '-' + opt, 'copy.c', '-o', 'copy.s'],
                               cwd=work, check=True, timeout=30)
                assert re.search(insn, (work / 'copy.s').read_text(), re.M), cpu
                rtl = next(work.glob('*.00.rtl')).read_text()
                # Only inspect individual RTL instructions, not a match
                # that can accidentally consume a later memory clobber.
                blocks = re.split(r'(?m)^\(insn ', rtl)[1:]
                transfers = [b for b in blocks if re.search(
                    r'unspec_volatile:BLK\[.*?\]\s+' + str(opcode) + r'\)',
                    b, re.S)]
                assert transfers, (cpu, opt, 'missing block transfer')
                for block in transfers:
                    assert '(clobber (mem:BLK (scratch)' in block, (cpu, opt)
                print('PASS: %s %s block transfer memory effects' % (cpu, opt))


if __name__ == '__main__':
    main()
