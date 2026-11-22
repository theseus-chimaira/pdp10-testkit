#!/bin/sh
set -eu

# KCC has no complete zero-length array type.  The GCC extension
# int a[] = {}; must give a normal unsupported-source diagnostic,
# never an ICE or a silently accepted incomplete array.

if [ -z "${TMPDIR:-}" ]; then
    TMPDIR="$HOME/tmp"
fi
mkdir -p "$TMPDIR"
PDP10_PREFIX="${PDP10_PREFIX:-$HOME/cross}"
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
source="$root/tests/codegen/upstream-gcc/compile/920501-22.c"
work=$(mktemp -d "$TMPDIR/p10tk-kcc-empty-array-v1.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

for profile in base pdp6; do
    if "$PDP10_PREFIX/bin/kcc" -S -v=nostats -x="$profile" \
        -I"$PDP10_PREFIX/lib/kcc/include" \
        -o "$work/$profile.s" "$source" \
        >"$work/$profile.log" 2>&1; then
        echo "FAIL: incomplete empty array accepted ($profile)" >&2
        exit 1
    fi
    if ! grep -q 'Empty array initializer cannot determine array size' \
          "$work/$profile.log" ||
        ! grep -q 'error detected' "$work/$profile.log" ||
        grep -q 'Internal error' "$work/$profile.log"; then
        cat "$work/$profile.log" >&2
        echo "FAIL: incorrect empty-array diagnostic ($profile)" >&2
        exit 1
    fi
    printf 'PASS: empty-array source diagnostic (%s)\n' "$profile"
done
