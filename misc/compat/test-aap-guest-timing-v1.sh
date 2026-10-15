#!/bin/sh
# Real AAP guest execution: verify memory attachment and timing milestones.
# No simulated tick is interpreted as an elapsed nanosecond.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/aap-guest-timing-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
aap=${PDP6_AAP_ROOT:-"$root/../pdp6"}
emu="$aap/emu"

# Keep all generated binaries and the writable 256K-word memory image out
# of the emulator source tree. The existing emulator uses GNU C extensions.
(
    cd "$emu"
    ${CC:-cc} -O2 -o "$work/pdp6_n" \
        main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c \
        pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c \
        ../tools/pdp6common.c -lpthread -lm
)
cat > "$work/init.ini" <<'EOF'
mkdev apr apr166
mkdev ptr ptr760
mkdev mem0 moby mem_0
connectmem mem0 0 apr 0
EOF
(
    cd "$work"
    (printf 'power on\ndeposit 1000 254200000000\nstart 1000\n';
     sleep 1; printf 'quit\n') |
        PDP6_AAP_TIMING_TRACE_V1=1 timeout 10 "$work/pdp6_n" \
        > guest.log 2> timing.log
)
python3 - "$work/timing.log" <<'PY'
import pathlib
import re
import sys
lines = pathlib.Path(sys.argv[1]).read_text().splitlines()
pattern = re.compile(r'^AAP_TIMING_V1 (IT0|ET0A) tick=(\d+) pc=([0-7]{6}) inst=([0-7]{3})$')
events = [pattern.fullmatch(line) for line in lines]
assert events and all(events), 'missing or malformed trace records'
ticks = [int(m.group(2)) for m in events]
assert ticks == sorted(ticks), 'nonmonotonic logical clock'
assert any(m.group(1) == 'IT0' for m in events), 'no instruction fetch'
assert any(m.group(1) == 'ET0A' and m.group(4) == '254' for m in events), 'no JRST execution milestone'
print('AAP PDP-6 guest timing v1: PASS (%d milestones)' % len(events))
PY
