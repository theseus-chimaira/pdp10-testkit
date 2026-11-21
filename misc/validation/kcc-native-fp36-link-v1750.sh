#!/bin/sh
# Rebuild native KCC phases with the real compiler D-format ABI library.
# Keep all outputs isolated; no installed compiler or DAIMOS image changes.
set -eu
: "${KCC_REPO:?}" "${DAIMOS_REPO:?}" "${PDP10_PREFIX:?}"
TMPDIR=${TMPDIR:-$HOME/tmp}
export TMPDIR PATH="$PDP10_PREFIX/bin:$PATH"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/kcc-native-fp36-v1750.XXXXXXXX")
trap 'if [ "${KEEP_WORK:-0}" = 1 ]; then echo "retained: $work"; else rm -rf "$work"; fi' EXIT HUP INT TERM
host="$work/host/kcc"
native="$work/native"
mkdir -p "$work/host" "$native"
make -C "$KCC_REPO" -j2 \
    "HOST_BUILD_DIR=$work/host" "KCC=$host" "$host" \
    > "$work/host-build.log" 2>&1 || {
        tail -40 "$work/host-build.log" >&2
        exit 1
    }
make -C "$KCC_REPO" -j2 \
    "HOST_BUILD_DIR=$work/host" "KCC=$host" \
    "NATIVE_BUILD_DIR=$native" \
    "NATIVE_DAIMOS_LIBC_ROOT=$native/daimos-libc" \
    "DAIMOS_REPO=$DAIMOS_REPO" "PDP10_PREFIX=$PDP10_PREFIX" \
    "$native/KCC.dxr" "$native/KCPP.dxr" "$native/KPARSE.dxr" \
    "$native/KGEN.dxr" "$native/KOPT.dxr" \
    > "$work/native-build.log" 2>&1 || {
        tail -50 "$work/native-build.log" >&2
        exit 1
    }
for name in KCC KCPP KPARSE KGEN KOPT; do
    "$PDP10_PREFIX/bin/dxrcheck" "$native/$name.dxr" || exit 1
done
test -s "$native/runtime/fp36-conversions-v1750.a"
test -s "$native/runtime/fp36-signed-df-v1750.dobj"
test -s "$native/runtime/fp36-unsigned-v1750.dobj"
grep -F 'LINK ' "$work/native-build.log" | grep -F 'KPARSE.dxr' >/dev/null
grep -F 'LINK ' "$work/native-build.log" | grep -F 'KGEN.dxr' >/dev/null
sh "$DAIMOS_REPO/scripts/stage-kcc-sources-v1.sh" \
    "$KCC_REPO" "$work/staged" "$PDP10_PREFIX/bin/csix" \
    "$PDP10_PREFIX/bin/s6text" "$DAIMOS_REPO" "$native" \
    > "$work/stage.log" 2>&1 || {
        tail -40 "$work/stage.log" >&2
        exit 1
    }
test -s "$work/staged/BOOT/FP36.DARC"
cmp "$native/runtime/fp36-conversions-v1750.a" "$work/staged/BOOT/FP36.DARC"
grep -F 'BOOT/FP36.DARC' "$KCC_REPO/daimos.mk" | grep -F 'BOOT/LIBC.DARC' >/dev/null
echo 'PASS v1750: five native KCC phases link and exact FP36 archive is staged for self-hosting'
