#!/usr/bin/env python3
"""Independent global pointer and XBLT execution oracles on KL10B.

Use the architectural P+S selector ranges, not DAS output or compiler
helper tables. Direct page mappings deliberately give equal offsets in
other sections different physical frames. The v56b test separately
checks guest paging startup and its negative control.
"""

import os
from pathlib import Path
import re
import subprocess
import tempfile

MASK36 = (1 << 36) - 1
# Size, before-first selector, number of byte slots in one 36-bit word.
FORMATS = ((6, 0o45, 6), (8, 0o54, 4), (7, 0o61, 5),
           (9, 0o67, 4), (18, 0o74, 2))


def ins(op, ac=0, y=0, indirect=0):
    assert 0 <= y < (1 << 18)
    return (op << 27) | (ac << 23) | (indirect << 22) | y


def gbp(selector, section, offset):
    return (selector << 30) | (section << 18) | offset


def build(path):
    lines = ['set cpu kl10b', 'set cpu 256K', 'set cpu noidle',
             'set cpu history=40']
    code, literals, data, expected, checks = [], {}, {}, {}, []
    failure = 0o3777

    def dep(addr, value):
        lines.append(f'deposit {addr:o} {value & MASK36:012o}')

    def direct(page):
        return (1 << 33) | (0o20000 << 18) | page

    for section, table in enumerate((3, 4, 5, 6)):
        dep(0o2540 + section, direct(table))
    dep(0o3000, direct(0))
    # Code and literals in section 1, five distinct physical pages.
    for page in range(1, 6):
        dep(0o4000 + page, direct(0o10 + page))
    dep(0o5001, direct(0o20))  # section 2, ordinary data
    dep(0o5777, direct(0o21))  # section 2, last virtual page
    dep(0o6000, direct(0o22))  # section 3, first virtual page
    dep(0o6001, direct(0o23))  # section 3, XBLT destination
    dep(0o100, 0o701200060002)  # CONO PAG,60002
    dep(0o101, ins(0o254, 5, 0o120))
    dep(0o120, 0)
    dep(0o121, 0o1001000)

    def emit(op, ac=0, y=0, indirect=0):
        code.append(ins(op, ac, y, indirect))

    def lit(value):
        # Unique slots, including mutable IBP operands.
        addr = 0o4000 + len(literals)
        literals[addr] = value
        return addr

    def check(ac, value, name):
        checks.append(name)
        emit(0o201, 0o10, len(checks))  # Diagnostic assertion number.
        emit(0o312, ac, lit(value))     # CAME
        emit(0o254, 0, failure)

    def adjust(pointer, amount, result, name):
        emit(0o200, 1, lit(amount & MASK36))
        emit(0o133, 1, lit(pointer))   # ADJBP
        check(1, result, name)

    def increment(pointer, result, name):
        cell = lit(pointer)
        emit(0o133, 0, cell)          # IBP
        emit(0o200, 1, cell)
        check(1, result, name)

    def physical(section, offset):
        if section == 2 and offset == 0o777777:
            return (0o21 << 9) + 0o777
        if section == 3 and offset == 0:
            return 0o22 << 9
        assert 0o1000 <= offset < 0o2000
        return ((0o20 if section == 2 else 0o23) << 9) + offset - 0o1000

    # Test all 26 selectors, including the five before-first forms.
    # Check every data slot with LDB/DPB; preserve unused trailing bits.
    for size, before, slots in FORMATS:
        offset = 0o1020 + size * 2
        a, b = physical(2, offset), physical(2, offset + 1)
        tail = 36 - size * slots
        word = (1 << tail) - 1
        changed = word
        for slot in range(slots):
            shift = 36 - size * (slot + 1)
            word |= (slot + 1) << shift
            changed |= (slot + 17) << shift
        data[a], data[b] = word, 0
        expected[a], expected[b] = changed, 0
        first = gbp(before + 1, 2, offset)
        last = gbp(before + slots, 2, offset)
        next_first = gbp(before + 1, 2, offset + 1)
        previous = gbp(before, 2, offset)
        increment(previous, first, f'{size}: IBP before first')
        adjust(previous, 1, first, f'{size}: ADJBP before first')
        for slot in range(slots):
            selector = before + slot + 1
            pointer = gbp(selector, 2, offset)
            cell = lit(pointer)
            emit(0o135, 1, cell)      # LDB
            check(1, slot + 1, f'{size}: LDB selector {selector:o}')
            emit(0o201, 1, slot + 17)
            emit(0o137, 1, cell)      # DPB
            emit(0o135, 1, cell)
            check(1, slot + 17, f'{size}: DPB selector {selector:o}')
        increment(last, next_first, f'{size}: IBP next word')
        adjust(last, 1, next_first, f'{size}: ADJBP next word')
        adjust(next_first, -1, last, f'{size}: ADJBP previous word')
        # Cross the 18-bit local offset boundary, without wrapping to
        # section 2 or dropping the selector.
        boundary = gbp(before + slots, 2, 0o777777)
        next_section = gbp(before + 1, 3, 0)
        increment(boundary, next_section, f'{size}: IBP next section')
        adjust(boundary, 1, next_section, f'{size}: ADJBP next section')
        adjust(next_section, -1, boundary, f'{size}: ADJBP previous section')

    # Dereference both sides of the section boundary, including section
    # 3 offset zero (memory, not AC 0). Use nine-bit data for this proof.
    a, b = physical(2, 0o777777), physical(3, 0)
    data[a], data[b] = 0o123, 0o456 << 27
    expected[a], expected[b] = data[a], data[b]
    emit(0o135, 1, lit(gbp(0o73, 2, 0o777777)))
    check(1, 0o123, 'boundary LDB last byte')
    emit(0o135, 1, lit(gbp(0o70, 3, 0)))
    check(1, 0o456, 'boundary LDB first byte')

    emit(0o415, 1, 0o1000)           # XMOVEI local address
    check(1, 0o1001000, 'XMOVEI current section')
    emit(0o415, 1, lit(0o2001100), 1)
    check(1, 0o2001100, 'XMOVEI global indirect address')

    # XBLT AC4..6: signed count, source and destination addresses.
    xblt = lit(ins(0o20))
    for reverse in (False, True):
        offset = 0o1200 + (4 if reverse else 0)
        source, dest = (2 << 18) + offset, (3 << 18) + offset
        for j, value in enumerate((0o123456701234, 0o654321076543)):
            sa, da = physical(2, offset + j), physical(3, offset + j)
            data[sa], data[da] = value, MASK36
            expected[sa], expected[da] = value, value
        emit(0o200, 4, lit((-2 if reverse else 2) & MASK36))
        emit(0o200, 5, lit(source + (2 if reverse else 0)))
        emit(0o200, 6, lit(dest + (2 if reverse else 0)))
        emit(0o123, 4, xblt)
        check(4, 0, 'XBLT count exhausted')
        check(5, source + (0 if reverse else 2), 'XBLT source')
        check(6, dest + (0 if reverse else 2), 'XBLT destination')

    emit(0o201, 0o11, 0o765)
    emit(0o254, 4, 0)
    assert 0o1000 + len(code) < failure
    assert len(literals) < 0o2000

    def code_phys(offset):
        page, slot = divmod(offset, 512)
        return ((0o10 + page) << 9) + slot

    for offset, value in enumerate(code, 0o1000):
        dep(code_phys(offset), value)
    dep(code_phys(failure), ins(0o254, 4, 0))
    for addr, value in literals.items():
        dep(code_phys(addr), value)
    for addr, value in sorted(data.items()):
        dep(addr, value)
    dep(0o10, 0)
    dep(0o11, 0)
    lines.extend(['deposit pc 100', 'step 10000', 'examine pc_sect',
                  'examine t20_page', 'examine 10-11'])
    for addr in sorted(expected):
        lines.append(f'examine {addr:o}')
    lines.extend(['show cpu history=40', 'quit'])
    path.write_text('\n'.join(lines) + '\n', encoding='ascii')
    return checks, expected


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    root = Path(tempfile.mkdtemp(prefix='pdp10-kl10b-global-isa-v56c-', dir=tmp))
    ini = root / 'global-isa-v56c.ini'
    checks, expected = build(ini)
    sim = os.environ.get('SIMH_KL') or str(Path(os.environ['PDP10_PREFIX']) / 'bin/pdp10-kl')
    proc = subprocess.run([sim, str(ini)], cwd=root, stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT, text=True, timeout=30, check=True)
    log = proc.stdout
    (root / 'global-isa-v56c.log').write_text(log, encoding='utf-8')
    values = {m[1]: int(m[2], 8) for m in re.finditer(r'^([A-Z_0-7]+):\s*([0-7]+)\s*$', log, re.M)}
    last = values.get('10', 0)
    if values.get('11') != 0o765:
        name = checks[last-1] if 0 < last <= len(checks) else 'startup'
        raise AssertionError(f'last check {last}: {name}; see {root}')
    assert 'HALT instruction' in log and 'Step expired' not in log and 'Time expired' not in log, root
    assert values.get('PC_SECT') == 1 and values.get('T20_PAGE') == 1, root
    for addr, value in sorted(expected.items()):
        assert values.get(f'{addr:o}') == value, (f'{addr:o}', f'{value:o}', root)
    print(f'PASS KL10B {len(checks)} instruction assertions, {len(expected)} physical words: {root}', flush=True)


if __name__ == '__main__':
    main()
