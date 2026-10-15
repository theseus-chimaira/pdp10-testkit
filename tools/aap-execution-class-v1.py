#!/usr/bin/env python3
"""Fail-closed classification of AAP timing suitability from APR latches.

This only checks the final processor-state snapshot. An interrupt or
fault that was serviced and cleared before the snapshot is NOT proven
absent. Such workloads need event-level instrumentation to qualify.
"""
import argparse
import re
from pathlib import Path

RECORD = re.compile(r'^APR_CLASS_V1 NXM=([01]) ILLOP=([01]) PDLOV=([01]) '
                    r'PI_ACTIVE=([01]) PI_REQ=([0-7]{3}) PI_CYC=([01])$')


def classify(output):
    matches = [RECORD.fullmatch(line) for line in output.splitlines()
               if line.startswith('APR_CLASS_V1 ')]
    if len(matches) != 1 or matches[0] is None:
        raise ValueError('missing, duplicated or malformed APR classification')
    nxm, illegal, pdl, active, request, cycle = matches[0].groups()
    if nxm == '1' or illegal == '1' or pdl == '1':
        raise ValueError('exceptional memory/instruction/pushdown state')
    if active == '1' or int(request, 8) or cycle == '1':
        raise ValueError('PI request/cycle in final APR state')
    return 'final-snapshot-clear'


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('console_log')
    args = parser.parse_args()
    print(classify(Path(args.console_log).read_text()))


if __name__ == '__main__':
    main()
