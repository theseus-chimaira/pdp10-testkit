#!/usr/bin/env python3
"""Real protected user-reference ILLOP and fail-closed tick accounting."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[2]
EMU=ROOT.parent/'pdp6/emu'
SOURCES='main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split()
def load(name, file):
    spec=importlib.util.spec_from_file_location(name,ROOT/'tools'/file)
    module=importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module
cost=load('aap_cost', 'aap-tick-cost-v1.py')
classifier=load('aap_classes', 'aap-class-events-v1.py')
with tempfile.TemporaryDirectory(prefix='aap-real-illop-v1.',dir=os.environ.get('TMPDIR',str(Path.home()/'tmp'))) as temp:
    work=Path(temp)
    binary=work/'pdp6_n'
    subprocess.run([os.environ.get('CC','cc'),'-O2','-o',str(binary),*SOURCES,'-lpthread','-lm'],cwd=EMU,check=True)
    (work/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\nmkdev fmem fmem162 0\nmkdev mem0 moby mem_0\nconnectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    env=dict(os.environ,PDP6_AAP_CLASS_TRACE_V1='1',PDP6_AAP_TIMING_TRACE_V1='1')
    # JRST 1 sets EX_MODE_SYNC; on the following fetch EX_USER becomes
    # active with PR=0, and MOVE attempts protected address 010000.
    for opcode,expect_fault in ((0o254000001001,False),(0o254040001001,True)):
        words={0o1000:opcode,0o1001:0o200040010000,0o1002:0o254200000000}
        commands='power on\n'+''.join('deposit %o %012o\n'%(addr,word) for addr,word in sorted(words.items()))+'start 1000\n'
        with subprocess.Popen([str(binary)],cwd=work,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.PIPE,env=env) as proc:
            try:
                out,err=proc.communicate(commands.encode(),timeout=0.4)
            except subprocess.TimeoutExpired:
                proc.kill()
                out,err=proc.communicate()
        trace=err.decode('ascii',errors='replace')
        events=[line for line in trace.splitlines() if line.startswith('AAP_CLASS_EVENT_V1 type=ILLOP ')]
        assert bool(events)==expect_fault,(oct(opcode),events[:3])
        tracepath=work/'fault.trace';tracepath.write_text(trace)
        if expect_fault:
            assert 'pc=001001' in events[0],events[0]
            for method in (classifier.inspect,lambda text: cost.intervals(tracepath)):
                try:method(trace)
                except ValueError:pass
                else:raise AssertionError('real ILLOP trace accepted into normal timing')
        else:
            assert classifier.inspect(trace)
            assert cost.intervals(tracepath)
print('AAP real ILLOP v1: PASS (protected access; normal controls; accounting rejected)')
