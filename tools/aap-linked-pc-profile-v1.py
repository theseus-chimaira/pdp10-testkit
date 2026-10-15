#!/usr/bin/env python3
"""Count AAP instruction-start PC samples in a linked PDP-10 symbol map.

Requires a complete event trace and the exact build's symbol map. The
report is CANDIDATE evidence only: data symbols and intervening gaps can
also be near a function, and linked image provenance is not proven here.
"""
import argparse
from bisect import bisect_right
from collections import Counter
from pathlib import Path
import re

SYMBOL = re.compile(r'^([a-zA-Z_.$%][\w.$%]*)\s+([0-7]{6})\s*$')
START = re.compile(r'^AAP_TIMING_V1 IT0 tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})$')


def read_map(path):
    symbols = []
    for line in Path(path).read_text().splitlines():
        match = SYMBOL.fullmatch(line)
        if match:
            symbols.append((int(match.group(2), 8), match.group(1)))
    if not symbols:
        raise ValueError('no symbols in linked map')
    return sorted(symbols)


def count(trace, symbols):
    addresses = [address for address, _ in symbols]
    counts = Counter()
    total = 0
    for line in Path(trace).read_text().splitlines():
        if not line.startswith('AAP_TIMING_V1 IT0 '):
            continue
        match = START.fullmatch(line)
        if not match:
            raise ValueError('malformed instruction-start record')
        pc = int(match.group(2), 8)
        idx = bisect_right(addresses, pc) - 1
        total += 1
        counts[symbols[idx][1] if idx >= 0 else '<before-linked-map>'] += 1
    if not total:
        raise ValueError('no AAP instruction-start records')
    return total, counts


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('linked_map')
    parser.add_argument('aap_trace')
    args = parser.parse_args()
    total, counts = count(args.aap_trace, read_map(args.linked_map))
    print('AAP linked-map candidate PC samples:', total)
    for name, n in counts.most_common(20):
        print('%-35s %d' % (name, n))
    print('NOT linked-kernel proof: module bounds, image identity, and MRES execution require independent verification')


if __name__ == '__main__':
    main()
