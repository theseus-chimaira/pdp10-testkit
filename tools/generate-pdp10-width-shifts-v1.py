#!/usr/bin/env python3
"""Generate independent 9/18/36-bit PDP-10 shift results (test-only).

The expected results are computed using Python's unbounded integers,
not by the target C compiler. This does not modify the original GCC
20020108-1.c test, whose original byte-width guards are vacuous here.
"""

import argparse
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / 'tests/semantic/regression/pdp10-width-shifts-v1.c'


def generate():
    lines = [
        '/* PDP-10 9/18/36-bit left/right shift oracle, version 1.',
        ' * Derived from the intent of GCC 20020108-1.c. The original',
        ' * 8/16/32-bit guards do not execute on a 9-bit-char PDP-10.',
        ' * Every expected word below comes from a host integer model.',
        ' * The original source is preserved unchanged and deferred.',
        ' */',
        '#include <limits.h>',
        '#if CHAR_BIT != 9',
        '#error This is a PDP-10 9-bit-char target-only regression',
        '#endif',
        '',
        'extern void abort(void);',
        'volatile unsigned int pdp10_shift_case_v1;',
        'static volatile unsigned char input9_v1;',
        'static volatile unsigned short input18_v1;',
        'static volatile unsigned int input36_v1;',
        'static volatile unsigned int shift_v1;',
        '',
    ]
    for width, type_name in ((9, 'unsigned char'),
                             (18, 'unsigned short'),
                             (36, 'unsigned int')):
        mask = (1 << width) - 1
        for kind in ('left', 'right'):
            vals = [(mask << n) & mask if kind == 'left' else mask >> n
                    for n in range(width)]
            lines.append('static const unsigned int expected_%s_%d_v1[%d] = {'
                         % (kind, width, width))
            for start in range(0, width, 6):
                lines.append('    ' + ', '.join('0%oUL' % v for v in vals[start:start+6]) +
                             (',' if start+6 < width else ''))
            lines += ['};', '']
        lines += [
            'static %s' % type_name,
            'shift_left_%d_v1(%s x, unsigned int n)' % (width, type_name),
            '{',
            '    return (%s)(x << n);' % type_name,
            '}',
            '',
            'static %s' % type_name,
            'shift_right_%d_v1(%s x, unsigned int n)' % (width, type_name),
            '{',
            '    return (%s)(x >> n);' % type_name,
            '}',
            '',
        ]
    lines += ['int', 'main(void)', '{', '    unsigned int i;', '']
    for width in (9, 18, 36):
        lines += [
            '    input%d_v1 = 0%oUL;' % (width, (1 << width) - 1),
            '    for (i = 0; i < %d; ++i) {' % width,
            '        shift_v1 = i;',
            '        pdp10_shift_case_v1++;',
            '        if ((unsigned int)shift_left_%d_v1(input%d_v1, shift_v1)' % (width, width),
            '            != expected_left_%d_v1[i])' % width,
            '            abort();',
            '        if ((unsigned int)shift_right_%d_v1(input%d_v1, shift_v1)' % (width, width),
            '            != expected_right_%d_v1[i])' % width,
            '            abort();',
            '    }',
            '',
        ]
    lines += [
        '    if (pdp10_shift_case_v1 != 63)',
        '        abort();',
        '    return 0;',
        '}',
        '',
    ]
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write', action='store_true',
                        help='regenerate the versioned C fixture')
    args = parser.parse_args()
    actual = generate()
    if args.write:
        TARGET.write_text(actual, encoding='ascii')
        print('generated %s (%d bytes)' % (TARGET, len(actual)))
        return 0
    if not TARGET.is_file() or TARGET.read_text(encoding='ascii') != actual:
        print('PDP10 width-shift oracle is stale/modified', file=sys.stderr)
        return 1
    assert '0%oUL' % ((1 << 36) - 1) in actual
    assert 'pdp10_shift_case_v1 != 63' in actual
    print('PDP10 independent 9/18/36-bit shift tables: PASS (63 counts, 126 assertions)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
