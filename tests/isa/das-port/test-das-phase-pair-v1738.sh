#!/bin/sh
# The host DAS driver and phase-2 binary must understand the same DASIR2.
set -eu
: "${PDP10_PREFIX:?PDP10_PREFIX must be set}"
: "${TMPDIR:?TMPDIR must be set}"
root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
# The phase-pair contract uses the real in-tree DAIMOS stage1 source.
# A caller may select a checkout explicitly; otherwise use its known
# sibling checkout.  Never generate a substitute stage1 fixture.
DAIMOS_REPO=${DAIMOS_REPO:-$root/../DAIMOS}
test -f "$DAIMOS_REPO/system/stand/pdp6/dsk/stage1.s" || {
    echo 'missing actual DAIMOS stage1 source' >&2
    exit 2
}
work="$TMPDIR/pdp10-das-phase-pair-v1738-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work/bin"
# The driver resolves phase 2 relative to its own executable pathname.
cp "$PDP10_PREFIX/bin/das" "$work/bin/das"
cp "$PDP10_PREFIX/bin/das2" "$work/bin/das2"
"$work/bin/das" -F -K -O "$work/stage1-dsk.dxr" \
    "$DAIMOS_REPO/system/stand/pdp6/dsk/stage1.s"
"$PDP10_PREFIX/bin/dxrcheck" "$work/stage1-dsk.dxr" | \
    grep -q '^DXR image=000553 bss=001557 entry=000000 reloc=000013$'
echo 'DAS host phase pair v1738: PASS'
