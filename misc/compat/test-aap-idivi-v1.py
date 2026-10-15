#!/usr/bin/env python3
"""Real AAP signed IDIVI immediate quotient/remainder and timing tests."""
import os,re,sys,tempfile,subprocess
from pathlib import Path
from importlib.util import spec_from_file_location,module_from_spec
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools'))
from aap_guest_console_v1 import run_guest
spec=spec_from_file_location('cost',ROOT/'tools/aap-tick-cost-v1.py')
cost=module_from_spec(spec);spec.loader.exec_module(cost)
MASK=(1<<36)-1
# Positive and negative dividends, and positive immediate divisors. Signed
# division truncates toward zero; the remainder carries dividend's sign.
CASES=((0,1),(1,1),(17,3),(100,7),(12345,17),(-1,1),(-17,3),(-100,7),(-12345,17))
with tempfile.TemporaryDirectory(prefix='aap-idivi-v1.',dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as directory:
    work=Path(directory);emulator=work/'pdp6_n'
    subprocess.run([os.environ.get('CC','cc'),'-O2','-o',str(emulator),
        *'main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split(),
        '-lpthread','-lm'],cwd=ROOT.parent/'pdp6/emu',check=True)
    (work/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\nmkdev fmem fmem162 0\nmkdev mem0 moby mem_0\nconnectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    for dividend,divisor in CASES:
        # MOVE 2,dividend; MOVEI 3,0; IDIVI 2,divisor;
        # store AC2 quotient and AC3 remainder; HALT.
        words={0o1000:(0o200<<27)|(2<<23)|0o1010,
               0o1001:(0o201<<27)|(3<<23),
               0o1002:(0o231<<27)|(2<<23)|divisor,
               0o1003:(0o202<<27)|(2<<23)|0o1020,
               0o1004:(0o202<<27)|(3<<23)|0o1021,
               0o1005:0o254200000000,
               0o1010:dividend&MASK,0o1020:0,0o1021:0}
        out,trace,states=run_guest(emulator,work,words,[0o1010,0o1020,0o1021],timeout=8)
        magnitude=abs(dividend)//divisor
        quotient=-magnitude if dividend<0 else magnitude
        remainder=dividend-quotient*divisor
        assert states[-1]=='HALTED',dividend
        for address,expected in ((0o1010,dividend),(0o1020,quotient),(0o1021,remainder)):
            assert re.search(r'%06o: %012o' % (address,expected&MASK),out),(dividend,divisor,out)
        path=work/'idivi-v1.trace';path.write_text(trace)
        assert any(v['opcode_octal']=='231' and v['ticks']>0 for v in cost.intervals(path)),(dividend,trace)
print('AAP IDIVI v1: PASS (%d real signed immediate division cases)' % len(CASES))
