#!/usr/bin/env python3
"""Pin the 59 original actionable P1 source obligations in six batches.

The 2026-11-19 v1 resolution is the immutable scheduling baseline.
Each source keeps its original source hash and belongs to exactly one
batch. Subsequent closures update the live v2 resolution only; they
must never silently renumber or delete historical work assignments.
"""

import argparse
import collections
import csv
from pathlib import Path
import hashlib
import sys

from p1_source_replacement_v1 import source_matches_historical

ROOT = Path(__file__).resolve().parents[1]
BASELINE = ROOT / 'docs/PDP10-P1-SEMANTIC-RESOLUTION-20261119-v1.tsv'
LIVE = ROOT / 'docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v8.tsv'
OUT = ROOT / 'docs/PDP10-P1-SOURCE-BATCHES-20261120-v7.tsv'
FIELDS = ('batch', 'slot', 'original_source', 'source_sha256',
          'baseline_state', 'baseline_disposition', 'live_state',
          'remaining_action')
NAMES = (
    'Compiler matrix admission A',
    'Compiler policy and diagnostic admission',
    'Width and partial original-oracle work',
    'ABI, assembler and first hosted prerequisites',
    'Hosted runtime and library dependencies A',
    'Hosted runtime and library dependencies B',
)


def load(path):
    with path.open(encoding='utf-8', newline='') as stream:
        return list(csv.DictReader(stream, delimiter='\t'))


def expected():
    baseline = load(BASELINE)
    live = {row['original_source']: row for row in load(LIVE)}
    if len(baseline) != 67 or len(live) != 67:
        raise ValueError('resolution manifest does not contain 67 originals')
    groups = collections.defaultdict(list)
    all_open = []
    for row in baseline:
        source = row['original_source']
        if (source not in live or
                live[source]['original_sha256'] != row['original_sha256'] or
                not source_matches_historical(source, row['original_sha256'])):
            raise ValueError('modified original source/identity: '+source)
        if row['p1_state'] != 'covered':
            all_open.append(source)
            groups[row['historical_disposition']].append(source)
    if len(all_open) != 59:
        raise ValueError('immutable baseline must contain 59 open sources')
    counts = {'compiler-investigate': 13, 'feature-policy-decision': 3,
              'compiler-ice-priority': 1, 'linker-investigate': 1,
              'header-integration': 1, 'width-or-source-adaptation': 5,
              'nonasserting': 6, 'libc-linkage': 3, 'varargs-abi': 3,
              'isa-harness': 1, 'hosted-runtime': 22}
    if {key:len(value) for key,value in groups.items()} != counts:
        raise ValueError('historical source class counts no longer match')
    hosted = list(groups['hosted-runtime'])
    arith = 'tests/todo/generic/arith-ll.c'
    if hosted.count(arith) != 1:
        raise ValueError('arithmetic diagnostic source missing from host group')
    hosted.remove(arith)
    compiler = groups['compiler-investigate']
    partial = groups['nonasserting']
    batches = [
        [arith] + compiler[:9],
        compiler[9:] + groups['feature-policy-decision'] +
            groups['compiler-ice-priority'] + groups['linker-investigate'] +
            groups['header-integration'],
        groups['width-or-source-adaptation'] + partial[:5],
        partial[5:] + groups['libc-linkage'] + groups['varargs-abi'] +
            groups['isa-harness'] + hosted[:2],
        hosted[2:12],
        hosted[12:],
    ]
    if [len(batch) for batch in batches] != [10,10,10,10,10,9]:
        raise ValueError('expected five batches of 10 and one batch of 9')
    if collections.Counter(source for batch in batches for source in batch) != \
            collections.Counter(all_open):
        raise ValueError('duplicate/missing original P1 assignment')
    by_source = {row['original_source']:row for row in baseline}
    result=[]
    for n,batch in enumerate(batches,1):
        for position,source in enumerate(batch,1):
            initial=by_source[source]
            current=live[source]
            result.append(dict(batch=str(n),slot=str(position),
                               original_source=source,
                               source_sha256=initial['original_sha256'],
                               baseline_state=initial['p1_state'],
                               baseline_disposition=initial['historical_disposition'],
                               live_state=current['p1_state'],
                               remaining_action=current['p1_remaining_action']))
    return result


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write',action='store_true')
    args=parser.parse_args()
    rows=expected()
    if args.write:
        with OUT.open('w',encoding='utf-8',newline='') as stream:
            writer=csv.DictWriter(stream,fieldnames=FIELDS,
                                  delimiter='\t',lineterminator='\n')
            writer.writeheader()
            writer.writerows(rows)
    else:
        actual=load(OUT)
        if actual != rows or len(actual)!=59 or (
                actual and tuple(actual[0])!=FIELDS):
            print('ERROR: batch ledger does not match original P1 assignments '
                  'or latest progress',file=sys.stderr)
            return 1
    states=collections.Counter(r['live_state'] for r in rows)
    print('P1 source batches: PASS (10+10+10+10+10+9=59, '+
          ', '.join('%s=%d'%(k,states[k]) for k in
                    ('covered','partial','blocked'))+')')
    for i,name in enumerate(NAMES,1):
        data=[row for row in rows if row['batch']==str(i)]
        done=sum(row['live_state']=='covered' for row in data)
        print('  batch %d: %d sources, %d complete: %s'%
              (i,len(data),done,name))
    return 0


if __name__ == '__main__':
    sys.exit(main())
