#!/bin/sh
# GCC PDP-10 subword stack slot ADDRESSOF regression.
# Compilation must succeed and produce assembler at all optimization levels.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-addressof-ice-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
for opt in -O0 -O1 -O2 -Os; do
    "$PDP10_GCC" "$opt" -fno-builtin -march=pdp6 -S \
        -o "$work/check.s" \
        "$root/tests/semantic/validation-gcc/gcc-addressof-pdp6-ice-v1.c"
    test -s "$work/check.s"
done
echo 'PASS GCC PDP-6 ADDRESSOF compiler regression (-O0/-O1/-O2/-Os)'
