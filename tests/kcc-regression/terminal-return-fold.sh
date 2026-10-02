#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-terminal-return-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int half(unsigned long *p)
{
    return (int)(*p >> 18);
}

int neg(void)
{
    return -2;
}

int zero(void)
{
    return 0;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

grep -Eq 'hlrz[[:space:]]+1,0\(1\)' "$ASM"
grep -Eq 'movni[[:space:]]+1,2' "$ASM"
grep -Eq 'setz[[:space:]]+1,' "$ASM"

if grep -Eq 'move[[:space:]]+1,[2-7]' "$ASM"; then
    echo "terminal return retained temporary-to-AC1 copy" >&2
    exit 1
fi

echo "terminal return producer regression passed"
