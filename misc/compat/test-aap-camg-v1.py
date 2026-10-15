#!/usr/bin/env python3
"""Real PDP-6 AAP CAMG signed comparison, skip and timing regression."""
import os,re,sys,tempfile,subprocess
from pathlib import Path
from importlib.util import spec_from_file_location,module_from_spec
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools'))
from aap_guest_console_v1 import run_guest
spec=spec_from_file_location('cost',ROOT/'tools/aap-tick-cost-v1.py')
cost=module_from_spec(spec);spec.loader.exec_module(cost)
MASK=(1<<36)-1
CASES=((0,0),(0,1),(1,0),(1,1),(-1,0),(0,-1),(-3,-2),(-2,-3),(1,-1),(-1,1),((1<<35)-1,0),(-(1<<35),0),(0,-(1<<35)))
with tempfile.TemporaryDirectory(prefix='aap-camg-v1.',dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as directory:
    work=Path(directory);emulator=work/'pdp6_n'
    subprocess.run([os.environ.get('CC','cc'),'-O2','-o',str(emulator),
        *'main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split(),
        '-lpthread','-lm'],cwd=ROOT.parent/'pdp6/emu',check=True)
    (work/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\nmkdev fmem fmem162 0\nmkdev mem0 moby mem_0\nconnectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    for ac,operand in CASES:
        # MOVE 1,ac; CAMG 1,operand; MOVEI 2,1; MOVEM 2,marker;
        # MOVEM 1,saved; HALT. Skip means marker remains zero.
        words={0o1000:(0o200<<27)|(1<<23)|0o1020,
               0o1001:(0o317<<27)|(1<<23)|0o1021,
               0o1002:(0o201<<27)|(2<<23)|1,
               0o1003:(0o202<<27)|(2<<23)|0o1022,
               0o1004:(0o202<<27)|(1<<23)|0o1023,
               0o1005:0o254200000000,
               0o1020:ac&MASK,0o1021:operand&MASK,0o1022:0,0o1023:0}
        out,trace,states=run_guest(emulator,work,words,[0o1021,0o1022,0o1023],timeout=8)
        assert states[-1]=='HALTED',(ac,operand)
        # CAMG skips its following instruction for signed AC >= memory.
        expected_marker=0 if ac>operand else 1
        for address,expected in ((0o1021,operand),(0o1022,expected_marker),(0o1023,ac)):
            assert re.search(r'%06o: %012o' %(address,expected&MASK),out),(ac,operand,address,out)
        path=work/'camg-v1.trace';path.write_text(trace)
        intervals=cost.intervals(path)
        assert any(i['opcode_octal']=='317' and i['ticks']>0 for i in intervals),(ac,operand)
        assert any(i['pc']=='001002' for i in intervals)==(expected_marker==1),(ac,operand)
print('AAP CAMG v1: PASS (%d signed compare/skip cases)' %len(CASES))
