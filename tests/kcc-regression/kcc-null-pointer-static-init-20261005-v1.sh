#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
base=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
out="$TMPDIR/kcc-null-pointer-static-init-20261005-v1-$$.s"
trap 'rm -f "$out"' EXIT HUP INT TERM
"$KCC" -Pgnu99 -x=pdp6 -m=gas -S \
    "$base/kcc-null-pointer-static-init-20261005-v1.c" -o "$out" >/dev/null
if grep -Eq '^[[:space:]]*\.LINK([[:space:]]|$)' "$out"; then
        echo 'null-pointer-static-init: runtime constructor emitted' >&2
        exit 1
fi
grep -A1 '^char_pointer:' "$out" | grep -Eq '^[[:space:]]*\.word[[:space:]]+0$'
grep -A1 '^word_pointer:' "$out" | grep -Eq '^[[:space:]]*\.word[[:space:]]+0$'
echo 'null-pointer-static-init: PASS'
