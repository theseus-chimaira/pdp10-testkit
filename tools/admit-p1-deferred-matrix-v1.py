#!/usr/bin/env python3
"""Register original unresolved P1 C sources in the normal semantic matrix.

Only observed PDP-6 native KCC noopt and GCC O0 profiles are activated.
Other architectures and optimization levels need separate target validation.
KL10 assembler fixtures require an ISA runner, not a C compiler cell.
"""
import csv
from pathlib import Path

from p1_source_replacement_v1 import (
    HISTORICAL_PATH, current_path_for, source_matches_historical,
)

ROOT = Path(__file__).resolve().parents[1]
RESOLUTION = ROOT / 'docs/PDP10-P1-SEMANTIC-RESOLUTION-20261120-v9.tsv'
MATRIX = ROOT / 'COMPILER_MATRIX.tsv'


def read_tsv(path):
    with path.open(newline='', encoding='utf-8') as stream:
        return list(csv.DictReader((line for line in stream if not line.startswith('#')), delimiter='\t'))


def main():
    unresolved = [row for row in read_tsv(RESOLUTION)
                  if row['p1_state'] in ('blocked', 'partial')]
    if len(unresolved) != 29:
        raise ValueError('P1 unresolved source count changed')
    original = MATRIX.read_text(encoding='utf-8')
    comments = [line for line in original.splitlines() if line.startswith('#')]
    matrix = read_tsv(MATRIX)
    columns = list(matrix[0])
    indexed = {row['test']: row for row in matrix}
    if len(indexed) != len(matrix):
        raise ValueError('duplicate matrix sources')
    assembly = []
    for item in unresolved:
        historical = item['original_source']
        if not source_matches_historical(historical, item['original_sha256']):
            raise ValueError('invalid historical provenance: ' + historical)
        source = current_path_for(historical)
        if not (ROOT / source).is_file():
            raise ValueError('missing original: ' + source)
        if source.endswith('.s'):
            assembly.append(source)
            continue
        if not source.endswith('.c'):
            raise ValueError('unknown original: ' + source)
        row = indexed.get(source)
        if row is None:
            row = {column: 'no_test' for column in columns}
            row.update(test=source, group='semantic-upstream-deferred',
                       name=Path(source).stem)
            matrix.append(row)
            indexed[source] = row
        elif row['group'] != ('semantic-regression'
                             if historical == HISTORICAL_PATH
                             else 'semantic-upstream-deferred'):
            raise ValueError('existing non-deferred matrix row: ' + source)
        if historical == HISTORICAL_PATH:
            # This is now a six-profile native regression with genuine
            # observed failures. Never reset its cells to a false PASS.
            if (row['pdp6'] not in ('semantic', 'fail', 'pending') or
                    row['pdp6_gcc_o0'] not in
                    ('semantic', 'fail', 'pending')):
                raise ValueError('native byte-pointer test no longer scheduled')
        else:
            row['pdp6'] = 'semantic'
            row['pdp6_gcc_o0'] = 'semantic'
    if len(assembly) != 1 or not assembly[0].endswith('920428-1.s'):
        raise ValueError('unexpected ISA fixtures: ' + repr(assembly))
    with MATRIX.open('w', encoding='utf-8', newline='') as stream:
        stream.write('\n'.join(comments) + '\n')
        writer = csv.DictWriter(stream, fieldnames=columns, delimiter='\t',
                                lineterminator='\n')
        writer.writeheader()
        writer.writerows(matrix)
    print('Activated 28 original C sources in two PDP-6 compiler profiles')
    print('KL10 ISA fixture remains separate: ' + assembly[0])


if __name__ == '__main__':
    main()
