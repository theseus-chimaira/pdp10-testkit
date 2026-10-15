#!/usr/bin/env python3
"""Summarize SIMH PDP-6 opcode dispatches without invented timings."""
import re
import sys
import argparse
import csv
import json
from pathlib import Path


def read_counts(path):
    counts = {}
    last = None
    for line in open(path, encoding='utf-8', errors='replace'):
        m = re.search(r'OPCOUNT\[(\d+)\]:\s*([0-9]+)', line)
        if m:
            last = int(m.group(2), 10)
            counts[int(m.group(1))] = last
        else:
            m = re.search(r'OPCOUNT\[(\d+)\]-OPCOUNT\[(\d+)\]: same as above', line)
            if m:
                start, stop = map(int, m.groups())
                if last is None or not (0 <= start <= stop < 512):
                    raise ValueError('invalid compressed opcode range')
                for op in range(start, stop + 1):
                    counts[op] = last
    if len(counts) != 512 or set(counts) != set(range(512)):
        raise ValueError('incomplete opcode histogram (expected 512 counters)')
    return counts


def weights_from_tsv(path):
    weights = {}
    with open(path, encoding='utf-8', newline='') as stream:
        for row in csv.DictReader(stream, delimiter='\t'):
            op = int(row['opcode_octal'], 8)
            cost = float(row['cost_units'])
            if not (0 <= op < 512 and 0 < cost < 1e9) or op in weights:
                raise ValueError('invalid or duplicate opcode weight')
            weights[op] = cost
    return weights


def main(path, output=None, weights_path=None, require_complete=False):
    counts = read_counts(path)
    total = sum(counts.values())
    weights = weights_from_tsv(weights_path) if weights_path else {}
    covered = sum(n for op, n in counts.items() if op in weights)
    unknown = total - covered
    if require_complete and unknown:
        raise ValueError('unweighted executed opcodes')
    weighted = sum(n * weights[op] for op, n in counts.items() if op in weights)
    result = {'schema': 'pdp6-opcode-profile-v1', 'instruction_count': total,
              'opcode_counts': {f'{op:03o}': counts[op] for op in range(512)},
              'weighted_dispatches': covered, 'unweighted_dispatches': unknown,
              'partial_weighted_cost': weighted if weights_path else None,
              'weight_file': str(weights_path) if weights_path else None,
              'metric': 'cost_units (not CPU time)' if weights_path else 'opcode dispatches'}
    if output:
        Path(output).write_text(json.dumps(result, indent=2, sort_keys=True) + '\n')
    print(f'Executed opcode dispatches: {total}')
    if weights_path:
        print(f'Weighted dispatches: {covered}; unweighted: {unknown}')
        print(f'Partial weighted cost: {weighted:.2f} units (not CPU time)')
    else:
        print('CPU timing: unavailable (PDP-6 opcode timing table not verified)')
    print('Top opcodes (octal / dispatches):')
    for op, count in sorted(counts.items(), key=lambda pair: -pair[1])[:15]:
        if count:
            print(f'  {op:03o}  {count}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('simh_output')
    parser.add_argument('--json', dest='output')
    parser.add_argument('--weights', help='explicit opcode timing/cost TSV')
    parser.add_argument('--require-complete-weights', action='store_true')
    opts = parser.parse_args()
    main(opts.simh_output, opts.output, opts.weights, opts.require_complete_weights)
