#!/usr/bin/env python3
"""Summarize SIMH PDP-6 OPCOUNT registers and DEC brochure timing bands.

Instruction-class timings are indicative, not cycle-exact: effective-address
calculation, memory placement and operand values are not in this histogram.
"""
import re
import sys


def read_counts(path):
    counts = {}
    for line in open(path, encoding='utf-8', errors='replace'):
        m = re.search(r'OPCOUNT\[(\d+)\]:\s*([0-9]+)', line)
        if m:
            counts[int(m.group(1))] = int(m.group(2), 10)
    return counts


def timing(op):
    # Opcode numbers below are octal as in the DEC PDP-6 instruction list.
    if 0o200 <= op <= 0o217:
        return ('move', 1.9, 4.0)
    if 0o220 <= op <= 0o227:
        return ('fixed multiply', 14.5, 16.1)
    if 0o230 <= op <= 0o237:
        return ('fixed divide', 23.4, 25.0)
    if 0o270 <= op <= 0o273:
        return ('fixed add', 2.7, 4.3)
    if 0o274 <= op <= 0o277:
        return ('fixed subtract', 2.9, 4.5)
    if 0o400 <= op <= 0o477:
        return ('boolean', 2.7, 4.3)
    if 0o500 <= op <= 0o577:
        return ('half-word moves', 1.9, 4.0)
    if 0o300 <= op <= 0o317:
        return ('compare', 2.7, 4.4)
    if 0o320 <= op <= 0o377:
        return ('jump/modify', 1.8, 4.4)
    if op in (0o260, 0o261, 0o262, 0o263):
        return ('pushdown', 3.1, 6.4)
    if op == 0o250:
        return ('exchange', 2.8, 4.0)
    if op == 0o254:
        return ('jump', 1.8, 3.0)
    if op in (0o640, 0o641, 0o642, 0o643):
        return ('memory test', 2.6, 3.9)
    if 0o700 <= op <= 0o777:
        return ('I/O', 3.0, 7.0)
    return None


def main(path):
    counts = read_counts(path)
    if not counts or max(counts) >= 512:
        raise ValueError('missing or malformed OPCOUNT histogram')
    total = sum(counts.values())
    covered = 0
    low = high = 0.0
    missing = []
    for opcode, count in sorted(counts.items()):
        if not count:
            continue
        group = timing(opcode)
        if group is None:
            missing.append((opcode, count))
        else:
            covered += count
            low += count * group[1]
            high += count * group[2]
    print(f'Executed opcode dispatches: {total}')
    print(f'Timed class coverage: {covered} ({covered * 100 / total:.2f}%)' if total else 'Timed class coverage: 0')
    print(f'Partial fast/slow class sums: {low / 1e6:.4f}/{high / 1e6:.4f} seconds (NOT total CPU time)')
    print('Unclassified dispatches:', sum(count for _, count in missing))
    print('Top opcodes (octal / dispatches):')
    for op, count in sorted(counts.items(), key=lambda pair: -pair[1])[:15]:
        if count:
            print(f'  {op:03o}  {count}')
    if missing:
        print('Unclassified opcodes:', ', '.join(f'{op:03o}' for op, _ in missing))


if __name__ == '__main__':
    if len(sys.argv) != 2:
        raise SystemExit('usage: report-pdp6-opcodes-v1.py SIMH_OUTPUT')
    main(sys.argv[1])
