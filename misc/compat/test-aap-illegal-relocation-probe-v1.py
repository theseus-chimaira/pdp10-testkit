#!/usr/bin/env python3
"""Diagnostic only: JRST mode-transition candidates, NOT ILLOP coverage.

Fail-closed diagnostic: any candidate failing to halt is reported, and a
real ILLOP pulse is reported but does not automatically promote the gate.
The safe normal-JRST control must halt without spurious ILLOP.
Inspect the coherent APR exception latches after HALT; the current PDP-6
emulator intentionally has no AAP pulse-timestamp or class-event trace.
"""
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
AAP = Path(os.environ.get('PDP6_AAP_ROOT', str(ROOT.parent / 'pdp6')))
sys.path.insert(0, str(ROOT / 'tools'))
from aap_guest_console_v1 import run_guest

SOURCES = 'main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split()
CASES = (
    (0o254000001001, True),
    (0o254400001001, True),
    (0o254500001001, False),
    (0o254540001001, False),
    (0o254140001001, False),
    (0o254120001001, False),
    (0o254040001001, False),  # JRST 1: direct mode-change bit
    (0o254100001001, False),  # JRST 2: flags-restoring form
    (0o254040001002, False),  # direct transfer to HALT address
)
with tempfile.TemporaryDirectory(prefix='aap-illegal-relocation-probe-v1.',
     dir=os.environ.get('TMPDIR', str(Path.home() / 'tmp'))) as folder:
    work = Path(folder)
    emulator = work / 'pdp6_n'
    subprocess.run([os.environ.get('CC', 'cc'), '-O2', '-o', str(emulator),
                    *SOURCES, '-lpthread', '-lm'], cwd=AAP / 'emu', check=True)
    (work / 'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\n'
       'mkdev fmem fmem162 0\nmkdev mem0 moby mem_0\n'
       'connectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    for opcode, control in CASES:
        words = {0o1000:opcode, 0o1001:0o200040010000,
                 0o1002:0o254200000000}
        try:
            out, trace, states = run_guest(emulator, work, words, [], timeout=8,
                                            extra_commands='aprclass\n')
        except TimeoutError:
            assert not control, 'ordinary JRST control did not halt'
            print('%012o: no HALT; unresolved' % opcode)
            continue
        assert states[-1] == 'HALTED'
        match = re.search(r'APR_CLASS_V1 NXM=[01] ILLOP=([01]) ', out)
        assert match is not None, 'missing coherent APR exception snapshot'
        illegal = match.group(1) == '1'
        if control:
            assert not illegal, 'ordinary JRST incorrectly emitted ILLOP'
        print('%012o: HALTED ILLOP=%s' % (opcode, illegal))
print('AAP relocation probe v1: APR latch diagnostic only; pulse-level fault gate remains incomplete')
