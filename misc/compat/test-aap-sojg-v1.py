#!/usr/bin/env python3
"""Standalone AAP SOJG exact-form signed decrement/branch timing cases."""
import os,re,sys,tempfile,subprocess
from pathlib import Path
from importlib.util import spec_from_file_location,module_from_spec
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools'))
from aap_guest_console_v1 import run_guest
spec=spec_from_file_location('cost',ROOT/'tools/aap-tick-cost-v1.py')
cost=module_from_spec(spec);spec.loader.exec_module(cost)
MASK=(1<<36)-1
with tempfile.TemporaryDirectory(prefix='aap-sojg-v1.',dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as directory:
    work=Path(directory);emulator=work/'pdp6_n'
    subprocess.run([os.environ.get('CC','cc'),'-O2','-o',str(emulator),
        *'main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split(),
        '-lpthread','-lm'],cwd=ROOT.parent/'pdp6/emu',check=True)
    (work/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\nmkdev fmem fmem162 0\nmkdev mem0 moby mem_0\nconnectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    for initial in (0,1,2,3,MASK,MASK-1,0o400000000000):
        # MOVE 1,initial; SOJG 1,taken; MOVEI 2,1; JRST finish;
        # taken: MOVEI 2,2; finish: MOVEM 1,result; MOVEM 2,branch; HALT.
        words={0o1000:(0o200<<27)|(1<<23)|0o1020,
               0o1001:(0o367<<27)|(1<<23)|0o1004,
               0o1002:(0o201<<27)|(2<<23)|1,
               0o1003:0o254000001005,
               0o1004:(0o201<<27)|(2<<23)|2,
               0o1005:(0o202<<27)|(1<<23)|0o1021,
               0o1006:(0o202<<27)|(2<<23)|0o1022,
               0o1007:0o254200000000,
               0o1020:initial,0o1021:0,0o1022:0}
        out,trace,states=run_guest(emulator,work,words,[0o1021,0o1022],timeout=8)
        result=(initial-1)&MASK
        taken=0 < result < (1<<35)
        assert states[-1]=='HALTED',initial
        assert re.search(r'001021: %012o' % result,out),(initial,out)
        assert re.search(r'001022: %012o' % (2 if taken else 1),out),(initial,out)
        path=work/'sojg-v1.trace';path.write_text(trace)
        intervals=cost.intervals(path)
        assert any(v['opcode_octal']=='367' for v in intervals),(initial,intervals)
print('AAP SOJG v1: PASS (seven real signed decrement/branch cases)')
