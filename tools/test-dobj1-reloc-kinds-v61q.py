#!/usr/bin/env python3
"""Reject unknown DOBJ1 relocation kinds at every host consumer boundary."""
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
BIN = Path(os.environ['PDP10_PREFIX']) / 'bin'
TOOLS = Path(os.environ.get('DOBJ1_TOOLS') or BIN)
RH = (1 << 18) - 1


def sixbit(s):
    n = 0
    for c in s:
        n = (n << 6) | (ord(c) - 32)
    return n


def words(path):
    raw = path.read_bytes()
    assert len(raw) % 8 == 0
    return [int.from_bytes(raw[i:i+8], 'little') for i in range(0, len(raw), 8)]


def write(path, values):
    path.write_bytes(b''.join(w.to_bytes(8, 'little') for w in values))


def relocations(w):
    assert w[0] == sixbit('DOBJ1 ')
    pos = 5 + (w[1] >> 18) + (w[1] & RH)
    for _ in range(w[2] & RH):
        n = (w[pos] >> 18) & 63
        pos += 2 + (n+3)//4
    assert pos + 3*(w[3] >> 18) == len(w)
    return list(range(pos, len(w), 3))


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    baseline = os.environ.get('DOBJ1_BASELINE')
    accepted = []
    with tempfile.TemporaryDirectory(prefix='dobj1-reloc-v61q.', dir=tmp) as path:
        work = Path(path)
        asm = work/'fixture.s'
        obj = work/'fixture.dobj'
        helper = work/'helper.dobj'
        asm.write_text('.text\n.globl start\n.entry start\nstart: movei 1,local\n halt\nlocal: .word 0\n.data\n.globl fixture\n.extern helper\nfixture: .word local\n.word helper\n.word local,,0\n.word helper,,0\n', encoding='ascii')
        subprocess.run([str(BIN/'das'),'-F','-C','-O',str(obj),str(asm)], check=True, timeout=30)
        asm.write_text('.text\n.globl helper\nhelper: popj 17,\n', encoding='ascii')
        subprocess.run([str(BIN/'das'),'-F','-C','-O',str(helper),str(asm)], check=True, timeout=30)
        data = words(obj)
        rs = relocations(data)
        assert {(data[i] >> 30) & 7 for i in rs} == {1,2,3,4}
        sites = [next(i for i in rs if (data[i] >> 33) & 7 == sec) for sec in (1,2)]
        count = 0
        def run(tool, args, expected, prefix=TOOLS):
            nonlocal count
            p = subprocess.run([str(prefix/tool), *map(str,args)], cwd=work,
                               capture_output=True,text=True,timeout=30)
            if expected is not None:
                assert (p.returncode == 0) == expected, (tool,args,p.returncode,p.stdout,p.stderr)
                count += 1
            return p
        def commands(source, tag):
            return [('darc',['-o',work/(tag+'.darc'),source]),
                    ('dlink',['-b','020','-o',work/(tag+'.dxr'),source,helper]),
                    ('pdp10-objdump',['-h','-r',source]),
                    ('p10fold',[source]), ('p10super',[source])]
        for tool,args in commands(obj,'good'):
            run(tool,args,True)
        if baseline:
            for tool,args in commands(obj,'old-good'):
                run(tool,args,True,Path(baseline))
            for suffix in ('.darc','.dxr'):
                assert (work/('good'+suffix)).read_bytes() == (work/('old-good'+suffix)).read_bytes()
        for sec,site in zip((1,2),sites):
            for kind in (0,5,6,7):
                bad = list(data)
                bad[site] = (bad[site] & ~(7 << 30)) | (kind << 30)
                name = f'bad-{sec}-{kind}'
                source = work/(name+'.dobj')
                write(source,bad)
                for tool,args in commands(source,name):
                    run(tool,args,False)
                    if baseline:
                        old = run(tool,args,None,Path(baseline))
                        if old.returncode == 0:
                            accepted.append((sec,kind,tool))
                # A selected archive member must be validated, not just direct input.
                archive = words(work/'good.darc')
                start = archive.index(sixbit('DOBJ1 '))
                archive[start+site] = bad[site]
                arc = work/(name+'-member.darc')
                write(arc,archive)
                # A separate root object references the fixture symbol, selecting the member.
                root = work/'root.dobj'
                asm.write_text('.text\n.entry root\n.globl root\n.extern fixture\nroot: move 1,fixture\n halt\n',encoding='ascii')
                subprocess.run([str(BIN/'das'),'-F','-C','-O',str(root),str(asm)],check=True,timeout=30)
                run('dlink',['-b','020','-o',work/(name+'-member.dxr'),root,arc,helper],False)
        if baseline:
            print('Baseline incorrectly accepted:',len(accepted),accepted)
            assert accepted, 'baseline must demonstrate defect'
        # Test the shared writer directly, including out-of-range in-memory
        # values that cannot be represented in a three-bit record.
        source_root = Path(os.environ.get('DAIMOS_TOOLS_ROOT') or ROOT.parent/'daimos-tools').resolve()
        writer = work/'writer-kind'
        subprocess.run([os.environ.get('CC','cc'), '-std=c99','-Wall','-Wextra','-Werror',
                        '-I'+str(source_root), '-o',str(writer),
                        str(ROOT/'misc/tools/dobj1-writer-kind-v61q.c'),
                        str(source_root/'dobj.c')], check=True, timeout=30)
        subprocess.run([str(writer),str(work/'writer.dobj')],check=True,timeout=30)
        print('PASS: %d host DOBJ1 consumer checks' % count)


if __name__ == '__main__':
    main()
