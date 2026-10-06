#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
base=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
out="$TMPDIR/kcc-absolute-pointer-store-20261005-v1-$$.s"
trap 'rm -f "$out"' EXIT HUP INT TERM
(
    cd "$base"
    "$KCC" -Pgnu99 -x=pdp6 -m=gas -S \
        kcc-absolute-pointer-store-20261005-v1.c -o "$out" >/dev/null
)
# The second store must be absolute.  0(AC) here is the historical miscompile.
grep -Eq '^[[:space:]]*movem[[:space:]]+[0-7]+,056$' "$out"
if grep -Eq '^[[:space:]]*movem[[:space:]]+[0-7]+,0\([0-7]+\)$' "$out"; then
        echo 'absolute-pointer-store: stale pointer CSE reproduced' >&2
        exit 1
fi
echo 'absolute-pointer-store: PASS'
