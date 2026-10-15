#!/bin/sh
# PDP-6 AAP conditional branches, skips, and bounded AOBJ loops.
# Test actual guest instruction PCs and complete logical-tick intervals.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/aap-branches-v3.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
aap=${PDP6_AAP_ROOT:-"$root/../pdp6"}
(
    cd "$aap/emu"
    ${CC:-cc} -O2 -o "$work/pdp6_n" \
        main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c \
        pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c \
        ../tools/pdp6common.c -lpthread -lm
)
cat > "$work/init.ini" <<'INI'
mkdev apr apr166
mkdev ptr ptr760
mkdev fmem fmem162 0
mkdev mem0 moby mem_0
connectmem fmem 0 apr -1
connectmem mem0 0 apr 0
INI
run_guest()
{
    name=$1
    shift
    (
        cd "$work"
        (printf 'power on\n';
         for entry in "$@"; do printf 'deposit %s\n' "$entry"; done
         printf 'start 1000\n'; sleep 1; printf 'examine 1020\n'; printf 'quit\n') |
            PDP6_AAP_TIMING_TRACE_V1=1 timeout 10 "$work/pdp6_n" \
                > "$name.stdout" 2> "$name.trace"
    )
}
# MOVEI 1,0; JUMPE takes the branch; JUMPN does not.
run_guest jumpe '1000 201040000000' '1001 322040001003' \
    '1002 254200000000' '1003 201040000007' '1004 202040001020' '1005 254200000000'
run_guest jumpn '1000 201040000000' '1001 326040001003' \
    '1002 201040000007' '1003 202040001020' '1004 254200000000'
# SKIPE tests a zero memory operand; skip the intervening halt.
run_guest skipe '1000 332000001010' '1001 254200000000' \
    '1002 201040000007' '1003 202040001020' '1004 254200000000' '1010 000000000000'
# AOBJN increments both 18-bit halves. Starting LH=-2 loops once,
# then terminates at LH=0. This tests a repeated branch PC.
run_guest aobjn '1000 200040001010' '1001 253040001001' \
    '1002 202040001020' '1003 254200000000' '1010 777776000000'
# AOBJP branches after a negative LH becomes zero.
run_guest aobjp '1000 200040001010' '1001 252040001003' \
    '1002 254200000000' '1003 202040001020' '1004 254200000000' '1010 777777000000'
# Independent guest result: each program stores a computed AC value in
# location 1020. Distinguish wrong branches even if trace parsing succeeds.
run_guest skipe_false '1000 332000001010' '1001 201040000005' \
    '1002 202040001020' '1003 254200000000' '1010 000000000001'
run_guest aobjn_short '1000 200040001010' '1001 253040001001' \
    '1002 202040001020' '1003 254200000000' '1010 777777000000'
run_guest aobjn_long '1000 200040001010' '1001 253040001001' \
    '1002 202040001020' '1003 254200000000' '1010 777774000000'
run_guest aobjp_false '1000 200040001010' '1001 252040001003' \
    '1002 202040001020' '1003 254200000000' '1010 777776000000'
python3 - "$root/tools/aap-tick-cost-v1.py" "$work" <<'PY'
import importlib.util
from pathlib import Path
import re
import sys

spec = importlib.util.spec_from_file_location('aap_cost', sys.argv[1])
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
root = Path(sys.argv[2])
expected = {
    'jumpe': (['001000', '001001', '001003', '001004', '001005'],
              ['201', '322', '201', '202', '254'], '000000000007'),
    'jumpn': (['001000', '001001', '001002', '001003', '001004'],
              ['201', '326', '201', '202', '254'], '000000000007'),
    'skipe': (['001000', '001002', '001003', '001004'],
              ['332', '201', '202', '254'], '000000000007'),
    'skipe_false': (['001000', '001001', '001002', '001003'],
                    ['332', '201', '202', '254'], '000000000005'),
    'aobjn': (['001000', '001001', '001001', '001002', '001003'],
              ['200', '253', '253', '202', '254'], '000000000002'),
    'aobjn_short': (['001000', '001001', '001002', '001003'],
                    ['200', '253', '202', '254'], '000000000001'),
    'aobjn_long': (['001000', '001001', '001001', '001001', '001001',
                   '001002', '001003'],
                   ['200', '253', '253', '253', '253', '202', '254'],
                   '000000000004'),
    'aobjp': (['001000', '001001', '001003', '001004'],
              ['200', '252', '202', '254'], '000000000001'),
    'aobjp_false': (['001000', '001001', '001002', '001003'],
                    ['200', '252', '202', '254'], '777777000001'),
}

pattern = re.compile(r'^AAP_TIMING_V1 (IT0|ET0A) tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})$')
for name, (pcs, opcodes, result) in expected.items():
    path = root / (name + '.trace')
    events = [pattern.fullmatch(line) for line in path.read_text().splitlines()]
    assert events and all(events), (name, 'malformed/missing milestone', path.read_text())
    assert [event.group(1) for event in events] == ['IT0', 'ET0A'] * len(pcs), name
    assert [event.group(3) for event in events[1::2]] == pcs, (name, events)
    assert [event.group(4) for event in events[1::2]] == opcodes, name
    ticks = [int(event.group(2)) for event in events]
    assert all(a < b for a, b in zip(ticks, ticks[1:])), (name, ticks)
    costs = module.intervals(path)
    assert len(costs) == len(pcs) - 1, (name, costs)
    assert [cost['pc'] for cost in costs] == pcs[:-1], name
    assert [cost['opcode_octal'] for cost in costs] == opcodes[:-1], name
    assert all(cost['ticks'] > 0 for cost in costs), name
    output = (root / (name + '.stdout')).read_text()
    matches = re.findall(r'001020: ([0-7]{12})$', output, re.MULTILINE)
    assert matches == [result], (name, matches, result, output)
    print('AAP %s: PASS (%d complete intervals)' % (name, len(costs)))
PY
