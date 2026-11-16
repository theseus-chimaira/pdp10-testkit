#!/bin/sh
# Exercise the native phase-2 scratch-backed relocation bitmap on the host.
set -eu

DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
DAIMOS_REPO=${DAIMOS_REPO:?set DAIMOS_REPO to the DAIMOS source tree}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
CC=${CC:-cc}
TEST_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
work=$TMPDIR/das-native-relmap-spill-v1-$$
trap 'rm -f "$work"' 0 1 2 3 15

"$CC" -O2 -std=c89 -ffunction-sections -fdata-sections \
    -I"$DAS_ROOT" -I"$DAIMOS_REPO/userland/libc" \
    -I"$PDP10_PREFIX/include" \
    -I"$DAIMOS_REPO/system/kernel/boot" \
    -I"$DAIMOS_REPO/system/kernel/core" \
    -I"$DAIMOS_REPO/system/kernel/drivers" \
    -I"$DAIMOS_REPO/system/kernel/fs" \
    -I"$DAIMOS_REPO/system/kernel/mm" \
    -I"$DAIMOS_REPO/system/kernel/modules" \
    -I"$DAIMOS_REPO/system/kernel/proc" \
    -I"$DAIMOS_REPO/system/kernel/storage" \
    -Wl,--gc-sections -o "$work" \
    "$TEST_ROOT/das-native-relmap-spill-v1.c"
"$work"
echo 'DAS native disk-backed relocation bitmap: PASS'
