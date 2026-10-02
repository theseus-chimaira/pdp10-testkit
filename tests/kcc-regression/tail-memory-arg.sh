#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-tail-memory-arg-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
extern int *rootvp;
extern int target(int *, int, int, int);

int wrap(int a, int b, int c)
{
    return target(rootvp, a, b, c);
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

grep -Eq 'move[[:space:]]+1,rootvp' "$ASM"
grep -Eq 'jrst[[:space:]]+target' "$ASM"

if grep -Eq 'move[[:space:]]+[5-7],rootvp' "$ASM"; then
    echo "tail memory argument used an avoidable temporary" >&2
    exit 1
fi

echo "tail memory argument regression passed"
