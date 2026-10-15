#!/usr/bin/env python3
"""Validate the diagnostic AAP timing milestone stream (not CPU times)."""
import re


PATTERN = re.compile(r'^AAP_TIMING_V1 (IT0|ET0A) tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})$')


def validate(lines):
    previous = -1
    events = 0
    for line in lines:
        if not line.startswith('AAP_TIMING_V1 '):
            continue
        match = PATTERN.fullmatch(line.rstrip('\n'))
        if match is None:
            raise ValueError('malformed timing milestone')
        tick = int(match.group(2))
        if tick < previous:
            raise ValueError('nonmonotonic pulse time')
        previous = tick
        events += 1
    if events == 0:
        raise ValueError('no timing milestones')
    return events


def main():
    assert validate(['ignore', 'AAP_TIMING_V1 IT0 tick=100 pc=001000 inst=254',
                     'AAP_TIMING_V1 ET0A tick=100 pc=001001 inst=254']) == 2
    for sample in (['AAP_TIMING_V1 ET0A tick=4 pc=001000 inst=254',
                    'AAP_TIMING_V1 IT0 tick=3 pc=001000 inst=254'],
                   ['AAP_TIMING_V1 IT0 tick=1 pc=bad inst=254'], []):
        try:
            validate(sample)
        except ValueError:
            continue
        raise AssertionError('invalid milestone trace accepted')
    print('AAP timing milestone parser v1: PASS')


if __name__ == '__main__':
    main()
