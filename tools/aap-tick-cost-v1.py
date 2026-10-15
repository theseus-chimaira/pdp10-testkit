#!/usr/bin/env python3
"""Extract complete IT0-to-next-IT0 logical intervals from an AAP trace.

These are modeled pulse-delay units, not seconds. Final instruction has no
next-start marker and therefore has no complete interval in this format.
"""
import argparse
import json
import re
from pathlib import Path

EVENT = re.compile(r'^AAP_TIMING_V1 (IT0|ET0A) tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})$')


def intervals(path):
    events = []
    for line in Path(path).read_text().splitlines():
        if not line.startswith('AAP_TIMING_V1 '):
            continue
        match = EVENT.fullmatch(line)
        if not match:
            raise ValueError('invalid milestone')
        name, tick, pc, opcode = match.groups()
        events.append((name, int(tick), pc, opcode))
    if not events:
        raise ValueError('missing timing events')
    if any(a[1] > b[1] for a, b in zip(events, events[1:])):
        raise ValueError('nonmonotonic logical time')
    starts = []
    for idx, event in enumerate(events):
        if event[0] != 'IT0':
            continue
        if idx + 1 >= len(events) or events[idx + 1][0] != 'ET0A':
            raise ValueError('unpaired instruction-start milestone')
        execute = events[idx + 1]
        if event[2] != execute[2]:
            raise ValueError('PC mismatch between IT0 and ET0A')
        starts.append((event[1], event[2], execute[3]))
    if not starts:
        raise ValueError('missing IT0')
    if events[-1][0] != 'ET0A' or len(events) != 2 * len(starts):
        raise ValueError('unsupported interleaved milestone sequence')
    return [{'pc': a[1], 'opcode_octal': a[2],
             'ticks': b[0] - a[0]} for a, b in zip(starts, starts[1:])]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('trace')
    parser.add_argument('--json', dest='output')
    parser.add_argument('--workload-id', help='ID for an independently verified equivalent workload')
    parser.add_argument('--model-id', help='AAP source revision and memory configuration identifier')
    args = parser.parse_args()
    measurements = intervals(args.trace)
    output = {'schema': 'pdp6-aap-tick-cost-v1',
              'unit': 'AAP logical pulse-delay ticks',
              'method': 'consecutive IT0 interval',
              'complete_intervals': len(measurements),
              'total_complete_ticks': sum(item['ticks'] for item in measurements),
              'workload_id': args.workload_id,
              'model_id': args.model_id,
              'intervals': measurements,
              'terminal_instruction_unmeasured': True}
    if args.output:
        Path(args.output).write_text(json.dumps(output, indent=2) + '\n')
    print('Complete instruction-start intervals:', len(measurements))
    for item in measurements:
        print('%s opcode=%s ticks=%d' %
              (item['pc'], item['opcode_octal'], item['ticks']))
    print('Final instruction excluded: no next IT0 boundary')


if __name__ == '__main__':
    main()
