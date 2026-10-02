#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-live-abi-index-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
unsigned long span[8];

int store_level(unsigned int level)
{
    if ((unsigned int)(level - 1U) >= 7U)
        return -1;
    span[level] = 1UL;
    return 0;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

# The validity check may compute level-1, but it must not modify incoming AC1.
if grep -Eq 'subi[[:space:]]+1,1[[:space:]]*$' "$ASM"; then
    echo "live ABI argument was destructively folded" >&2
    exit 1
fi
# The indexed store must still use the original level value from AC1.
grep -Eq 'move[[:space:]]+[0-7]+,1[[:space:]]*$' "$ASM"
grep -Eq 'movem[[:space:]]+[0-7]+,0\([0-7]+\)[[:space:]]*$' "$ASM"

echo "live ABI indexed-access regression passed"
