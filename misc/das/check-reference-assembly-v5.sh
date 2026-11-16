#!/bin/sh
# Updated owner for the historical KCC FP/include assembler smoke inputs.
# Use DAS DXR output rather than obsolete --start/deposit assembler syntax.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
DAS_ROOT=${DAS_ROOT:-$root/../das}
TMPDIR=${TMPDIR:-$HOME/tmp}
fixture="$root/refs/assembler-inputs"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/das-reference-assembly-v5.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

assembler="$DAS_ROOT/das"
[ -x "$assembler" ] || { echo "missing DAS: $assembler" >&2; exit 1; }

# The legacy assembler's `deposit` format is no longer public. Verify a
# current DXR image, its entry label, and that .include expands identically
# to an explicitly inlined source with the same instructions.
"$assembler" -A -L "$work/include.labels" -O "$work/include.dxr" \
    "$fixture/include-smoke.s"
cat > "$work/inline-v5.s" <<'EOF_ASM'
.text
__start:
        movei 1,0
        addi 1,1
        halt
EOF_ASM
"$assembler" -A -O "$work/inline.dxr" "$work/inline-v5.s"
cmp "$work/include.dxr" "$work/inline.dxr"
grep -i '__start' "$work/include.labels" >/dev/null

# Preserve the original floating-point/byte-pointer instruction corpus.
# An image with only the entry label would not satisfy the word-count gate.
"$assembler" -A -L "$work/fp.labels" -O "$work/fp.dxr" \
    "$fixture/kcc_fp_coverage.s"
grep -i '__start' "$work/fp.labels" >/dev/null
python3 - "$work/include.dxr" "$work/fp.dxr" <<'PY'
import sys
from pathlib import Path

MAGIC = 0o447062
for name, minimum in ((sys.argv[1], 3), (sys.argv[2], 15)):
    raw = Path(name).read_bytes()
    if len(raw) < 16 or len(raw) % 8:
        raise SystemExit('truncated/non-word-aligned DXR: ' + name)
    header = int.from_bytes(raw[0:8], 'little')
    length = int.from_bytes(raw[8:16], 'little')
    if ((header >> 18) & 0o777777) != MAGIC:
        raise SystemExit('invalid DXR header: ' + name)
    words = (length >> 18) & 0o777777
    if words < minimum:
        raise SystemExit('too few assembled words: ' + name)
PY
echo 'DAS historical reference assembly DXR/include contract: PASS'
