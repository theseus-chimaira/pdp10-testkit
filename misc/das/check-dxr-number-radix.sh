#!/bin/sh
set -eu
root=${1:-.}
assembler=${2:-$root/das}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
tmp=$TMPDIR/das-radix.$$
trap 'rm -f "$tmp.dxr"' 0 1 2 3 15
"$assembler" -B -A -O "$tmp.dxr" "$root/dxr-number-radix.s"
python3 - "$tmp.dxr" <<'PYRADIX'
import pathlib
import sys
mask = 0o777777777777
data = pathlib.Path(sys.argv[1]).read_bytes()
if len(data) % 8:
    raise SystemExit('partial host word')
words = [int.from_bytes(data[i:i + 8], 'little') & mask
         for i in range(0, len(data), 8)]
count = (words[1] >> 18) & 0o777777
image = words[2:2 + count]
want = [
    0o12, 0o10, 0o103335, 0o34525,
    0o201040000010, 0o201100000010, 0o201140000012,
    0o201200000010, 0o201240000012,
    0o200300000017, 0o200340000020, 0o200400000021,
    0o10, 0o360600000010, 0o331100000000,
    0o10, 0o12, 0o331100000010,
]
if image != want:
    raise SystemExit('unexpected radix image: ' + ' '.join('%012o' % x for x in image))
PYRADIX
echo "DAS instruction-octal/data-decimal radix contract passed"
