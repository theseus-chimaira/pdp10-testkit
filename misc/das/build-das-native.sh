#!/bin/sh
# Build and validate the native DAS phase chain using the current DAS
# Makefile contract.  Guest boot execution is owned by daimos-testkit.
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
PDP10_KCC=$PDP10_PREFIX/bin/kcc
PDP10_DLINK=$PDP10_PREFIX/bin/dlink

for tool in "$PDP10_KCC" "$PDP10_DLINK"; do
    [ -x "$tool" ] || fail "missing tool: $tool"
done
[ -f "$DAS_ROOT/Makefile" ] || fail "invalid DAS_ROOT: $DAS_ROOT"
[ -f "$DAIMOS_REPO/userland/libc/crt0.s" ] || \
    fail "invalid DAIMOS_REPO: $DAIMOS_REPO"

work=$(mktemp -d "$TMPDIR/das-native-chain-v2.XXXXXX")
cleanup()
{
    if [ "${KEEP_WORK:-0}" = 1 ]; then
        echo "native DAS evidence retained: $work"
    else
        rm -rf "$work"
    fi
}
trap cleanup 0

make -C "$DAS_ROOT" native-driver native-phases \
    DAIMOS_REPO="$DAIMOS_REPO" \
    PDP10_PREFIX="$PDP10_PREFIX" \
    PDP10_KCC="$PDP10_KCC" \
    PDP10_DLINK="$PDP10_DLINK" \
    NATIVE_BUILD_DIR="$work"

python3 "$(dirname "$0")/check-das-native-chain.py" \
    --driver "$work/das.dxr" \
    --phase1 "$work/das1.dxr" \
    --phase2 "$work/das2.dxr" \
    --phase1-assembly "$work/das1-v1.s"
