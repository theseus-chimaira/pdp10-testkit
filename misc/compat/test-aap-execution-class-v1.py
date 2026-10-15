#!/usr/bin/env python3
"""Regress APR exception and PI latch snapshots with real guests.

The signed minimum divided by -1 overflows a signed 36-bit quotient.
Its neighboring valid quotient and divide-by-zero exercise both sides
of the processor overflow flag decision.
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
from aap_guest_console_v1 import run_guest
AAP = Path(os.environ.get('PDP6_AAP_ROOT', str(ROOT.parent / 'pdp6')))
MASK = (1 << 36) - 1


def instruction(op, ac, address=0):
    return (op << 27) | (ac << 23) | address


def guest(dividend, divisor):
    return {0o1000: instruction(0o200, 2, 0o1010),
            0o1001: instruction(0o200, 3, 0o1011),
            0o1002: instruction(0o230, 2, 0o1012),
            0o1003: instruction(0o202, 2, 0o1020),
            0o1004: instruction(0o202, 3, 0o1021),
            0o1005: 0o254200000000,
            0o1010: dividend & MASK, 0o1011: 0,
            0o1012: divisor & MASK}


def main():
    temp_root = Path(os.environ.get('TMPDIR', str(Path.home() / 'tmp')))
    temp_root.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='aap-aprflags-v1.', dir=temp_root) as temp:
        work = Path(temp)
        emulator = work / 'pdp6_n'
        sources = ['main_net.c', 'emu.c', 'apr.c', 'mem.c', 'tty.c', 'pt.c', 'dc.c',
                   'dt.c', 'pclk.c', 'netmem.c', 'netcons.c', 'cmd.c', 'util.c',
                   'threading.c', 'rtc.c', '../tools/pdp6common.c']
        subprocess.run([os.environ.get('CC', 'cc'), '-O2', '-o', str(emulator)] +
                       sources + ['-lpthread', '-lm'], cwd=AAP / 'emu', check=True)
        (work / 'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\n'
                                       'mkdev fmem fmem162 0\nmkdev mem0 moby mem_0\n'
                                       'connectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
        for name, dividend, divisor in [('normal', 120, 7),
                                         ('zero-divisor', 120, 0),
                                         ('quotient-overflow', -(1 << 35), -1),
                                         ('near-boundary', -(1 << 35) + 1, -1),
                                         ('positive-limit', (1 << 35)-1, 1)]:
            out, trace, states = run_guest(emulator, work, guest(dividend, divisor),
                                           [0o1020, 0o1021], extra_commands='aprclass\n')
            flags = re.findall(r'APR_CLASS_V1 NXM=([01]) ILLOP=([01]) PDLOV=([01]) PI_ACTIVE=([01]) PI_REQ=([0-7]{3}) PI_CYC=([01])', out)
            assert len(flags) == 1, (name, out)
            assert flags[0] == ('0', '0', '0', '0', '000', '0'), (name, flags)
            assert states[-1] == 'HALTED'
            print('APR execution classification normal %s: PASS' % name, flush=True)



if __name__ == '__main__':
    main()
