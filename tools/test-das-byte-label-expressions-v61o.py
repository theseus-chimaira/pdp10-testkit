#!/usr/bin/env python3
"""DAS BYTE expressions: exact words, forward labels and relocation identity."""
import os
from pathlib import Path
import subprocess
import tempfile

from importlib.util import spec_from_file_location, module_from_spec

spec = spec_from_file_location('dobj_oracle', Path(__file__).with_name('test-dobj2-global-address-v56h.py'))
module = module_from_spec(spec)
spec.loader.exec_module(module)
read_object = module.read_object

BIN = Path(os.environ['PDP10_PREFIX']) / 'bin'
DAS = BIN / 'das'
MASK = (1 << 36) - 1

SOURCE = """.text
start: .word 0
.space 4
.data
.byte 18,4*(end-start),4*(start-end)
BYTE (6)1(12)2,(18)3
.byte 9,4*(end-start) >> 2,1 + (2 * 3),4
.byte 9,1+(2*(3+4)),~(1+2),7,8
.text
end: .word 0
"""
EXPECTED = [(8 << 18) | ((1 << 18) - 8), (1 << 30) | (2 << 18) | 3,
            (2 << 27) | (7 << 18) | (4 << 9),
            (15 << 27) | (508 << 18) | (7 << 9) | 8]
BAD = (
    ('.text\nstart: .word 0\n.data\nend: .word 0\n.byte 18,4*(end-start)\n',
     'unsupported difference of separately relocated symbols'),
    ('.text\n.globl ext1,ext2\n.byte 18,4*(ext1-ext2)\n',
     'unsupported difference of separately relocated symbols'),
    ('.text\nstart: .word 0\n.byte 18,start\n',
     'relocation inside .byte'),
    ('.text\n.byte 18,4*(1+2\n', 'malformed expression'),
)


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, PATH=str(BIN)+os.pathsep+os.environ.get('PATH',''))
    with tempfile.TemporaryDirectory(prefix='das-byte-label-v61o.', dir=tmp) as path:
        work = Path(path)
        source = work / 'probe.s'
        source.write_text(SOURCE, encoding='ascii')
        obj, dxr = work/'probe.dobj', work/'probe.dxr'
        for flags, out in ((['-F','-C'],obj), (['-A'],dxr)):
            subprocess.run([str(DAS), *flags, '-O', str(out), str(source)],
                           env=env, check=True, timeout=30)
        version, sections, symbols, reloc, end = read_object(obj)
        assert version == 1 and sections[1] == [0,0,0]
        assert sections[2] == EXPECTED and not reloc, (sections,reloc)
        data = dxr.read_bytes()
        words = [int.from_bytes(data[i:i+8],'little') & MASK for i in range(0,len(data),8)]
        assert words[2:9] == [0,0,0]+EXPECTED, words
        for text, diagnostic in BAD:
            source.write_text(text, encoding='ascii')
            result = subprocess.run([str(DAS), '-F','-C','-O',str(obj),str(source)],
                                    env=env, capture_output=True,text=True,timeout=30)
            assert result.returncode and diagnostic in result.stderr, (text,result.stderr)
    print('PASS: DOBJ1 and paired DXR words, no relocations; four negative expressions')

if __name__ == '__main__':
    main()
