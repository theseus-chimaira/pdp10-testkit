#!/usr/bin/env python3
"""Validate global static pointers and code literals in assembled GCC objects."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'tests/codegen/kl10/gcc-global-static-pointer-v56h.c'
spec = importlib.util.spec_from_file_location('dobj2_oracle', ROOT / 'tools/test-dobj2-global-address-v56h.py')
oracle = importlib.util.module_from_spec(spec)
spec.loader.exec_module(oracle)

# Symbol, selector, word displacement. These are architectural slots,
# independent of the compiler's P/S tables and emitted assembly syntax.
EXPECTED = [('bytes',0o70,0),('bytes',0o71,1),('halves',0o76,1),
            ('words',0,5),('fun',0,0),('bytes',0o70,1),
            ('bytes',0o73,0),('bytes',0o70,2),('words',0o70,2),
            ('words',0o75,1),('bytes',0,1),('scalar_byte',0o73,0),
            ('scalar_half',0o76,0)]


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='pdp10-gcc-global-init-v56i-', dir=tmp))
    bindir = Path(os.environ['PDP10_PREFIX']) / 'bin'
    gcc = Path(os.environ.get('PDP10_GCC_OVERRIDE') or bindir/'pdp10-dec-none-gcc')
    das = Path(os.environ.get('DOBJ2_TOOLS') or bindir)/'das'
    for opt in ('O0','O1','O2','Os'):
        assembly = work/f'static-{opt}.s'
        obj = work/f'static-{opt}.dobj'
        log = work/f'{opt}.log'
        with log.open('w') as out:
            subprocess.run([str(gcc),'-march=kl10','-mextended','-'+opt,'-S',str(SOURCE),'-o',str(assembly)],stdout=out,stderr=subprocess.STDOUT,timeout=30,check=True)
            subprocess.run([str(das),'-C','-O',str(obj),str(assembly)],stdout=out,stderr=subprocess.STDOUT,timeout=30,check=True)
        v, sections, syms, rel, _ = oracle.read_object(obj)
        assert v == 2, (opt,work)
        symbols = {name:(kind,sec,value) for name,kind,sec,value in syms}
        for i,(target,selector,addend) in enumerate(EXPECTED):
            kind,sec,offset = symbols['p'+str(i)]
            assert (kind,sec)==(1,2) and sections[sec][offset]==selector<<30, (opt,i,work)
            assert rel[sec,offset]==(6,0,target,addend), (opt,i,rel[sec,offset],work)
        # Null pointer stays in zero-filled BSS, without any relocation.
        kind,sec,offset = symbols['p13']
        assert (kind,sec)==(1,3) and (sec,offset) not in rel, (opt,work)
        assert (oracle.read_words(obj)[2] >> 18) > offset, (opt,work)
        # Optimized return is a folded global literal. Unoptimized return
        # is ADJBP by 5 from the first-byte pointer.
        code_globals = [(offset,r) for (sec,offset),r in rel.items() if sec==1 and r[0]==6]
        assert len(code_globals)==1, (opt,code_globals,work)
        loc,r = code_globals[0]
        if opt=='O0':
            assert r==(6,0,'bytes',0) and sections[1][loc]==0o70<<30, (opt,work)
            assert any(w>>27==0o133 for w in sections[1]), (opt,work)
        else:
            assert r==(6,0,'bytes',1) and sections[1][loc]==0o71<<30, (opt,work)
        print(f'PASS {opt}: 13 static relocations, null BSS, code literal; {obj}',flush=True)
    print('PASS 4 compiler profiles (object generation, not runtime)',flush=True)


if __name__=='__main__':
    main()
