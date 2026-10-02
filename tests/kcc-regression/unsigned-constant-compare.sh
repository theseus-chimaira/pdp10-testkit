#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-unsigned-constant-compare-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int in_range(unsigned int x)
{
    return x >= 1U && x <= 7U;
}

int less_than(unsigned int x)
{
    return x < 123U;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

grep -Eq 'camle[[:space:]]+[0-7]+,\[0?400000000007\][[:space:]]*$' "$ASM"
grep -Eq 'caml[[:space:]]+[0-7]+,\[0?400000000173\][[:space:]]*$' "$ASM"

# The two bounds of in_range() must share one biased copy of x.
if [ "$(grep -Ec 'tlc[[:space:]]+[0-7]+,0?400000[[:space:]]*$' "$ASM")" -ne 2 ]; then
    echo "unsigned range comparison did not reuse the biased operand" >&2
    exit 1
fi

if grep -Eq 'movei[[:space:]]+[0-7]+,(7|173)[[:space:]]*$' "$ASM"; then
    echo "unsigned constant comparison materialized the constant in an AC" >&2
    exit 1
fi

echo "unsigned constant comparison regression passed"
