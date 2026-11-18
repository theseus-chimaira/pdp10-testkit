#!/bin/sh
# The original dynamic-sized aggregate va_arg must not crash GCC's backend.
# Compile-only by design: its bare-metal runtime assertion is still deferred
# while the caller's variable-block copy ABI is investigated separately.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env

: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-gcc-varargs-vla-no-ice-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
source="$root/tests/todo/generic/20020412-1.c"

for machine in pdp6 ka10 ki10 ks10; do
    for opt in O0 O1 O2 Os; do
        asm="$work/$machine-$opt.s"
        "$PDP10_GCC" -S "-$opt" "-march=$machine" \
            -o "$asm" "$source" > "$work/$machine-$opt.log" 2>&1 || {
            cat "$work/$machine-$opt.log" >&2
            echo "FAIL GCC VLA va_arg compile: $machine $opt" >&2
            exit 1
        }
        test -s "$asm"
        grep -Eq '^foo:' "$asm"
        grep -Eq '^main:' "$asm"
        echo "PASS GCC VLA va_arg compile without ICE: $machine $opt"
    done
done
