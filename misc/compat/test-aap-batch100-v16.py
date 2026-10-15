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

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from aap_guest_console_v1 import run_guest as completed_guest
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
    """Independent 72-bit unsigned doubleword shifts and rotations."""
    mode = family[:-2]
    count = int(family[-2:]) if family[-2:].isdigit() else int(family[-1])
    # Ten signed and unsigned operand shapes, including sign boundaries.
    left = OPERANDS[number - 1]
    right = OPERANDS[(number + 3) % 10]
    value = (left << 36) | right
    mask72 = (1 << 72) - 1
    if mode == 'lshc':
        op = 0o246
        expected = (value << count) & mask72
    elif mode == 'rotc':
        op = 0o245
        expected = ((value << count) | (value >> (72 - count))) & mask72
    elif mode == 'ashc':
        op = 0o244
        signed = value if left < (1 << 35) else value - (1 << 72)
        expected = (signed << count) & mask72
    else:
        raise ValueError(family)
    words = {
        0o1000: instruction(0o200, 2, address=0o1010),
        0o1001: instruction(0o200, 3, address=0o1011),
        0o1002: instruction(op, 2, address=count),
        0o1003: instruction(0o202, 2, address=0o1020),
        0o1004: instruction(0o202, 3, address=0o1021),
        0o1005: 0o254200000000,
        0o1010: left,
        0o1011: right,
    }
    return words, [0o1000,0o1001,0o1002,0o1003,0o1004,0o1005], ['200','200','%03o' % op,'202','202','254'], expected >> 36, [], 0o1020, expected & MASK


def run_case(emulator, work, family, number, cost):
    words, pcs, opcodes, expected, nested, output_address, expected_low = guest(family, number)
    out, trace, states = completed_guest(emulator, work, words, [output_address, 0o1021], timeout=8)
    assert states[-1] == 'HALTED', (family, number, states)
    values = re.findall(r'%06o: ([0-7]{12})$' % output_address, out, re.MULTILINE)
    assert values == ['%012o' % expected], (family, number, 'last-result', values, expected)
    lower = re.findall(r'001021: ([0-7]{12})$', out, re.MULTILINE)
    assert lower == ['%012o' % expected_low], (family, number, 'low-half', lower, expected_low)
    matches = [EVENT.fullmatch(line) for line in trace.splitlines()]
    assert matches and all(matches), (family, number, 'trace', trace[-800:])
    starts = [m for m in matches if m.group(1) == 'IT0']
    assert len(starts) == len(pcs), (family, number, [m.group(3) for m in starts][:12], pcs)
    assert [m.group(3) for m in starts] == [
        '%06o' % pc for pc in pcs], (family, number)
    ticks = [int(m.group(2)) for m in matches]
    assert all(a < b for a, b in zip(ticks, ticks[1:])), (family, number)
    path = work / 'batch50.trace'
    path.write_text(trace)
    try:
        intervals = cost.intervals(path)
    except ValueError:
        print('BYTE TRACE FAILURE', family, number, trace[-2600:], flush=True)
        raise
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
    with tempfile.TemporaryDirectory(prefix='aap-batch100-v16.', dir=os.environ.get('TMPDIR',
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
        for family in ('lshc01','lshc02','lshc03','lshc09','lshc18','lshc35','rotc01','rotc02','rotc03','rotc09'):
            for number in range(1, 11):
                total = run_case(emulator, work, family, number, cost)
                count += 1
                print('%02d/100 %-10s %02d: PASS (%d complete ticks)' %
                      (count, family, number, total), flush=True)
        assert count == 100
        print('AAP real guest batch100 v16: PASS (100/100)')


if __name__ == '__main__':
    main()
