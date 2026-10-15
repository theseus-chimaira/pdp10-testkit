#!/usr/bin/env python3
"""Summarize SIMH PDP-6 opcode dispatches without invented timings."""
import re
import sys


def read_counts(path):
    counts = {}
    for line in open(path, encoding='utf-8', errors='replace'):
        m = re.search(r'OPCOUNT\[(\d+)\]:\s*([0-9]+)', line)
        if m:
            counts[int(m.group(1))] = int(m.group(2), 10)
    return counts


def main(path):
    counts = read_counts(path)
    if not counts or max(counts) >= 512:
        raise ValueError('missing or malformed OPCOUNT histogram')
    total = sum(counts.values())
    print(f'Executed opcode dispatches: {total}')
    print('CPU timing: unavailable (PDP-6 opcode timing table not verified)')
    print('Top opcodes (octal / dispatches):')
    for op, count in sorted(counts.items(), key=lambda pair: -pair[1])[:15]:
        if count:
            print(f'  {op:03o}  {count}')


if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('usage: report-pdp6-opcodes-v1.py SIMH_OUTPUT')
    main(sys.argv[1])
