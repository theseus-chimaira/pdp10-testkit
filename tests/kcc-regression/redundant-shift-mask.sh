#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-redundant-shift-mask-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
unsigned long redundant(x)
unsigned long x;
{
    return (x >> 26) & 01777UL;
}

unsigned long needed(x)
unsigned long x;
{
    return (x >> 26) & 0777UL;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

if awk '/^redundant:/{f=1;next} /^needed:/{f=0} f && /andi[[:space:]]/' "$ASM" | grep -q .; then
    echo "redundant post-shift mask was not removed" >&2
    exit 1
fi

if ! awk '/^needed:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f) exit} f && /andi[[:space:]]/' "$ASM" | grep -q .; then
    echo "required post-shift mask was incorrectly removed" >&2
    exit 1
fi

echo "redundant shift mask regression passed"
