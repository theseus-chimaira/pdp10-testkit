#!/usr/bin/env python3
"""Report explicit broad AAP timing-coverage acceptance status.

Never equate the number of fixtures or static opcode source percentages with
verified functional/timing coverage. The --require-broad gate fails closed.
"""
import argparse
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MATRIX = ROOT / 'docs/PDP6-AAP-BROAD-COVERAGE-GATE-20261015-v1.tsv'


def rows():
    with MATRIX.open(newline='') as stream:
        entries = list(csv.DictReader(stream, delimiter='\t'))
    assert entries and all(set(x) == {'id', 'status', 'mandatory', 'evidence', 'note'}
                           for x in entries)
    assert len({x['id'] for x in entries}) == len(entries)
    for item in entries:
        assert item['status'] in ('verified', 'incomplete', 'excluded')
        assert item['mandatory'] in ('yes', 'no')
        assert item['note']
        if item['status'] == 'verified':
            assert item['evidence'] != '-'
            assert (ROOT / item['evidence']).is_file(), item
        if item['status'] == 'excluded':
            assert item['evidence'] != '-' and (ROOT / item['evidence']).is_file()
    return entries


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--require-broad', action='store_true')
    args = parser.parse_args()
    entries = rows()
    unresolved = [x for x in entries if x['mandatory'] == 'yes' and x['status'] == 'incomplete']
    print('AAP broad functional/timing coverage: %d/%d mandatory criteria resolved' %
          (sum(x['mandatory'] == 'yes' and x['status'] != 'incomplete' for x in entries),
           sum(x['mandatory'] == 'yes' for x in entries)))
    for item in unresolved:
        print('INCOMPLETE %-32s %s' % (item['id'], item['note']))
    if args.require_broad and unresolved:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
