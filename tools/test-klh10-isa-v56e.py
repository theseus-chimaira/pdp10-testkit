#!/usr/bin/env python3
"""Replay independent PDP-10 ISA images on the optional KLH10 emulator.

Reuse the SIMH fixtures' architectural words and expected values, but
use KLH10's own physical deposit/examine and GO commands. Never treat
an emulator exit status or an initial zero in memory as guest success.
"""
import importlib.util
import os
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def fixture(name):
    spec = importlib.util.spec_from_file_location(name, ROOT / 'tools' / name)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def translate(source):
    lines = []
    for line in source.read_text(encoding='ascii').splitlines():
        if line.startswith('deposit ') and not line.startswith('deposit pc '):
            _, addr, word = line.split()
            lines.append(f'deposit P{addr} {word}')
    return lines


def run(emulator, root, name, deposits, expected, halt_pc):
    ini = root / (name + '.ini')
    lines = deposits + ['go 100']
    # Physical addresses < 20 designate the current accumulator block.
    lines += [f'examine P{addr:o}' for addr in expected]
    lines += ['quit', '']
    ini.write_text('\n'.join(lines), encoding='ascii')
    proc = subprocess.run([str(emulator), str(ini)], cwd=root,
                          stdin=subprocess.DEVNULL, stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT, timeout=30, check=True)
    log = proc.stdout.decode('ascii', errors='replace')
    path = root / (name + '.log')
    path.write_text(log, encoding='utf-8')
    halt = re.findall(r'\[HALTED: Program Halt, PC = ([0-7]+)\]', log)
    if len(halt) != 1 or int(halt[0], 8) != halt_pc:
        raise AssertionError(f'{name}: wrong termination; see {path}')
    values = {}
    for match in re.finditer(r'^[ \t]*(?:P[ \t]+)?([0-7]+)/[ \t]+([0-7]+)(?:,,([0-7]+))?', log, re.M):
        addr = int(match[1], 8)
        value = int(match[2], 8)
        if match[3] is not None:
            value = (value << 18) | int(match[3], 8)
        if addr in values:
            raise AssertionError(f'{name}: duplicate observation {addr:o}')
        values[addr] = value
    for addr, want in expected.items():
        if values.get(addr) != want:
            raise AssertionError(f'{name}: {addr:o}: expected {want:o}, '
                                 f'observed {values.get(addr)}; see {path}')
    print(f'PASS {name}: {len(expected)} observed words; {path}', flush=True)


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    root = Path(tempfile.mkdtemp(prefix='pdp10-klh10-isa-v56e-', dir=tmp))
    prefix = Path(os.environ['PDP10_PREFIX']) / 'bin'
    kl = os.environ.get('KLH10_KL') or prefix / 'kn10-kl'
    ks = os.environ.get('KLH10_KS') or prefix / 'kn10-ks'
    # Distinct local memory seed and nonzero computed result on both CPUs.
    local = ['deposit P100 201040000123', 'deposit P101 202040000200',
             'deposit P102 254200000000', 'deposit P200 777']
    for model, emulator in (('kl10', kl), ('ks10', ks)):
        run(emulator, root, model + '-local', local, {0o200: 0o123}, 0)

    startup = fixture('test-kl10b-section-execution-v56b.py')
    for wrong in (False, True):
        name = 'kl10b-negative' if wrong else 'kl10b-positive'
        source = root / (name + '-simh.ini')
        startup.build(source, wrong)
        if wrong:
            expected = {1: startup.ins(0o200, 1, 0o1040, 1), 6: 0,
                        0o11001: 0o123 << 27, 0o12001: 0o123456}
        else:
            expected = dict(enumerate((0o123, 0o123, 0o456, 0o456,
                                       0o777, 0o765), 1))
            expected.update({0o17: 0o3001000, 0o11001: 0o123456000000,
                             0o12001: 0o1001015})
        run(kl, root, name, translate(source), expected, 0o1000000)

    isa = fixture('test-kl10b-global-isa-v56c.py')
    source = root / 'global-simh.ini'
    checks, expected = isa.build(source)
    assert len(checks) == 92 and len(expected) == 20
    expected.update({0o10: len(checks), 0o11: 0o765})
    run(kl, root, 'kl10b-global-isa', translate(source), expected, 0o1000000)
    print('PASS KLH10: both local CPUs, cross-section positive/negative, '
          '92 global ISA assertions and 20 physical data words', flush=True)


if __name__ == '__main__':
    main()
