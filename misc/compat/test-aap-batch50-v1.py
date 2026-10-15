#!/usr/bin/env python3
"""50 deterministic real PDP-6 AAP timing/semantic guest cases.

Five instruction/addressing families times ten input values. The expected
result is derived from each PDP-10 operation, not from emulator output.
"""
import importlib.util
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parents[2]
AAP = Path(os.environ.get('PDP6_AAP_ROOT', str(ROOT.parent / 'pdp6')))
MASK = (1 << 36) - 1
EVENT = re.compile(r'^AAP_TIMING_V1 (IT0|ET0A) tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})$')


def instruction(op, ac, indirect=0, index=0, address=0):
    return (op << 27) | (ac << 23) | (indirect << 22) | (index << 18) | address


def guest(family, number):
    value = number * 7 + 3
    words = {}
    if family == 'direct':
        words[0o1000] = instruction(0o200, 1, address=0o1010)
        words[0o1010] = value
        opcodes = ['200', '202', '254']
        expected = value
    elif family == 'indexed':
        words[0o1000] = instruction(0o201, 2, address=2)
        words[0o1001] = instruction(0o200, 1, index=2, address=0o1010)
        words[0o1012] = value
        opcodes = ['201', '200', '202', '254']
        expected = value
    elif family == 'indirect':
        words[0o1000] = instruction(0o200, 1, indirect=1, address=0o1010)
        words[0o1010] = 0o1012
        words[0o1012] = value
        opcodes = ['200', '202', '254']
        expected = value
    elif family == 'nested':
        words[0o1000] = instruction(0o200, 1, indirect=1, address=0o1010)
        words[0o1010] = (1 << 22) | 0o1014
        words[0o1014] = 0o1016
        words[0o1016] = value
        opcodes = ['200', '202', '254']
        expected = value
    elif family == 'arithmetic':
        words[0o1000] = instruction(0o201, 1, address=value)
        words[0o1001] = instruction(0o271, 1, address=number)
        opcodes = ['201', '271', '202', '254']
        expected = (value + number) & MASK
    else:
        raise ValueError(family)
    address = 0o1000 + len(opcodes) - 2
    words[address] = instruction(0o202, 1, address=0o1020)
    words[address + 1] = 0o254200000000
    return words, opcodes, expected


def run_case(emulator, work, family, number, cost):
    words, opcodes, expected = guest(family, number)
    lines = ['power on'] + ['deposit %o %012o' % (a, w) for a, w in sorted(words.items())]
    lines.append('start 1000')
    proc = subprocess.Popen([str(emulator)], cwd=work, stdin=subprocess.PIPE,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                            text=True, env=dict(os.environ, PDP6_AAP_TIMING_TRACE_V1='1'))
    try:
        proc.stdin.write('\n'.join(lines) + '\n')
        proc.stdin.flush()
        time.sleep(0.3)
        proc.stdin.write('examine 1020\nquit\n')
        proc.stdin.flush()
        out, trace = proc.communicate(timeout=8)
    except BaseException:
        proc.kill()
        proc.communicate()
        raise
    if proc.returncode:
        raise AssertionError('%s-%02d: emulator exit %s' % (family, number, proc.returncode))
    values = re.findall(r'001020: ([0-7]{12})$', out, re.MULTILINE)
    assert values == ['%012o' % expected], (family, number, 'result', values, expected)
    matches = [EVENT.fullmatch(line) for line in trace.splitlines()]
    assert matches and all(matches), (family, number, 'trace', trace[-800:])
    assert [m.group(1) for m in matches] == ['IT0', 'ET0A'] * len(opcodes), (family, number)
    assert [m.group(4) for m in matches[1::2]] == opcodes, (family, number)
    assert [m.group(3) for m in matches[1::2]] == [
        '%06o' % (0o1000 + i) for i in range(len(opcodes))], (family, number)
    ticks = [int(m.group(2)) for m in matches]
    assert all(a < b for a, b in zip(ticks, ticks[1:])), (family, number)
    path = work / 'batch50.trace'
    path.write_text(trace)
    intervals = cost.intervals(path)
    assert len(intervals) == len(opcodes) - 1, (family, number)
    assert [i['opcode_octal'] for i in intervals] == opcodes[:-1], (family, number)
    assert all(i['ticks'] > 0 for i in intervals), (family, number)
    return sum(i['ticks'] for i in intervals)


def main():
    spec = importlib.util.spec_from_file_location('cost', ROOT / 'tools/aap-tick-cost-v1.py')
    cost = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(cost)
    with tempfile.TemporaryDirectory(prefix='aap-batch50-v1.', dir=os.environ.get('TMPDIR',
                                      str(Path.home() / 'tmp'))) as directory:
        work = Path(directory)
        emulator = work / 'pdp6_n'
        sources = ['main_net.c', 'emu.c', 'apr.c', 'mem.c', 'tty.c', 'pt.c', 'dc.c',
                   'dt.c', 'pclk.c', 'netmem.c', 'netcons.c', 'cmd.c', 'util.c',
                   'threading.c', 'rtc.c', '../tools/pdp6common.c']
        subprocess.run([os.environ.get('CC', 'cc'), '-O2', '-o', str(emulator)] +
                       sources + ['-lpthread', '-lm'], cwd=AAP / 'emu', check=True)
        (work / 'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\n'
                                       'mkdev fmem fmem162 0\nmkdev mem0 moby mem_0\n'
                                       'connectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
        count = 0
        for family in ('direct', 'indexed', 'indirect', 'nested', 'arithmetic'):
            for number in range(1, 11):
                total = run_case(emulator, work, family, number, cost)
                count += 1
                print('%02d/50 %-10s %02d: PASS (%d complete ticks)' %
                      (count, family, number, total), flush=True)
        assert count == 50
        print('AAP real guest batch50 v1: PASS (50/50)')


if __name__ == '__main__':
    main()
