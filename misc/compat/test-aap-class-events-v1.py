#!/usr/bin/env python3
"""Classification grammar and real normal guest event-trace smoke."""
import importlib.util
import os
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('class_events', ROOT/'tools/aap-class-events-v1.py')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
for event in ('NXM','ILLOP','PDLOV','PI_CYCLE'):
    try:
        module.inspect('AAP_CLASS_EVENT_V1 type=%s tick=100 pc=001000\n' % event)
    except ValueError:
        pass
    else:
        raise AssertionError('event was accepted: '+event)
try:
    module.inspect('AAP_CLASS_EVENT_V1 type=UNKNOWN tick=1 pc=001000\n')
except ValueError:
    pass
else:
    raise AssertionError('unknown event accepted')
assert module.inspect('AAP_TIMING_V1 IT0 tick=1 pc=001000 inst=254\n')
for op in ('700', '710', '777'):
    try:
        module.inspect('AAP_TIMING_V1 IT0 tick=1 pc=001000 inst='+op+'\n')
    except ValueError as exc:
        assert 'device-I/O' in str(exc)
    else:
        raise AssertionError('IOT opcode accepted: '+op)
sys.path.insert(0, str(ROOT/'tools'))
from aap_guest_console_v1 import run_guest
EMULATOR = ROOT.parent/'pdp6'/'emu'
SOURCES = ['main_net.c','emu.c','apr.c','mem.c','tty.c','pt.c','dc.c','dt.c',
           'pclk.c','netmem.c','netcons.c','cmd.c','util.c','threading.c',
           'rtc.c','../tools/pdp6common.c']
with tempfile.TemporaryDirectory(prefix='aap-class-events-v1.',
       dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as folder:
    work = Path(folder)
    subprocess.run([os.environ.get('CC','cc'),'-O2','-o',str(work/'pdp6_n'),
                    *SOURCES,'-lpthread','-lm'],cwd=EMULATOR,check=True)
    (work/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\n'
      'mkdev fmem fmem162 0\nmkdev mem0 moby mem_0\n'
      'connectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    os.environ['PDP6_AAP_CLASS_TRACE_V1']='1'
    out, trace, states = run_guest(work/'pdp6_n',work,
       {0o1000:0o201040000001,0o1001:0o254200000000}, [],timeout=8)
    assert states[-1]=='HALTED'
    assert module.inspect(trace)
    # Real non-existent-memory access using a 16K PDP-6 core unit.
    # A 256K 'moby' unit would make this address valid.
    (work/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\n'
      'mkdev fmem fmem162 0\nmkdev mem0 cmem161C mem_0\n'
      'connectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    out, trace, states = run_guest(work/'pdp6_n', work,
       {0o1000:0o200040777777, 0o1001:0o254200000000}, [], timeout=8)
    assert states[-1]=='HALTED'
    assert 'AAP_CLASS_EVENT_V1 type=NXM ' in trace, trace[-800:]
    try:
        module.inspect(trace)
    except ValueError as exc:
        assert 'NXM' in str(exc)
    else:
        raise AssertionError('real non-existent memory read was accepted')
print('AAP pulse classification v1: PASS (normal guest, real NXM, and event grammar)')
