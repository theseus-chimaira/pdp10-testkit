#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-shift-scratch-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat >"$TMP/test.c" <<'SRC'
unsigned long shl(unsigned long x, unsigned long n)
{
    return x << n;
}

unsigned long shr(unsigned long x, unsigned long n)
{
    return x >> n;
}

void setl(unsigned long *p, unsigned long x)
{
    *p = (*p & 0777777UL) | ((x & 0777777UL) << 18);
}
SRC

(
    cd "$TMP"
    "$KCC" -S test.c >/dev/null
)
ASM=$TMP/test.s

if grep -Eq 'push[[:space:]]+17,16|move[[:space:]]+16,0\(17\)' "$ASM"; then
    echo "integer shift still forces AC16 save/restore" >&2
    exit 1
fi

grep -Eq 'lsh' "$ASM"

echo "integer shift scratch-register regression passed"
