#!/usr/bin/env python3
"""Exact integer oracle for wide floating conversions and preserved ACs."""
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


def pair(value):
    hi, lo = divmod(value % LIMIT, B)
    return hi, lo | (hi & B)


def floating(value, precision):
    """Return canonical target words and rounded integer (ties even)."""
    if value == 0:
        return (0,) if precision == 27 else (0, 0), 0
    magnitude = abs(value)
    exponent = magnitude.bit_length()
    shift = exponent - precision
    if shift > 0:
        fraction, rem = divmod(magnitude, 1 << shift)
        half = 1 << (shift - 1)
        fraction += rem > half or (rem == half and fraction & 1)
        if fraction == 1 << precision:
            fraction >>= 1
            exponent += 1
            shift += 1
    else:
        fraction = magnitude << -shift
    rounded = fraction << shift if shift >= 0 else fraction >> -shift
    if precision == 27:
        bits = ((128 + exponent) << 27) | fraction
        words = ((-bits if value < 0 else bits) & MASK,)
    else:
        bits = ((128 + exponent) << 62) | fraction
        words = pair(-bits if value < 0 else bits)
    return words, -rounded if value < 0 else rounded


def word(n):
    return '0%o' % (n & MASK)


def main():
    prefix = Path(os.environ['PDP10_PREFIX'])
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    rng = random.Random(59019)
    values = [0, 1, -1, 17, -17, B-1, B, B+1, -B-1,
              -(LIMIT//2), LIMIT//2-1, (1 << 69)+(1 << 42),
              (1 << 69)+(1 << 42)+1]
    values += [rng.randrange(-LIMIT//2, LIMIT//2) for _ in range(32)]
    lines = ['.text', '.globl main', 'main:', '\tmovem 17,saved_sp']
    saved = range(8, 15)  # AC10..AC16 (octal)
    for ac in saved:
        lines.append('\tmovei %o,%s' % (ac, word(100+ac)))
    count = 0

    def call(symbol, source, expected):
        nonlocal count
        count += 1
        lines.extend(['\tmovei 1,%s' % word(count), '\tmovem 1,fail_id'])
        for ac, val in enumerate(source, 1):
            lines.append('\tmove %o,[%s]' % (ac, word(val)))
        lines.append('\tpushj 17,' + symbol)
        for ac, val in enumerate(expected, 1):
            lines.extend(['\tcame %o,[%s]' % (ac, word(val)), '\t jrst failed'])
        for ac in saved:
            lines.extend(['\tcame %o,[%s]' % (ac, word(100+ac)), '\t jrst failed'])
        lines.extend(['\tcame 17,saved_sp', '\t jrst failed'])

    for n in values:
        bits, rounded = floating(n, 62)
        call('__kcc_floatdidf', pair(n), bits)
        if -LIMIT//2 <= rounded < LIMIT//2:
            call('__kcc_fixdfdi', bits, pair(rounded))
    unsigned = [0, 1, B-1, B, B+1, LIMIT//2-1, LIMIT//2,
                LIMIT//2+1, LIMIT-1, LIMIT//2+(1 << 43),
                LIMIT//2+(1 << 43)+1]
    unsigned += [rng.randrange(LIMIT) for _ in range(32)]
    for signed, entries in ((True, values), (False, unsigned)):
        for n in entries:
            for precision, fmt in ((27, 'sf'), (62, 'df')):
                bits, rounded = floating(n, precision)
                call('__float%sdi%s' % ('' if signed else 'un', fmt), pair(n), bits)
                low, high = (-LIMIT//2, LIMIT//2) if signed else (0, LIMIT)
                if low <= rounded < high:
                    call('__fix%s%sdi' % ('' if signed else 'uns', fmt), bits, pair(rounded))
    lines += ['\tsetzm fail_id', '\tsetz 1,', '\tpopj 17,', 'failed:',
              '\tmovei 1,1', '\tpopj 17,', '.bss', '.globl fail_id',
              'fail_id: .block 1', 'saved_sp: .block 1']
    with tempfile.TemporaryDirectory(prefix='wide-float-abi-v59s.', dir=tmp) as path:
        work = Path(path)
        active = prepare_script_prefix(work, prefix, 'kcc')
        env = dict(os.environ, PDP10_PREFIX=str(active))
        source = work / 'oracle.s'
        source.write_text('\n'.join(lines)+'\n', encoding='ascii')
        for cpu in ('pdp6', 'ka10', 'ki10', 'ks10'):
            subprocess.run([str(prefix/'bin/p10run'), '--machine', cpu,
                            '--mode', 'deposit', '--exec-mode', 'step',
                            '--step-limit', '3000000', '--timeout', '18',
                            '--workdir', str(work/cpu), '--name', 'wide-float-abi-v59s',
                            '--expect', '__test_exit=0', '--expect', 'fail_id=0',
                            str(ROOT/'support/crt0-upstream-v1.s'), str(source)],
                           env=env, check=True)
            print('%s: PASS (%d calls, preserved AC10..AC16 and SP)' % (cpu, count), flush=True)


if __name__ == '__main__':
    main()
