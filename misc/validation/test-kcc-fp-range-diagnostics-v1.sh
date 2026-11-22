#!/bin/sh
set -eu

# The upstream long-double overflow must be reported as a source-range
# error, not as a KCC internal compiler failure.  Keep the original
# upstream testcase and its source semantics unchanged.

if [ -z "${TMPDIR:-}" ]; then
    TMPDIR="$HOME/tmp"
fi
mkdir -p "$TMPDIR"
PDP10_PREFIX="${PDP10_PREFIX:-$HOME/cross}"
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
source="$root/tests/semantic/upstream/generic/960405-1.c"
work=$(mktemp -d "$TMPDIR/p10tk-kcc-fp-range-v1.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

for profile in base pdp6; do
    if "$PDP10_PREFIX/bin/kcc" -S -v=nostats -x="$profile" \
        -I"$PDP10_PREFIX/lib/kcc/include" \
        -o "$work/$profile.s" "$source" \
        >"$work/$profile.log" 2>&1; then
        echo "FAIL: out-of-range long double accepted ($profile)" >&2
        exit 1
    fi
    if ! grep -q 'Floating constant overflow' "$work/$profile.log" ||
        ! grep -q 'error detected' "$work/$profile.log" ||
        grep -q 'Internal error' "$work/$profile.log"; then
        cat "$work/$profile.log" >&2
        echo "FAIL: incorrect overflow diagnostic ($profile)" >&2
        exit 1
    fi
    printf 'PASS: target floating range diagnostic (%s)\n' "$profile"
done
