#!/bin/sh
# Real guest control-flow fixtures for AAP logical instruction boundaries.
# XCT is accounted for as one outer IT0 interval with nested opcodes.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/aap-xct-v2.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
aap=${PDP6_AAP_ROOT:-"$root/../pdp6"}
(
    cd "$aap/emu"
    ${CC:-cc} -O2 -o "$work/pdp6_n" \
        main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c \
        pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c \
        ../tools/pdp6common.c -lpthread -lm
)
cat > "$work/init.ini" <<'EOF'
mkdev apr apr166
mkdev ptr ptr760
mkdev fmem fmem162 0
mkdev mem0 moby mem_0
connectmem fmem 0 apr -1
connectmem mem0 0 apr 0
EOF
run_guest()
{
    name=$1
    shift
    (
        cd "$work"
        (printf 'power on\n';
         for entry in "$@"; do
             printf 'deposit %s\n' "$entry"
         done
         printf 'start 1000\n'
         sleep 1
         printf 'examine 1020\nquit\n') |
            PDP6_AAP_TIMING_TRACE_V1=1 timeout 10 "$work/pdp6_n" \
                > "$name.stdout" 2> "$name.trace"
    )
}
# Nested XCT executes MOVEI then stores the result in memory.
run_guest nested '1000 256000001010' '1001 202040001020' \
 '1002 254200000000' '1010 256000001012' '1012 201040000007'
# XCT executes a nonbranching memory reference; compare to nesting.
run_guest memory '1000 256000001010' '1001 202040001020' \
 '1002 254200000000' '1010 200040001014' '1014 000000000123'
# XCT executes a taken JRST, which skips an intervening instruction.
run_guest branch '1000 256000001010' '1001 254200000000' \
 '1002 201040000007' '1003 202040001020' \
 '1004 254200000000' '1010 254000001003'
python3 - "$root/tools/aap-tick-cost-v1.py" "$work" <<'PYTEST'
import importlib.util
from pathlib import Path
import re
import sys
spec = importlib.util.spec_from_file_location('aap_cost', sys.argv[1])
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
root = Path(sys.argv[2])
expected = {
 'nested': (['001000', '001001', '001002'], ['256', '202', '254'],
            ['256', '201'], '000000000007'),
 'memory': (['001000', '001001', '001002'], ['256', '202', '254'],
            ['200'], '000000000123'),
 'branch': (['001000', '001003', '001004'], ['256', '202', '254'],
            ['254'], '000000000000'),
}
pattern = re.compile(r'^AAP_TIMING_V1 (IT0|ET0A) tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})$')
for name, (pcs, opcodes, nested, result) in expected.items():
 path = root / (name + '.trace')
 events = [pattern.fullmatch(line) for line in path.read_text().splitlines()]
 assert events and all(events), (name, path.read_text())
 starts = [e.group(3) for e in events if e.group(1) == 'IT0']
 assert starts == pcs, (name, starts, pcs)
 intervals = module.intervals(path)
 assert len(intervals) == len(pcs)-1, (name, intervals)
 assert intervals[0]['opcode_octal'] == '256', (name, intervals)
 assert intervals[0]['nested_opcodes_octal'] == nested, (name, intervals)
 assert [x['opcode_octal'] for x in intervals] == opcodes[:-1], (name, intervals)
 assert all(x['ticks'] > 0 for x in intervals), name
 output = (root / (name + '.stdout')).read_text()
 values = re.findall(r'001020: ([0-7]{12})$', output, re.MULTILINE)
 assert values == [result], (name, values, result)
 print('AAP XCT %s: PASS (%d intervals)' % (name, len(intervals)))
PYTEST
