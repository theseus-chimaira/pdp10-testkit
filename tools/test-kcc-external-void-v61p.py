#!/usr/bin/env python3
"""GNU incomplete external linker symbols: native addresses, no object reads."""
import os
from pathlib import Path
import subprocess
import tempfile
from compiler_negative_policy_v1 import check_kcc_rejection
from importlib.util import spec_from_file_location, module_from_spec

spec = spec_from_file_location('void_codegen_oracle', Path(__file__).with_name('test-kcc-void-indirection-v61f.py'))
module = module_from_spec(spec)
spec.loader.exec_module(module)
body = module.body

BIN = Path(os.environ['PDP10_PREFIX']) / 'bin'
ROOT = Path(__file__).resolve().parents[1]
SOURCE = '''extern void anchor;
extern volatile void end;
static void * volatile saved = &anchor;
static void * volatile next = &anchor + 4;
volatile int __test_exit;
void discard(void) { anchor; end; }
void reference(void) { }
void *first(void) { extern void anchor; return &anchor; }
int main(void) {
    if (sizeof(anchor) != 1 || __alignof__(anchor) != 1) return 1;
    if (first() != saved || &end != next) return 2;
    if (&end - saved != 4 || saved + 4 != next) return 3;
    if (*(unsigned int *)saved != 0123456701234UL) return 4;
    if (*(unsigned int *)next != 0765432107654UL) return 5;
    discard();
    return 0;
}
'''
DEFINITION = '''.data
.globl anchor,end
anchor: .word 0123456701234
end: .word 0765432107654
'''
BAD = (
    'void obj;',
    'static void obj;',
    'extern void obj = 0;',
    'extern void obj[2];',
    'int f(void) { void obj; return 0; }',
    'extern void obj; int f(void) { return obj; }',
    'extern void obj; void f(void) { obj = 1; }',
    'extern void obj; int obj;',
    'extern void obj; unsigned long x = (unsigned long)&obj - 0x10000000L - 1;',
)


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    env = dict(os.environ, PATH=str(BIN)+os.pathsep+os.environ.get('PATH',''))
    nrun = nbad = 0
    with tempfile.TemporaryDirectory(prefix='kcc-external-void-v61p.', dir=tmp) as path:
        work = Path(path)
        source = work / 'probe.c'
        definition = work / 'definition.s'
        definition.write_text(DEFINITION, encoding='ascii')
        for cpu in ('pdp6','ka10','ki10','ks10'):
            for opts in ([], ['-n']):
                cmd = [str(BIN/'kcc'), '-S','-v=nostats','-x='+cpu,'-R=unit',*opts]
                for mode in ('gnu89','gnu99'):
                    source.write_text(SOURCE, encoding='ascii')
                    result = subprocess.run(cmd+['-P'+mode,str(source)],cwd=work,
                                            capture_output=True,text=True,timeout=20)
                    assert not result.returncode, result.stdout+result.stderr
                    asm = (work/'unit.s').read_text(encoding='ascii')
                    assert '.LINK' not in asm and 'POINT 9,anchor,8' in asm
                    assert 'POINT 9,anchor+1,8' in asm
                    # A void expression cannot access memory or an address.
                    assert body(asm,'discard') == body(asm,'reference')
                    tag = cpu+'-'+mode+('-noopt' if opts else '-opt')
                    subprocess.run([str(BIN/'p10run'),'--machine',cpu,'--mode','deposit',
                        '--exec-mode','step','--step-limit','18000000','--timeout','30',
                        '--workdir',str(work/tag),'--name',tag,'--expect','__test_exit=0',
                        str(ROOT/'misc/kcc-regression/semantic-crt0.s'),
                        str(work/'unit.s'),str(definition)],env=env,cwd=work,check=True,
                        timeout=45,stdout=subprocess.DEVNULL)
                    nrun += 1
                for mode,text in [('c89','extern void obj;'),('c99','extern void obj;')]+[('gnu99',s) for s in BAD]:
                    source.write_text(text+'\n',encoding='ascii')
                    r = subprocess.run(cmd+['-P'+mode,str(source)],cwd=work,
                                       capture_output=True,text=True,timeout=20)
                    assert check_kcc_rejection(r.returncode,r.stdout+r.stderr) is None,(cpu,opts,text,r.stdout,r.stderr)
                    nbad += 1
    print('PASS: %d linked external-void executions and %d rejection checks' % (nrun,nbad))

if __name__ == '__main__':
    main()
