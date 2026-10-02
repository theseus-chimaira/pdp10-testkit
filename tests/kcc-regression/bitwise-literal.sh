#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-bitwise-literal-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat >"$TMP/test.c" <<'SRC'
int ior_low(int x) { return x | 0123456; }
int and_low(int x) { return x & 0777; }
int xor_low(int x) { return x ^ 0123; }
int ior_high(int x) { return x | 0123456000000; }
SRC

(
    cd "$TMP"
    "$KCC" -S -x=pdp6 test.c >/dev/null
)
ASM=$TMP/test.s

grep -Eq 'iori[[:space:]]+1,0?123456' "$ASM" || {
    echo "literal IOR did not use IORI" >&2
    exit 1
}
grep -Eq 'andi[[:space:]]+1,0?777' "$ASM" || {
    echo "literal AND did not use ANDI" >&2
    exit 1
}
grep -Eq 'xori[[:space:]]+1,0?123' "$ASM" || {
    echo "literal XOR did not use XORI" >&2
    exit 1
}
grep -Eq 'tlo[[:space:]]+1,0?123456' "$ASM" || {
    echo "left-half literal IOR did not use TLO" >&2
    exit 1
}

if grep -Eq 'movei[[:space:]]+[0-9]+,(0?123456|0?777|0?123)[[:space:]]*$' "$ASM"; then
    echo "bitwise literal was still materialized in a temporary AC" >&2
    exit 1
fi

echo "bitwise literal regression passed"

