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

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from aap_guest_console_v1 import run_guest as completed_guest
AAP = Path(os.environ.get('PDP6_AAP_ROOT', str(ROOT.parent / 'pdp6')))
MASK = (1 << 36) - 1
EVENT = re.compile(r'^AAP_TIMING_V1 (IT0|ET0A) tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})$')


def instruction(op, ac, indirect=0, index=0, address=0):
    return (op << 27) | (ac << 23) | (indirect << 22) | (index << 18) | address


def guest(family, number):
    value = number * 7 + 3
    words = {}
    nested = []
    if family == 'jumpn_taken':
        words[0o1000] = instruction(0o201, 1, address=value)
        words[0o1001] = instruction(0o326, 1, address=0o1003)
        words[0o1002] = 0o254200000000
        pcs = [0o1000, 0o1001, 0o1003, 0o1004]
        ops = ['201', '326', '202', '254']
        store = 0o1003
        expected = value
    elif family == 'skipe_taken':
        words[0o1000] = instruction(0o201, 1, address=value)
        words[0o1001] = instruction(0o332, 0, address=0o1010)
        words[0o1002] = 0o254200000000
        words[0o1010] = 0
        pcs = [0o1000, 0o1001, 0o1003, 0o1004]
        ops = ['201', '332', '202', '254']
        store = 0o1003
        expected = value
    elif family == 'addm':
        words[0o1000] = instruction(0o201, 1, address=value)
        words[0o1001] = instruction(0o272, 1, address=0o1010)
        words[0o1010] = number
        pcs = [0o1000, 0o1001, 0o1002, 0o1003]
        ops = ['201', '272', '200', '254']
        words[0o1002] = instruction(0o200, 1, address=0o1010)
        store = None
        expected = value + number
    elif family == 'lsh':
        words[0o1000] = instruction(0o201, 1, address=value)
        words[0o1001] = instruction(0o242, 1, address=number)
        pcs = [0o1000, 0o1001, 0o1002, 0o1003]
        ops = ['201', '242', '202', '254']
        store = 0o1002
        expected = (value << number) & MASK
    elif family == 'push':
        # AC 2 holds stack pointer LH=-1 and RH=1030; PUSH increments
        # both halves before storing to 1031.
        words[0o1010] = (0o777777 << 18) | 0o1030
        words[0o1000] = instruction(0o200, 2, address=0o1010)
        words[0o1001] = instruction(0o201, 1, address=value)
        words[0o1002] = instruction(0o261, 2, address=1)
        words[0o1003] = instruction(0o200, 1, address=0o1031)
        pcs = [0o1000, 0o1001, 0o1002, 0o1003, 0o1004, 0o1005]
        ops = ['200', '201', '261', '200', '202', '254']
        store = 0o1004
        expected = value
    else:
        raise ValueError(family)
    if family == 'addm':
        # Read back ADDM destination directly through console.
        words[0o1003] = 0o254200000000
        return words, pcs, ops, expected, nested, 0o1010
    words[store] = instruction(0o202, 1, address=0o1020)
    words[store + 1] = 0o254200000000
    return words, pcs, ops, expected, nested, 0o1020


def run_case(emulator, work, family, number, cost):
    words, pcs, opcodes, expected, nested, output_address = guest(family, number)
    out, trace, states = completed_guest(emulator, work, words, [output_address], timeout=8)
    assert states[-1] == 'HALTED', (family, number, states)
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
    with tempfile.TemporaryDirectory(prefix='aap-batch50-v3.', dir=os.environ.get('TMPDIR',
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
        for family in ('jumpn_taken', 'skipe_taken', 'addm', 'lsh', 'push'):
            for number in range(1, 11):
                total = run_case(emulator, work, family, number, cost)
                count += 1
                print('%02d/50 %-10s %02d: PASS (%d complete ticks)' %
                      (count, family, number, total), flush=True)
        assert count == 50
        print('AAP real guest batch50 v3: PASS (50/50)')


if __name__ == '__main__':
    main()
