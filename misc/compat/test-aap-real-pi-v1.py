#!/usr/bin/env python3
"""Real PDP-6 PI request/entry versus PI-enabled no-request control.

Bounds the execution interval because interrupt dispatch is not guaranteed
 to halt. A real PI_CYCLE pulse, not a fabricated trace line, is required.
"""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[2]
SOURCES = 'main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c'.split()

def load(name, filename):
    spec = importlib.util.spec_from_file_location(name, ROOT/'tools'/filename)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

cost = load('aap_tick_cost', 'aap-tick-cost-v1.py')
classifier = load('aap_class_events', 'aap-class-events-v1.py')
with tempfile.TemporaryDirectory(prefix='aap-real-pi-v1.', dir=os.environ.get('TMPDIR', str(Path.home()/'tmp'))) as temp:
    work = Path(temp)
    emulator = work/'pdp6_n'
    subprocess.run([os.environ.get('CC', 'cc'), '-O2', '-o', str(emulator),
                    *SOURCES, '-lpthread', '-lm'], cwd=ROOT.parent/'pdp6/emu', check=True)
    (work/'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\n'
       'mkdev fmem fmem162 0\nmkdev mem0 moby mem_0\n'
       'connectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
    env = dict(os.environ, PDP6_AAP_CLASS_TRACE_V1='1', PDP6_AAP_TIMING_TRACE_V1='1')
    # The PI CONO halfword is 700600, selecting I/O device 0004,
    # which APR decodes as bus device 1. Prior 704200 probes did not
    # address PI. F28 (000200) enables PI; F24 (004000) plus channel
    # bit 000100 posts a real request; the following JRST spins.
    for request, expected in ((0o4200, False), (0o4100, True), (0o4300, True)):
        words = {0o1000:0o700600000200,
                 0o1001:(0o700600<<18)|request,
                 0o1002:0o254000001002}
        commands = ('power on\n' + ''.join('deposit %o %012o\n' % (a, word)
                    for a, word in sorted(words.items())) + 'start 1000\n')
        with subprocess.Popen([str(emulator)], cwd=work, stdin=subprocess.PIPE,
               stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=env) as proc:
            try:
                _, stderr = proc.communicate(commands.encode('ascii'), timeout=0.5)
            except subprocess.TimeoutExpired:
                proc.kill()
                _, stderr = proc.communicate()
        trace = stderr.decode('ascii', errors='replace')
        pi = [line for line in trace.splitlines()
              if line.startswith('AAP_CLASS_EVENT_V1 type=PI_CYCLE ')]
        assert bool(pi) == expected, (oct(request), pi[:3], trace[-400:])
        path = work/'pi-timing.trace'
        path.write_text(trace)
        if expected:
            for method in (lambda: classifier.inspect(trace), lambda: cost.intervals(path)):
                try:
                    method()
                except ValueError:
                    pass
                else:
                    raise AssertionError('real PI trace accepted as normal instruction timing')
        else:
            # I/O instructions are also forbidden in ordinary CPU timing.
            try:
                classifier.inspect(trace)
            except ValueError as exc:
                assert 'device-I/O' in str(exc), str(exc)
            else:
                raise AssertionError('PI CONO accepted by normal classifier')
print('AAP real PI v1: PASS (PI-cycle request/control and fail-closed timing)')
