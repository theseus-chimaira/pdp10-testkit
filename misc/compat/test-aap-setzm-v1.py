#!/usr/bin/env python3
"""Standalone real AAP SETZM memory-clear cases for DAIMOS assembler."""
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools'))
from aap_guest_console_v1 import run_guest
from importlib.util import spec_from_file_location,module_from_spec
spec=spec_from_file_location('cost',ROOT/'tools/aap-tick-cost-v1.py')
cost=module_from_spec(spec);spec.loader.exec_module(cost)
with tempfile.TemporaryDirectory(prefix='aap-setzm-v1.',dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as directory:
    work=Path(directory)
    emulator=work/'pdp6_n'
    subprocess.run([os.environ.get('CC','cc'),'-O2','-o',str(emulator),
        *'main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split(),
        '-lpthread','-lm'],cwd=ROOT.parent/'pdp6/emu',check=True)
    (work/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\nmkdev fmem fmem162 0\nmkdev mem0 moby mem_0\nconnectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    for index,value in enumerate((0,1,0o777777777777,0o400000000000,0o123456701234)):
        # MOVE AC1,value; SETZM AC1,target; MOVEM AC1,check; HALT.
        # SETZM changes the memory operand only, not AC1.
        words={0o1000:(0o200<<27)|(1<<23)|0o1010,
               0o1001:(0o402<<27)|(1<<23)|0o1011,
               0o1002:(0o202<<27)|(1<<23)|0o1012,
               0o1003:0o254200000000,
               0o1010:value,0o1011:0o765432107654,0o1012:0}
        out,trace,states=run_guest(emulator,work,words,[0o1011,0o1012],timeout=8)
        assert states[-1]=='HALTED',index
        assert re.search(r'001011: 000000000000',out), (index,out)
        assert re.search(r'001012: %012o' % value,out), (index,out)
        tracepath=work/'setzm-v1.trace';tracepath.write_text(trace)
        intervals=cost.intervals(tracepath)
        assert any(v['opcode_octal']=='402' for v in intervals), (index,intervals)
print('AAP SETZM v1: PASS (five real memory clear/AC preservation cases)')
