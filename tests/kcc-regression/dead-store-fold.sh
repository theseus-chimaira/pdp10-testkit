#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dead-store-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
void f(p, x)
unsigned long *p;
unsigned long x;
{
    *p = x;
    x += 1;
    *p = x;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

if [ "$(grep -Ec '^[[:space:]]*movem[[:space:]]+[0-7]+,0\(1\)[[:space:]]*$' "$ASM")" -ne 1 ]; then
    echo "dead indexed store was not removed" >&2
    exit 1
fi

if ! grep -Eq '^[[:space:]]*addi[[:space:]]+2,1[[:space:]]*$' "$ASM"; then
    echo "test did not retain the intervening register update" >&2
    exit 1
fi

echo "dead store fold regression passed"
