#!/usr/bin/env python3
import csv
import sys

path = 'TYPE_SEMANTICS.tsv'
rows = []
with open(path, 'r', encoding='ascii') as f:
    for line in f:
        if not line.startswith('#') and line.strip():
            rows.append(line)
reader = csv.DictReader(rows, delimiter='\t', fieldnames=[
    'type_id', 'compiler', 'spelling', 'value_bits', 'storage_words',
    'representation', 'comparability'])
data = list(reader)
required = {'pdp10-int71-v1', 'pdp10-uint71-v1', 'pdp10-raw72-v1'}
found = {row['type_id'] for row in data}
missing = sorted(required - found)
if missing:
    print('missing semantic type ids: ' + ', '.join(missing), file=sys.stderr)
    sys.exit(1)
for row in data:
    if row['type_id'] != row['comparability']:
        print('incomparable row mislabeled: ' + row['spelling'], file=sys.stderr)
        sys.exit(1)
print('wide integer semantic type ids: PASS')
