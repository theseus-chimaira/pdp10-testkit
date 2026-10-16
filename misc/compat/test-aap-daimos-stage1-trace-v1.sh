#!/bin/sh
set -eu
export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR/aap-daimos-stage1-trace-v1"
w="$TMPDIR/aap-daimos-stage1-trace-v1"
root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cat > "$w/init.ini" <<INI
mkdev apr apr166
mkdev ptr ptr760
mkdev fmem fmem162 0
mkdev mem0 moby mem_0
connectio ptr apr
connectmem fmem 0 apr -1
connectmem mem0 0 apr 0
mount ptr $root/DAIMOS/build/system/boot/pdp6/stage1-dsk.pt
INI
cat > "$w/bootstrap.txt" <<'BOOT'
power on
deposit 20 710600000060
deposit 21 710740000010
deposit 22 254000000021
deposit 23 710440000026
deposit 24 710740000010
deposit 25 254000000024
deposit 26 000000000000
deposit 27 254000000021
start 20
BOOT
(cd "$root/pdp6/emu" && cc -O2 -o "$w/pdp6_n" main_net.c emu.c apr.c mem.c tty.c pt.c dc.c dt.c pclk.c netmem.c netcons.c cmd.c util.c threading.c rtc.c ../tools/pdp6common.c -lpthread -lm)
(cd "$w" && PDP6_AAP_TIMING_TRACE_V1=1 PDP6_AAP_CLASS_TRACE_V1=1 timeout 2 ./pdp6_n < bootstrap.txt > guest.log 2> guest.err) || test "$?" -eq 124
python3 - "$w/guest.err" <<'PY'
import sys,re,collections
s=open(sys.argv[1]).read();c=collections.Counter(int(x,8) for x in re.findall(r'AAP_TIMING_V1 IT0 tick=\d+ pc=([0-7]{6})',s));print('AAP stage1 bounded trace: samples',sum(c.values()),'distinct',len(c),'top',[(oct(p),n) for p,n in c.most_common(14)],'minmax',tuple(map(oct,(min(c),max(c)))) if c else None,'exceptions',len(re.findall('AAP_CLASS_EVENT',s)))
assert c and all(0o20 <= x <= 0o22 for x in c), 'execution left verified low-core loop; inspect before claiming anything'
print('BOOT UNVERIFIED: no linked KCORE/MRES execution observed')
PY
