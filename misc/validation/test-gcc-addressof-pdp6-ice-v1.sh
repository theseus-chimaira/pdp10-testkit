#!/bin/sh
# Pending compiler bug: success requires -O1 compilation without an ICE.
# Manual until fixed; never count the ICE as an expected passing negative.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-addressof-ice-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
"$PDP10_GCC" -O1 -fno-builtin -march=pdp6 -S \
    -o "$work/check.s" \
    "$root/tests/semantic/validation-gcc/gcc-addressof-pdp6-ice-v1.c"
test -s "$work/check.s"
echo 'PASS GCC PDP-6 -O1 ADDRESSOF compile regression'
