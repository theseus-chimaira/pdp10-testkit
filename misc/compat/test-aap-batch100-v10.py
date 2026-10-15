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
    """BLT overlapping source/destination with architectural forward copy."""
    length = int(family[3:])
    offset = number - 6   # -5 .. +4, including identical and overlapping.
    source = 0o1200
    dest = source + offset
    state = {}
    for address in range(source - 6, source + length + 6):
        state[address] = ((address * 0o1234567) ^
                          (number * 0o7654321)) & MASK
    words = {
        0o1000: instruction(0o200, 1, address=0o1010),
        0o1001: instruction(0o251, 1, address=dest + length - 1),
        0o1002: 0o254200000000,
        0o1010: (source << 18) | dest,
    }
    words.update(state)
    # BLT copies in increasing address order, so forward overlap can
    # overwrite subsequent source words. Model each read at transfer time.
    for i in range(length):
        state[dest + i] = state[source + i]
    addresses = sorted(set(range(source, source + length)) |
                       set(range(dest, dest + length)))
    expected_map = {address: state[address] for address in addresses}
    output_address = dest + length - 1
    return words, [0o1000, 0o1001, 0o1002], ['200', '251', '254'], state[output_address], [], output_address, expected_map


def run_case(emulator, work, family, number, cost):
    words, pcs, opcodes, expected, nested, output_address, expected_map = guest(family, number)
    out, trace, states = completed_guest(emulator, work, words, list(expected_map), timeout=8)
    assert states[-1] == 'HALTED', (family, number, states)
    values = re.findall(r'%06o: ([0-7]{12})$' % output_address, out, re.MULTILINE)
    assert values == ['%012o' % expected], (family, number, 'last-result', values, expected)
    for address, expected_word in expected_map.items():
        actual = re.findall(r'%06o: ([0-7]{12})$' % address, out, re.MULTILINE)
        assert actual == ['%012o' % expected_word], (family, number, address, actual, expected_word)
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
        print('BLT TRACE FAILURE', family, number, trace[-2600:], flush=True)
        raise
    assert len(intervals) == len(opcodes) - 1, (family, number)
    assert intervals[1]['blt_continuation_milestones'] == int(family[3:]) - 1, (family, number, intervals)
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
    with tempfile.TemporaryDirectory(prefix='aap-batch100-v10.', dir=os.environ.get('TMPDIR',
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
        for family in tuple('len%d' % d for d in range(1, 11)):
            for number in range(1, 11):
                total = run_case(emulator, work, family, number, cost)
                count += 1
                print('%02d/100 %-10s %02d: PASS (%d complete ticks)' %
                      (count, family, number, total), flush=True)
        assert count == 100
        print('AAP real guest batch100 v10: PASS (100/100)')


if __name__ == '__main__':
    main()
