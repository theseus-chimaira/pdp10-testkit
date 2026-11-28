#!/usr/bin/env python3
"""Check deferred label differences and reject nonconstant initializers."""
import os
from pathlib import Path
import subprocess
import tempfile
from compiler_negative_policy_v1 import check_kcc_rejection

BIN = Path(os.environ['PDP10_PREFIX']) / 'bin'
ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'tests/codegen/upstream-gcc/compile/labels-3.c'
BAD = (
    'int f(void *p) { static int d = &&a-p; a: return d; }',
    'int f(void) { static long long d = &&a-&&b; a:return 0; b:return 1; }',
    'int f(void) { static int d = (short)(&&a-&&b); a:return d; b:return 1; }',
    'int f(void) { static int d = &&a-&&missing; a:return d; }',
    'static int d = &&a-&&a;',
)


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    count = 0
    with tempfile.TemporaryDirectory(prefix='kcc-label-diff-v61o.', dir=tmp) as path:
        work = Path(path)
        source = work / 'probe.c'
        for cpu in ('pdp6', 'ka10', 'ki10', 'ks10'):
            for opts in ([], ['-n']):
                cmd = [str(BIN/'kcc'), '-S','-v=nostats','-x='+cpu,'-R=unit',*opts]
                for mode in ('gnu89','gnu99'):
                    subprocess.run(cmd+['-P'+mode,str(SOURCE)],cwd=work,check=True,timeout=20)
                    asm = (work/'unit.s').read_text()
                    assert '.LINK' not in asm and '4*(' in asm, (cpu,opts,asm)
                    subprocess.run([str(BIN/'das'),'-F','-C','-O','unit.dobj','unit.s'],
                                   cwd=work,check=True,timeout=20)
                    count += 1
                for mode, body in [('c89',SOURCE.read_text()),('c99',SOURCE.read_text())]+[
                    ('gnu99',s) for s in BAD]:
                    source.write_text(body+'\n',encoding='ascii')
                    r = subprocess.run(cmd+['-P'+mode,str(source)],cwd=work,
                                       capture_output=True,text=True,timeout=20)
                    assert check_kcc_rejection(r.returncode,r.stdout+r.stderr) is None,(cpu,opts,body,r.stdout,r.stderr)
                    count += 1
    print('PASS: %d label difference mode, assembly and rejection checks' % count)

if __name__ == '__main__':
    main()
