#!/usr/bin/env python3
"""Real AAP linked deposit fetch, independently read back and traced.

A controlled one-instruction image proof, NOT a kernel/MRES hotpath test.
"""
import os
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT/'tools'))
from aap_guest_console_v1 import run_guest

with tempfile.TemporaryDirectory(prefix='aap-linked-load-v1.',
        dir=os.environ.get('TMPDIR', str(Path.home()/'tmp'))) as folder:
    work = Path(folder)
    emulator = work/'pdp6_n'
    subprocess.run([os.environ.get('CC','cc'),'-O2','-o',str(emulator),
       *'main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split(),
       '-lpthread','-lm'],cwd=ROOT.parent/'pdp6/emu',check=True)
    (work/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\n'
       'mkdev fmem fmem162 0\nmkdev mem0 moby mem_0\n'
       'connectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    # Exercise start_address against a linked-image-like nondefault load PC.
    address = 0o13436
    words = {address:0o254200000000}
    out, trace, states = run_guest(emulator,work,words,[address],
                                   timeout=8,start_address=address)
    assert states[-1]=='HALTED'
    assert '013436: 254200000000' in out
    assert 'AAP_TIMING_V1 IT0 ' in trace and 'pc=013436' in trace
print('AAP nondefault linked-address fetch v1: PASS (real guest)')
