#!/usr/bin/env python3
"""Trace-on/off correctness and repeated AAP logical-tick reproducibility.

Twenty independently checked guest programs; three runs per case.
Does not establish deterministic guest stop detection or interrupt timing.
"""
import importlib.util
import os
from pathlib import Path
import re
import subprocess
import tempfile
import time

ROOT = Path(__file__).resolve().parents[2]
AAP = Path(os.environ.get('PDP6_AAP_ROOT', str(ROOT.parent / 'pdp6')))


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def run(emulator, work, words, result_address, trace_enabled):
    commands = ['power on'] + ['deposit %o %012o' % item for item in sorted(words.items())]
    commands.append('start 1000')
    env = dict(os.environ)
    env['PDP6_AAP_TIMING_TRACE_V1'] = '1' if trace_enabled else '0'
    proc = subprocess.Popen([str(emulator)], cwd=work, stdin=subprocess.PIPE,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                            text=True, env=env)
    try:
        proc.stdin.write('\n'.join(commands) + '\n')
        proc.stdin.flush()
        time.sleep(0.3)
        proc.stdin.write('examine %o\nquit\n' % result_address)
        proc.stdin.flush()
        output, trace = proc.communicate(timeout=8)
    except BaseException:
        proc.kill()
        proc.communicate()
        raise
    assert proc.returncode == 0
    values = re.findall(r'%06o: ([0-7]{12})$' % result_address,
                        output, re.MULTILINE)
    assert len(values) == 1, (result_address, output)
    return values[0], trace


def main():
    guest_module = load('aap_batch50_v1', ROOT / 'misc/compat/test-aap-batch50-v1.py')
    parser = load('aap_tick_cost_v1', ROOT / 'tools/aap-tick-cost-v1.py')
    temp_root = Path(os.environ.get('TMPDIR', str(Path.home() / 'tmp')))
    temp_root.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='aap-instrumentation-v1.', dir=temp_root) as temp:
        work = Path(temp)
        emulator = work / 'pdp6_n'
        sources = ['main_net.c', 'emu.c', 'apr.c', 'mem.c', 'tty.c', 'pt.c', 'dc.c',
                   'dt.c', 'pclk.c', 'netmem.c', 'netcons.c', 'cmd.c', 'util.c',
                   'threading.c', 'rtc.c', '../tools/pdp6common.c']
        subprocess.run([os.environ.get('CC', 'cc'), '-O2', '-o', str(emulator)] +
                       sources + ['-lpthread', '-lm'], cwd=AAP / 'emu', check=True)
        (work / 'init.ini').write_text('mkdev apr apr166\nmkdev ptr ptr760\n'
                                       'mkdev fmem fmem162 0\nmkdev mem0 moby mem_0\n'
                                       'connectmem fmem 0 apr -1\nconnectmem mem0 0 apr 0\n')
        count = 0
        for family in ('direct', 'indexed', 'indirect', 'nested', 'arithmetic'):
            for number in (1, 3, 7, 10):
                words, opcodes, expected = guest_module.guest(family, number)
                off_result, off_trace = run(emulator, work, words, 0o1020, False)
                assert not off_trace.startswith('AAP_TIMING_V1'), (family, number, off_trace)
                assert off_result == '%012o' % expected, (family, number, 'untraced')
                costs = []
                for attempt in (1, 2):
                    result, trace = run(emulator, work, words, 0o1020, True)
                    assert result == off_result, (family, number, attempt)
                    trace_file = work / 'instrumentation-v1.trace'
                    trace_file.write_text(trace)
                    intervals = parser.intervals(trace_file)
                    assert len(intervals) == len(opcodes) - 1
                    assert [x['opcode_octal'] for x in intervals] == opcodes[:-1]
                    costs.append([x['ticks'] for x in intervals])
                assert costs[0] == costs[1], (family, number, costs)
                count += 1
                print('AAP trace repeatability %02d/20 %s-%02d: PASS' %
                      (count, family, number), flush=True)
        assert count == 20
        print('AAP instrumentation v1: PASS (20 cases, 60 executions)')


if __name__ == '__main__':
    main()
