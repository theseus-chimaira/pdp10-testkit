#!/usr/bin/env python3
"""Exercise the installed libgcc divider independently of C lowering."""
import os
from pathlib import Path
import random
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from compiler_stdlib_prefix_v1 import prepare_script_prefix
B = 1 << 35
LIMIT = 1 << 71
MASK = (1 << 36) - 1


def pair(value, signed):
    value %= LIMIT
    hi, lo = divmod(value, B)
    if signed and hi & B:
        lo |= B
    return hi, lo


def word(value):
    return '0%o' % (value & MASK)


def main():
    prefix = Path(os.environ['PDP10_PREFIX'])
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    rng = random.Random(59013)
    cases = [(0, 0), (0, 1), (17, 3), (B-1, 2), (B, 1),
             (B, 3), (2*B-1, B-1), (LIMIT-1, 1), (LIMIT-1, 2),
             (LIMIT-1, B-1), (LIMIT-1, B), (LIMIT-1, LIMIT-1),
             (LIMIT//2, LIMIT//2+1), (LIMIT//2+17, LIMIT//2-3)]
    cases += [(rng.randrange(LIMIT), rng.randrange(1, B)) for _ in range(32)]
    cases += [(rng.randrange(LIMIT), rng.randrange(B, LIMIT)) for _ in range(32)]
    signed_cases = [(0, -1), (-17, 3), (17, -3), (-17, -3),
                    (-LIMIT//2, 1), (-LIMIT//2, 3),
                    (LIMIT//2-1, -3), (-LIMIT//2, -LIMIT//2)]
    signed_cases += [(rng.randrange(-LIMIT//2, LIMIT//2),
                      rng.choice((-1, 1))*rng.randrange(1, B)) for _ in range(32)]
    signed_cases += [(rng.randrange(-LIMIT//2, LIMIT//2),
                      rng.choice((-1, 1))*rng.randrange(B, LIMIT//2)) for _ in range(32)]
    lines = ['.text', '.globl main', 'main:', '\tmovem 17,saved_sp']
    saved = range(5, 15)  # AC5 through AC16, inclusive (octal).
    for ac in saved:
        lines.append('\tmovei %o,%s' % (ac, word(100+ac)))
    count = 0
    for signed, entries in ((False, cases), (True, signed_cases)):
        for n, d in entries:
            q = abs(n)//abs(d) if d else 0
            if (n < 0) != (d < 0):
                q = -q
            r = n-q*d if d else 0
            for operation, expected in (('div', q), ('mod', r)):
                count += 1
                lines += ['\tmovei 1,%s' % word(count), '\tmovem 1,fail_id']
                for ac, value in enumerate(pair(n, signed)+pair(d, signed), 1):
                    lines.append('\tmove %o,[%s]' % (ac, word(value)))
                lines.append('\tpushj 17,__%s%sdi3' % ('' if signed else 'u', operation))
                for ac, value in enumerate(pair(expected, signed), 1):
                    lines += ['\tcame %o,[%s]' % (ac, word(value)), '\t jrst failed']
                for ac in saved:
                    lines += ['\tcame %o,[%s]' % (ac, word(100+ac)), '\t jrst failed']
                lines += ['\tcame 17,saved_sp', '\t jrst failed']
    lines += ['\tsetzm fail_id', '\tsetz 1,', '\tpopj 17,', 'failed:',
              '\tmovei 1,1', '\tpopj 17,', '.bss', '.globl fail_id',
              'fail_id: .block 1', 'saved_sp: .block 1']
    with tempfile.TemporaryDirectory(prefix='gcc-wide-divider-v59m.', dir=tmp) as path:
        work = Path(path)
        active = prepare_script_prefix(work, prefix, 'gcc')
        env = dict(os.environ, PDP10_PREFIX=str(active))
        source = work / 'oracle.s'
        source.write_text('\n'.join(lines)+'\n', encoding='ascii')
        for cpu in ('pdp6', 'ka10', 'ki10', 'ks10'):
            subprocess.run([str(prefix/'bin/p10run'), '--machine', cpu,
                            '--mode', 'deposit', '--exec-mode', 'step',
                            '--step-limit', '3000000', '--timeout', '18',
                            '--workdir', str(work/cpu), '--name', 'wide-divider-v59m',
                            '--expect', '__test_exit=0', '--expect', 'fail_id=0',
                            str(ROOT/'support/crt0-upstream-v1.s'), str(source)],
                           env=env, check=True)
            print('%s: PASS (%d direct helper calls)' % (cpu, count), flush=True)


if __name__ == '__main__':
    main()
