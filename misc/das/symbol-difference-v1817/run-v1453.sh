#!/bin/sh
# Tests belong to daimos-testkit, not the assembler source tree.
set -eu
: "${DAS_V1453:?path to freshly compiled DAS after the v1453 fix}"
PDP10_PREFIX=${PDP10_PREFIX:-"$HOME/cross"}
TMPDIR=${TMPDIR:-"$HOME/tmp"}
base=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
work="$TMPDIR/das-symbol-difference-v1453"
mkdir -p "$work"

if "$DAS_V1453" -F -C -O "$work/cross-object-v1453.dobj" \
    "$base/cross-object-v1453.s" > "$work/cross.out" 2>&1; then
    echo "FAIL: cross-object symbol difference was silently accepted"
    exit 1
fi
grep -q "unsupported difference of separately relocated symbols" \
    "$work/cross.out"
echo "PASS invalid cross-object difference rejected"

"$DAS_V1453" -F -C -O "$work/same-object-v1453.dobj" \
    "$base/same-object-v1453.s"
"$PDP10_PREFIX/bin/pdp10-dec-none-objdump" -d \
    "$work/same-object-v1453.dobj" > "$work/same-object-v1453.txt"
grep -q '^000000:.*000061' "$work/same-object-v1453.txt"
echo "PASS same-section symbol difference encoded correctly (000061)"
