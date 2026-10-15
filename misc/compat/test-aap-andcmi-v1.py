#!/usr/bin/env python3
"""Standalone AAP ANDCMI immediate complemented-mask AND and timing."""
import os,re,sys,tempfile,subprocess
from pathlib import Path
from importlib.util import spec_from_file_location,module_from_spec
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools'))
from aap_guest_console_v1 import run_guest
spec=spec_from_file_location('cost',ROOT/'tools/aap-tick-cost-v1.py')
cost=module_from_spec(spec);spec.loader.exec_module(cost)
MASK=(1<<18)-1
with tempfile.TemporaryDirectory(prefix='aap-andcmi-v1.',dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as directory:
    work=Path(directory);emulator=work/'pdp6_n'
    subprocess.run([os.environ.get('CC','cc'),'-O2','-o',str(emulator),
        *'main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split(),
        '-lpthread','-lm'],cwd=ROOT.parent/'pdp6/emu',check=True)
    (work/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\nmkdev fmem fmem162 0\nmkdev mem0 moby mem_0\nconnectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    for old,left in ((0,0),(0o777777777777,0),(0,0o777777),(0o123456765432,0o400000),(0o765432123456,0o123456)):
        # MOVE 1,old; ANDCMI 1,left; MOVEM 1,result; HALT.
        words={0o1000:(0o200<<27)|(1<<23)|0o1010,
               0o1001:(0o421<<27)|(1<<23)|left,
               0o1002:(0o202<<27)|(1<<23)|0o1011,
               0o1003:0o254200000000,0o1010:old,0o1011:0}
        out,trace,states=run_guest(emulator,work,words,[0o1010,0o1011],timeout=8)
        expected=old & (~left & ((1<<36)-1))
        assert states[-1]=='HALTED'
        assert re.search(r'001011: %012o' % expected,out),(oct(old),oct(left),out)
        assert re.search(r'001010: %012o' % old,out),out
        path=work/'andcmi-v1.trace';path.write_text(trace)
        assert any(v['opcode_octal']=='421' for v in cost.intervals(path))
print('AAP ANDCMI v1: PASS (five real immediate complemented-mask ANDs)')
