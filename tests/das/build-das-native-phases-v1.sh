#!/bin/sh
set -eu

fail()
{
    echo "build-das-native-phases-v1: $*" >&2
    exit 1
}

TEST_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
PDP10_PREFIX=${PDP10_PREFIX:?set PDP10_PREFIX to the source-built tool prefix}
DAIMOS_REPO=${DAIMOS_REPO:?set DAIMOS_REPO to the DAIMOS source tree}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
BASE=$TMPDIR/das-native-phases-v1-$$
BUILD=$BASE-build
P1S=$BUILD/das1-v1.s
P1I=$BUILD/das1.dxr
P2S=$BUILD/das2-v1.s
P2I=$BUILD/das2.dxr
DRIVER=$BUILD/das.dxr
trap 'rm -rf "$BUILD"' 0 1 2 3 15

[ -x "$PDP10_PREFIX/bin/pdp10-dec-none-gcc" ] || fail "PDP-10 GCC not found"
[ -x "$PDP10_PREFIX/bin/dlink" ] || fail "dlink not found"
[ -f "$DAIMOS_REPO/userland/libc/crt0.s" ] || fail "invalid DAIMOS_REPO"

make -C "$DAS_ROOT" native \
    PDP10_PREFIX="$PDP10_PREFIX" \
    DAIMOS_REPO="$DAIMOS_REPO" \
    NATIVE_BUILD_DIR="$BUILD"

python3 "$TEST_ROOT/check-das-native-comments-asm.py" "$P1S"
python3 "$TEST_ROOT/check-das-native-phases-v1.py" \
    --phase1-image "$P1I" --phase1-assembly "$P1S" \
    --phase2-image "$P2I" --phase2-assembly "$P2S"
python3 "$TEST_ROOT/check-das-native-chain.py" \
    --driver "$DRIVER" --phase1 "$P1I" --phase2 "$P2I" \
    --phase1-assembly "$P1S"

PDP10_PREFIX="$PDP10_PREFIX" DAS_ROOT="$DAS_ROOT" DAIMOS_REPO="$DAIMOS_REPO" \
    NATIVE_BUILD_DIR="$BUILD" TMPDIR="$TMPDIR" \
    "$TEST_ROOT/run-das-native-daimos-v1.sh"
