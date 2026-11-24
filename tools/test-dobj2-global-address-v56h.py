#!/usr/bin/env python3
"""Check global object words independently of DAS and linker internals."""
import os
from pathlib import Path
import subprocess
import tempfile

MASK = (1 << 36) - 1
RH = (1 << 18) - 1


def sixbit(s):
    w = 0
    for c in s:
        w = (w << 6) | (ord(c) - 32)
    return w


def read_words(path):
    data = path.read_bytes()
    assert len(data) % 8 == 0
    words = [int.from_bytes(data[i:i+8], 'little') for i in range(0, len(data), 8)]
    assert all(w <= MASK for w in words)
    return words


def read_object(path):
    w = read_words(path)
    version = {sixbit('DOBJ1 '): 1, sixbit('DOBJ2 '): 2}[w[0]]
    t, d = w[1] >> 18, w[1] & RH
    b, ns = w[2] >> 18, w[2] & RH
    nr = w[3] >> 18
    sections = {1: w[5:5+t], 2: w[5+t:5+t+d]}
    pos = 5+t+d
    symbols = []
    for _ in range(ns):
        h, v = w[pos:pos+2]
        n = (h >> 18) & 63
        pos += 2
        name = ''.join(chr((x >> shift) & 127) for x in w[pos:pos+(n+3)//4]
                       for shift in (27,18,9,0))[:n]
        pos += (n+3)//4
        symbols.append((name, (h >> 33) & 7, (h >> 30) & 7, v))
    start = pos
    reloc = {}
    for _ in range(nr):
        h, sym, a = w[pos:pos+3]
        pos += 3
        section, typ, target = (h >> 33) & 7, (h >> 30) & 7, (h >> 27) & 7
        loc = (section, h & RH)
        symbol = symbols[sym-1][0] if sym else None
        if a & (1 << 35):
            a -= 1 << 36
        assert loc not in reloc, loc
        reloc[loc] = (typ, target, symbol, a)
    assert pos == len(w)
    return version, sections, symbols, reloc, start


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    root = Path(tempfile.mkdtemp(prefix='pdp10-dobj2-v56h-', dir=tmp))
    binpath = Path(os.environ.get('DOBJ2_TOOLS') or (Path(os.environ['PDP10_PREFIX']) / 'bin'))
    count = 0

    def run(tool, *args, fail=False, diagnostic=None):
        nonlocal count
        count += 1
        p = subprocess.run([str(binpath/tool), *map(str,args)], capture_output=True, text=True, timeout=30)
        (root/f'{count:03d}-{tool}.log').write_text(p.stdout+p.stderr)
        assert (p.returncode != 0) == fail, (tool,args,p.returncode,p.stderr,root)
        if diagnostic:
            assert diagnostic in p.stdout+p.stderr, (diagnostic,root)
        return p.stdout

    def asm(name, source, *flags, fail=False):
        s, o = root/(name+'.s'), root/(name+'.dobj')
        s.write_text(source, encoding='ascii')
        run('das', *flags, '-O', o, s, fail=fail)
        return o

    # Complete defined selector range, including the five pre-byte forms.
    selectors = asm('selectors', '.text\n'+''.join(f'OWGBP {i:o},2001000\n' for i in range(0o45,0o77)), '-C')
    v, sections, _, rel, _ = read_object(selectors)
    assert v == 2 and not rel
    assert sections[1] == [(i<<30)|0o2001000 for i in range(0o45,0o77)]
    # Independently check address addends, word selectors, and literal location.
    obj = asm('mixed', '.text\n.globl start\n.extern other\nstart:\n move 1,[OWGBP 70,GIW local+1000000]\n jrst @[GIW other-2]\n.data\nlocal:\n GIW local-3\n OWGBP 76,other+1000000\n .long %EXIND(1,2,other-4)\n', '-C')
    v, sec, _, rel, start = read_object(obj)
    assert v == 2
    assert sec[2] == [0,0o76<<30,0o22<<30]
    assert sec[1][2:] == [0o70<<30,0]
    assert rel == {(1,0):(1,1,None,2),(1,1):(1,1,None,3),
                   (2,0):(5,2,None,-3),(2,1):(6,0,'other',0o1000000),
                   (2,2):(6,0,'other',-4),(1,2):(5,2,None,0o1000000),
                   (1,3):(6,0,'other',-2)}
    run('pdp10-objdump','-h','-r',obj,diagnostic='DOBJ2')
    # The existing DXR linker and local-only optimizers must fail closed.
    run('dlink','-o',root/'rejected.dxr',obj,fail=True,diagnostic='DOBJ2')
    run('p10fold',obj,fail=True,diagnostic='DOBJ2')
    run('p10super',obj,fail=True,diagnostic='DOBJ2')
    archive = root/'mixed.darc'
    run('darc','-o',archive,obj)
    assert obj.read_bytes() in archive.read_bytes()
    demand = asm('demand','.text\n.globl caller\n.extern start\ncaller: jrst start\n','-C')
    run('dlink','-o',root/'archive-rejected.dxr',demand,archive,fail=True,diagnostic='DOBJ2')
    # Malformed source, incompatible output format and base mode.
    bad = ('OWGBP 44,1000','OWGBP 77,1000','OWGBP 70,10000000000',
           'GIW -1','GIW 10000000000','OWGBP 70,',
           'GIW local+10000000000','GIW local-10000000000',
           'OWGBP local,1000','.long %EXIND(2,0,local)',
           '.long %EXIND(0,16,local)','.long %EXIND(local,0,1000)')
    for i,s in enumerate(bad):
        asm(f'bad-{i}', '.text\nlocal:\n '+s+'\n','-C',fail=True)
    asm('no-dxr-reloc','.text\nlocal: GIW local\n',fail=True)
    asm('no-base-global','.text\n OWGBP 70,1000\n','-B','-C',fail=True)
    # Reader validation is independent of the assembler. Mutate one field
    # at a time: version, type, overlap, displacement, control/address bits.
    words = read_words(obj)
    global_index = next(i for i in range(start,len(words),3) if ((words[i]>>30)&7)==5)
    mutations = [(0,sixbit('DOBJ1 ')),
                 (global_index,words[global_index] | (7<<30)),
                 (global_index+2,1<<30),
                 (5+len(sec[1]),1),
                 (global_index,words[global_index] | RH)]
    for i,(at,value) in enumerate(mutations):
        broken = words.copy(); broken[at] = value
        path = root/f'bad-object-{i}.dobj'
        path.write_bytes(b''.join(w.to_bytes(8,'little') for w in broken))
        run('pdp10-objdump','-r',path,fail=True)
    overlap = words.copy(); overlap[3] += 1<<18
    overlap += words[global_index:global_index+3]
    path = root/'overlap.dobj'
    path.write_bytes(b''.join(w.to_bytes(8,'little') for w in overlap))
    run('pdp10-objdump','-r',path,fail=True)
    # Local objects must remain DOBJ1. Optional baseline binary enables
    # exact byte comparison for unchanged source fixtures.
    base = os.environ.get('DOBJ1_BASELINE_DAS')
    repo = Path(__file__).resolve().parents[1]
    for name in ('dxr-strict-base','dxr-strict-base-byte','dxr-pseudo-more'):
        src = repo/'misc'/'das'/(name+'.s')
        path = root/(name+'.dobj')
        run('das','-C','-O',path,src)
        assert read_words(path)[0] == sixbit('DOBJ1 ')
        if base:
            old = root/(name+'-baseline.dobj')
            subprocess.run([base,'-C','-O',str(old),str(src)],check=True)
            assert old.read_bytes() == path.read_bytes()
    print(f'PASS DOBJ2: 26 selectors, 7 mixed relocations, archive and malformed guards; {count} tool calls; {root}',flush=True)


if __name__ == '__main__':
    main()
