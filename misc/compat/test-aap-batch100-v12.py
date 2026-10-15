#!/usr/bin/env python3
"""100 deterministic real PDP-6 AAP timing/semantic guest cases.

Ten instruction families times ten boundary operands. The expected
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


# Include the sign boundary, -1, zero and large-magnitude operands.
OPERANDS = (0, 1, 2, 0o777777, 0o400000000000,
            MASK, 0o377777777777, 0o400000000001,
            0o123456701234, 0o765432107654)


def guest(family, number):
    """AOJ/SOJ arithmetic-and-conditional-jump with signed boundaries."""
    signed = number - 6
    value = signed & MASK
    is_soj = family.startswith('soj')
    result = signed - 1 if is_soj else signed + 1
    op = {'aojl': 0o341, 'aoje': 0o342, 'aojle': 0o343,
          'aojge': 0o345, 'aojn': 0o346,
          'sojl': 0o361, 'soje': 0o362, 'sojle': 0o363,
          'sojge': 0o365, 'sojn': 0o366}[family]
    condition = family[-1] if family[-2:] not in ('le','ge') else family[-2:]
    taken = {'l': result < 0, 'e': result == 0,
             'le': result <= 0, 'ge': result >= 0,
             'n': result != 0}[condition]
    words = {
        0o1000: instruction(0o200, 1, address=0o1010),
        0o1001: instruction(op, 1, address=0o1003),
        0o1002: instruction(0o254, 0, address=0o1003),
        0o1003: instruction(0o202, 1, address=0o1020),
        0o1004: 0o254200000000,
        0o1010: value,
    }
    pcs = [0o1000, 0o1001] + ([] if taken else [0o1002]) + [0o1003, 0o1004]
    ops = ['200','%03o' % op] + ([] if taken else ['254']) + ['202','254']
    return words, pcs, ops, result & MASK, [], 0o1020


def run_case(emulator, work, family, number, cost):
    words, pcs, opcodes, expected, nested, output_address = guest(family, number)
    lines = ['power on'] + ['deposit %o %012o' % (a, w) for a, w in sorted(words.items())]
    lines.append('start 1000')
    proc = subprocess.Popen([str(emulator)], cwd=work, stdin=subprocess.PIPE,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                            text=True, env=dict(os.environ, PDP6_AAP_TIMING_TRACE_V1='1'))
    try:
        proc.stdin.write('\n'.join(lines) + '\n')
        proc.stdin.flush()
        time.sleep(0.3)
        proc.stdin.write('examine %o\nquit\n' % output_address)
        proc.stdin.flush()
        out, trace = proc.communicate(timeout=8)
    except BaseException:
        proc.kill()
        proc.communicate()
        raise
    if proc.returncode:
        raise AssertionError('%s-%02d: emulator exit %s' % (family, number, proc.returncode))
    values = re.findall(r'%06o: ([0-7]{12})$' % output_address, out, re.MULTILINE)
    assert values == ['%012o' % expected], (family, number, 'result', values, expected)
    matches = [EVENT.fullmatch(line) for line in trace.splitlines()]
    assert matches and all(matches), (family, number, 'trace', trace[-800:])
    starts = [m for m in matches if m.group(1) == 'IT0']
    assert len(starts) == len(pcs), (family, number)
    assert [m.group(3) for m in starts] == [
        '%06o' % pc for pc in pcs], (family, number)
    ticks = [int(m.group(2)) for m in matches]
    assert all(a < b for a, b in zip(ticks, ticks[1:])), (family, number)
    path = work / 'batch50.trace'
    path.write_text(trace)
    intervals = cost.intervals(path)
    assert len(intervals) == len(opcodes) - 1, (family, number)
    assert [i['opcode_octal'] for i in intervals] == opcodes[:-1], (family, number)
    assert [i['pc'] for i in intervals] == [
        '%06o' % pc for pc in pcs[:-1]], (family, number)
    assert all(i['ticks'] > 0 for i in intervals), (family, number)
    assert intervals[0]['nested_opcodes_octal'] == nested, (family, number)
    return sum(i['ticks'] for i in intervals)


def main():
    spec = importlib.util.spec_from_file_location('cost', ROOT / 'tools/aap-tick-cost-v1.py')
    cost = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(cost)
    with tempfile.TemporaryDirectory(prefix='aap-batch100-v12.', dir=os.environ.get('TMPDIR',
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
        for family in ('aojl','aoje','aojle','aojge','aojn','sojl','soje','sojle','sojge','sojn'):
            for number in range(1, 11):
                total = run_case(emulator, work, family, number, cost)
                count += 1
                print('%02d/100 %-10s %02d: PASS (%d complete ticks)' %
                      (count, family, number, total), flush=True)
        assert count == 100
        print('AAP real guest batch100 v12: PASS (100/100)')


if __name__ == '__main__':
    main()
