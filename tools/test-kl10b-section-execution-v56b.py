#!/usr/bin/env python3
"""Independent KL10B ISA execution test, before extended object support.

Construct the architectural instruction words and direct page-table
entries independently of DAS, GCC and KCC. No host register override
of paging or PC section is used: the guest enables paging and enters
section 1 via CONO PAG and XJRSTF. Physical mappings are disjoint.
"""

import os
from pathlib import Path
import re
import subprocess
import tempfile


def ins(op, ac=0, y=0, indirect=0, index=0):
    assert 0 <= y < (1 << 18)
    return op << 27 | ac << 23 | indirect << 22 | index << 18 | y


def direct(page):
    # Type 1 direct page pointer, private, writable, resident.
    return (1 << 33) | (0o20000 << 18) | page


def build(path, wrong_section=False):
    lines = ['set cpu kl10b', 'set cpu 256K', 'set cpu noidle',
             'set cpu history=100']

    def dep(addr, word):
        lines.append(f'deposit {addr:o} {word:012o}')

    # Executive page table at physical page 2; one page table per
    # virtual section, same virtual offsets but different frames.
    for section, table in enumerate([3, 4, 5, 6]):
        dep(0o2000 + 0o540 + section, direct(table))
    dep(0o3000, direct(0))
    dep(0o4001, direct(0o10))
    dep(0o5001, direct(0o11))
    dep(0o6001, direct(0o12))

    # Section-0 bootstrap: CONO PAG,60002; XJRSTF 120.
    dep(0o100, 0o701200060002)
    dep(0o101, ins(0o254, 5, 0o120))
    dep(0o120, 0)
    dep(0o121, 0o1001000)

    # Section 1 starts at virtual 1,,1000 (physical 10000).
    # CAIE skips failure JRST only on the expected value.
    code = [
        ins(0o200, 1, 0o1040, 1),  # MOVE 1,@1040 (section 2)
        ins(0o302, 1, 0o123),
        ins(0o254, 0, 0o1037),
        ins(0o135, 2, 0o1041),     # LDB 2,1041 (first byte)
        ins(0o302, 2, 0o123),
        ins(0o254, 0, 0o1037),
        ins(0o201, 3, 0o456),
        ins(0o137, 3, 0o1042),     # DPB 3,1042 (second byte)
        ins(0o135, 4, 0o1042),
        ins(0o302, 4, 0o456),
        ins(0o254, 0, 0o1037),
        ins(0o200, 0o17, 0o1043),  # Global stack in section 3
        ins(0o260, 0o17, 0o1044, 1),  # PUSHJ to section 2
        ins(0o302, 5, 0o777),
        ins(0o254, 0, 0o1037),
        ins(0o201, 6, 0o765),      # Explicit success sentinel
        ins(0o254, 4, 0),          # HALT
    ]
    for offset, word in enumerate(code):
        dep(0o10000 + offset, word)
    dep(0o10037, ins(0o254, 4, 0))  # Failure HALT, no sentinel
    dep(0o10040, 0o1001000 if wrong_section else 0o2001000)
    dep(0o10041, (0o70 << 30) | 0o2001001)
    dep(0o10042, (0o71 << 30) | 0o2001001)
    dep(0o10043, 0o3001000)
    dep(0o10044, 0o2001010)
    # Section 2: word, packed bytes, and callee.
    dep(0o11000, 0o123)
    dep(0o11001, 0o123 << 27)
    dep(0o11010, ins(0o201, 5, 0o777))
    dep(0o11011, ins(0o263, 0o17, 0))  # POPJ 17,
    # Poison the stack slot before execution; do not accept an untouched
    # initialized return address or sentinel.
    dep(0o12001, 0o123456)
    dep(6, 0)
    lines.extend(['deposit pc 100', 'step 100', 'examine pc_sect',
                  'examine t20_page', 'examine 1-6', 'examine 17',
                  'examine 11001', 'examine 12001',
                  'show cpu history=40', 'quit'])
    path.write_text('\n'.join(lines) + '\n', encoding='ascii')


def execute(sim, root, wrong_section):
    name = 'negative' if wrong_section else 'positive'
    ini = root / (name + '.ini')
    build(ini, wrong_section)
    proc = subprocess.run([str(sim), str(ini)], cwd=root,
                          stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                          text=True, timeout=30, check=True)
    log = proc.stdout
    (root / (name + '.log')).write_text(log, encoding='utf-8')

    def require(ok, label):
        if not ok:
            raise AssertionError(f'{name}: {label}; see {root}')

    def value(label, expected):
        match = re.search(r'^' + label + r':\s*([0-7]+)\s*$', log, re.M)
        require(match is not None and int(match[1], 8) == expected, label)

    require('HALT instruction' in log, 'no HALT')
    require('Step expired' not in log and 'Time expired' not in log,
            'budget exhausted')
    value('PC_SECT', 1)
    value('T20_PAGE', 1)
    if wrong_section:
        value('1', ins(0o200, 1, 0o1040, 1))
        value('6', 0)
        value('11001', 0o123 << 27)
        value('12001', 0o123456)
        require(re.search(r'^01001037\s+.*HALT', log, re.M), 'failure HALT')
    else:
        for reg, expected in enumerate([0o123, 0o123, 0o456, 0o456,
                                        0o777, 0o765], 1):
            value(str(reg), expected)
        value('17', 0o3001000)
        value('11001', 0o123456000000)
        value('12001', 0o1001015)
        require(re.search(r'^02001010\s+.*MOVEI', log, re.M), 'callee')
        require(re.search(r'^02001011\s+.*POPJ', log, re.M), 'return')
        require(re.search(r'^01001020\s+.*HALT', log, re.M), 'success HALT')
    print(f'PASS KL10B {name}: {root / (name + ".log")}', flush=True)


def main():
    tmp = Path(os.environ.get('TMPDIR') or Path.home() / 'tmp')
    tmp.mkdir(parents=True, exist_ok=True)
    root = Path(tempfile.mkdtemp(prefix='pdp10-kl10b-section-v56b-', dir=tmp))
    sim = os.environ.get('SIMH_KL')
    if not sim:
        sim = str(Path(os.environ['PDP10_PREFIX']) / 'bin/pdp10-kl')
    execute(sim, root, False)
    execute(sim, root, True)


if __name__ == '__main__':
    main()
