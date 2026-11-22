#!/bin/sh
set -eu

# HIcmp is a compile-only torture input with deliberately invalid absolute
# addresses.  Verify the emitted PDP-6 caller ABI rather than executing its
# undefined memory accesses.
if [ -z "${TMPDIR:-}" ]; then
    TMPDIR="$HOME/tmp"
fi
mkdir -p "$TMPDIR"
PDP10_PREFIX="${PDP10_PREFIX:-$HOME/cross}"
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
source="$root/tests/codegen/upstream-gcc/torture-unsorted/HIcmp.c"
work=$(mktemp -d "$TMPDIR/p10tk-hicmp-codegen-v1.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

for cpu in pdp6 ka10 ks10; do
    "$PDP10_PREFIX/bin/kcc" -S -v=nostats -x="$cpu" \
        -I"$PDP10_PREFIX/lib/kcc/include" \
        -o "$work/$cpu.s" "$source" >"$work/$cpu.log" 2>&1 || {
        cat "$work/$cpu.log" >&2
        exit 1
    }
    if grep -i -q '^[[:space:]]*SETM[[:space:]]' "$work/$cpu.s"; then
        echo "FAIL: $cpu HIcmp uses SETM register-as-memory transfer" >&2
        exit 1
    fi
    if [ "$cpu" = pdp6 ]; then
        if ! grep -q 'PUSHJ.*%ADJBPH' "$work/$cpu.s" ||
            ! grep -q 'MOVEM.*0(17)' "$work/$cpu.s"; then
            echo "FAIL: PDP-6 HIcmp lacks stack-marshalled ADJBP" >&2
            exit 1
        fi
    fi
    printf 'PASS: HIcmp %s assembly register marshalling\n' "$cpu"
done
