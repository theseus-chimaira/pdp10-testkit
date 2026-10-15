#!/bin/sh
# Real guest control-flow fixtures for AAP logical instruction boundaries.
# XCT deliberately does not fit the single-IT0/single-ET0A cost model.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/aap-control-flow-v1.XXXXXXXX")
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
         printf 'quit\n') |
            PDP6_AAP_TIMING_TRACE_V1=1 timeout 10 "$work/pdp6_n" \
                > "$name.stdout" 2> "$name.trace"
    )
}
# Direct JRST to 1002; 1001 deliberately skipped.
run_guest direct '1000 254000001002' '1001 254200000000' \
    '1002 201040000001' '1003 254200000000'
# Indirect JRST via pointer in memory word 1010.
run_guest indirect '1000 254020001010' '1001 254200000000' \
    '1010 000000001002' '1002 201040000001' '1003 254200000000'
# XCT executes MOVEI stored at 1010 before the following HALT.
run_guest xct '1000 256000001010' '1001 254200000000' \
    '1010 201040000001'
python3 - "$root/tools/aap-tick-cost-v1.py" "$work" <<'PY'
import importlib.util
from pathlib import Path
import re
import sys

spec = importlib.util.spec_from_file_location('aap_cost', sys.argv[1])
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
root = Path(sys.argv[2])
for name in ('direct', 'indirect'):
    path = root / (name + '.trace')
    events = re.findall(r'^AAP_TIMING_V1 (IT0|ET0A) tick=\d+ pc=([0-7]{6}) inst=([0-7]{3})$',
                        path.read_text(), re.MULTILINE)
    assert [event[0] for event in events] == ['IT0', 'ET0A'] * 3, (name, events)
    assert [event[1] for event in events[1::2]] == ['001000', '001002', '001003']
    assert [event[2] for event in events[1::2]] == ['254', '201', '254']
    intervals = module.intervals(path)
    assert len(intervals) == 2 and all(entry['ticks'] > 0 for entry in intervals)

path = root / 'xct.trace'
events = re.findall(r'^AAP_TIMING_V1 (IT0|ET0A) tick=\d+ pc=([0-7]{6}) inst=([0-7]{3})$',
                    path.read_text(), re.MULTILINE)
assert [event[0] for event in events] == ['IT0', 'ET0A', 'ET0A', 'IT0', 'ET0A']
assert [event[2] for event in events] == ['000', '256', '201', '201', '254']
try:
    module.intervals(path)
except ValueError:
    pass
else:
    raise AssertionError('XCT nested execution was incorrectly accepted')
print('AAP direct/indirect JRST and XCT guest boundaries v1: PASS')
PY
