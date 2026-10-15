#!/usr/bin/env python3
"""Ten fail-closed tests for ambiguous AAP timing traces.

Synthetic malformed traces are parser tests, not evidence of actual
PDP-6 interrupt, memory-fault or peripheral timing behavior.
"""
import importlib.util
from pathlib import Path
import sys
import tempfile


def event(phase, tick, pc='001000', opcode='201'):
    return 'AAP_TIMING_V1 %s tick=%d pc=%s inst=%s\n' % (
        phase, tick, pc, opcode)


def main(reporter):
    spec = importlib.util.spec_from_file_location('aap_cost', reporter)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    start = event('IT0', 100, opcode='000')
    execute = event('ET0A', 200)
    next_start = event('IT0', 400, pc='001001')
    next_execute = event('ET0A', 500, pc='001001', opcode='254')
    cases = (
        ('missing-events', ''),
        ('orphan-execute', execute),
        ('unpaired-start', start),
        ('double-start', start + next_start + next_execute),
        ('different-execute-pc', start + event('ET0A', 200, '001002')),
        ('duplicate-tick', start + event('ET0A', 100)),
        ('reversed-tick', start + event('ET0A', 99)),
        ('extra-execute', start + execute + event('ET0A', 300)),
        ('unfinished-nested-xct', start + event('ET0A', 200, opcode='256') +
         event('ET0A', 300, opcode='256')),
        ('malformed-record', start + execute +
         'AAP_TIMING_V1 INTERRUPT tick=300 pc=001001 inst=000\n' +
         next_start + next_execute),
    )
    assert len(cases) == 10
    with tempfile.TemporaryDirectory() as directory:
        path = Path(directory) / 'trace.txt'
        for name, contents in cases:
            path.write_text(contents)
            try:
                module.intervals(path)
            except ValueError:
                print('AAP exceptional trace %s: REJECTED (PASS)' % name)
            else:
                raise AssertionError('%s was incorrectly accepted' % name)
    print('AAP exceptional trace batch v1: PASS (10/10)')


if __name__ == '__main__':
    reporter = (Path(sys.argv[1]) if len(sys.argv) > 1 else
                Path(__file__).resolve().parents[2] / 'tools/aap-tick-cost-v1.py')
    main(reporter.resolve())
