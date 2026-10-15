#!/usr/bin/env python3
"""Fail closed on any observed AAP exceptional/PI pulse event.

A clean log only proves absence of *instrumented* events. It cannot yet
certify complete pulse/event coverage or close the broad execution gate.
"""
import argparse
import re
from pathlib import Path

IOT_START = re.compile(r'AAP_TIMING_V1 IT0 tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})')

EVENT = re.compile(r'AAP_CLASS_EVENT_V1 type=(NXM|ILLOP|PDLOV|PI_CYCLE) tick=(\d+) pc=([0-7]{6})')


def inspect(text):
    events = []
    io_instructions = []
    for line in text.splitlines():
        if line.startswith('AAP_TIMING_V1 IT0 '):
            instruction = IOT_START.fullmatch(line)
            if instruction is None:
                raise ValueError('malformed AAP instruction-start: ' + line)
            if int(instruction.group(3), 8) >= 0o700:
                io_instructions.append(instruction.group(3))
        if not line.startswith('AAP_CLASS_EVENT_V1 '):
            continue
        item = EVENT.fullmatch(line)
        if not item:
            raise ValueError('malformed classification event: ' + line)
        events.append(item.groups())
    if events:
        raise ValueError('exceptional/PI events observed: ' + ','.join(x[0] for x in events))
    if io_instructions:
        raise ValueError('device-I/O instruction starts observed: ' + ','.join(io_instructions))
    return 'no reported exceptional/PI events (not proof of coverage)'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('trace')
    args = parser.parse_args()
    print(inspect(Path(args.trace).read_text()))


if __name__ == '__main__':
    main()
