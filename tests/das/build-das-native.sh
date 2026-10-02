#!/bin/sh
# Build and validate the native DAIMOS DAS phase chain.
set -eu

fail()
{
    echo "build-das-native: $*" >&2
    exit 1
}

DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
DAIMOS_REPO=${DAIMOS_REPO:?set DAIMOS_REPO to the DAIMOS source tree}
PDP10_PREFIX=${PDP10_PREFIX:?set PDP10_PREFIX to the PDP-10 tool installation root}
TMPDIR=${TMPDIR:?set TMPDIR}
PDP10_CC=$PDP10_PREFIX/bin/pdp10-dec-none-gcc
PDP10_AS=$PDP10_PREFIX/bin/pdp10-dec-none-as
PDP10_DLINK=$PDP10_PREFIX/bin/dlink

for tool in "$PDP10_CC" "$PDP10_AS" "$PDP10_DLINK"; do
    [ -x "$tool" ] || fail "missing tool: $tool"
done
[ -f "$DAIMOS_REPO/cross/tools/mkdex0r_user.py" ] || \
    fail "invalid DAIMOS_REPO: $DAIMOS_REPO"

work=$TMPDIR/das-native-chain.$$
mkdir -p "$work"
trap 'rm -rf "$work"' 0 1 2 3 15

make -C "$DAS_ROOT" native-driver native-phases \
    DAIMOS_REPO="$DAIMOS_REPO" \
    PDP10_CC="$PDP10_CC" \
    PDP10_AS="$PDP10_AS" \
    PDP10_DLINK="$PDP10_DLINK" \
    DAS_NATIVE_DRIVER_DXR="$work/das.dxr.words" \
    DAS_NATIVE_DRIVER_ASSEMBLY="$work/das.s" \
    DAS_NATIVE1_DXR="$work/das1.dxr.words" \
    DAS_NATIVE1_ASSEMBLY="$work/das1.s" \
    DAS_NATIVE2_DXR="$work/das2.dxr.words" \
    DAS_NATIVE2_ASSEMBLY="$work/das2.s"

python3 "$(dirname "$0")/check-das-native-chain.py" \
    --driver "$work/das.dxr.words" \
    --phase1 "$work/das1.dxr.words" \
    --phase2 "$work/das2.dxr.words" \
    --phase1-assembly "$work/das1.s"
