#!/bin/sh
# PDP-6 real guest effective-address and logical tick regression.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/aap-addressing-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
aap=${PDP6_AAP_ROOT:-"$root/../pdp6"}
(
 cd "$aap/emu"
 ${CC:-cc} -O2 -o "$work/pdp6_n" main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c \
    pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c -lpthread -lm
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
 name=$1; shift
 (
 cd "$work"
 (printf 'power on\n'; for word in "$@"; do printf 'deposit %s\n' "$word"; done;
  printf 'start 1000\n'; sleep 1; printf 'examine 1020\nquit\n') |
  PDP6_AAP_TIMING_TRACE_V1=1 timeout 10 "$work/pdp6_n" > "$name.stdout" 2> "$name.trace"
 )
}
# Each guest executes MOVE [effective address] and MOVEM to a distinct result.
# Core memory 1010/1012/1014/1016 has deliberately different values.
# 201100000002 initializes index register 2 to the displacement 2.
# The indirect pointer at 1010 can itself be indirect (1014 -> 1016).
run_guest direct '1000 200040001012' '1001 202040001020' '1002 254200000000' \
 '1012 000000000123'
run_guest indexed '1000 201100000002' '1001 200042001010' \
 '1002 202040001020' '1003 254200000000' '1010 000000000777' '1012 000000000123'
run_guest indirect '1000 200060001010' '1001 202040001020' \
 '1002 254200000000' '1010 000000001012' '1012 000000000123'
run_guest nested '1000 200060001010' '1001 202040001020' \
 '1002 254200000000' '1010 000020001014' '1014 000000001016' \
 '1016 000000000456'
run_guest indexed_indirect '1000 201100000002' '1001 200062001010' \
 '1002 202040001020' '1003 254200000000' \
 '1010 000000000777' '1012 000000001016' '1016 000000000456'
python3 - "$root/tools/aap-tick-cost-v1.py" "$work" <<'PY'
import importlib.util
from pathlib import Path
import re
import sys
spec = importlib.util.spec_from_file_location('aap_cost', sys.argv[1])
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
root = Path(sys.argv[2])
expected = {
 'direct': (['200', '202', '254'], '000000000123'),
 'indexed': (['201', '200', '202', '254'], '000000000123'),
 'indirect': (['200', '202', '254'], '000000000123'),
 'nested': (['200', '202', '254'], '000000000456'),
 'indexed_indirect': (['201', '200', '202', '254'], '000000000456'),
}
pattern = re.compile(r'^AAP_TIMING_V1 (IT0|ET0A) tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})$')
for name, (opcodes, value) in expected.items():
 trace = (root / (name + '.trace')).read_text().splitlines()
 events = [pattern.fullmatch(line) for line in trace]
 assert events and all(events), (name, trace)
 assert [e.group(1) for e in events] == ['IT0', 'ET0A'] * len(opcodes), name
 assert [e.group(4) for e in events[1::2]] == opcodes, name
 pcs = [e.group(3) for e in events[1::2]]
 assert pcs == ['%06o' % (0o1000 + i) for i in range(len(opcodes))], (name, pcs)
 ticks = [int(e.group(2)) for e in events]
 assert all(x < y for x, y in zip(ticks, ticks[1:])), name
 costs = mod.intervals(root / (name + '.trace'))
 assert len(costs) == len(opcodes)-1 and all(c['ticks'] > 0 for c in costs), name
 output = (root / (name + '.stdout')).read_text()
 assert re.findall(r'001020: ([0-7]{12})$', output, re.MULTILINE) == [value], (name, output)
 print('AAP address %s: PASS (%d intervals)' % (name, len(costs)))
PY
