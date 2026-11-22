#!/bin/sh
set -eu

# GCC upstream obstack testcase previously caused simsubbp to reject
# the immediate numeric pointer operand produced by the peephole pass.
# It also contains undefined/unsupported runtime constructs; compile
# only, and do not treat guest execution as a correctness oracle.
if [ -z "${TMPDIR:-}" ]; then
    TMPDIR="$HOME/tmp"
fi
mkdir -p "$TMPDIR"
PDP10_PREFIX="${PDP10_PREFIX:-$HOME/cross}"
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
source="$root/tests/todo/generic/20001203-2.c"
work=$(mktemp -d "$TMPDIR/p10tk-subbp-constant-v1.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

for cpu in pdp6 ka10 ki10 ks10; do
    "$PDP10_PREFIX/bin/kcc" -S -v=nostats -x="$cpu" \
        -I"$PDP10_PREFIX/lib/kcc/include" \
        -o "$work/$cpu.s" "$source" >"$work/$cpu.log" 2>&1 || {
        cat "$work/$cpu.log" >&2
        echo "FAIL: KCC constant SUBBP operand on $cpu" >&2
        exit 1
    }
    if grep -q 'Internal error' "$work/$cpu.log"; then
        cat "$work/$cpu.log" >&2
        exit 1
    fi
    printf 'PASS: KCC constant SUBBP compilation on %s\n' "$cpu"
done
