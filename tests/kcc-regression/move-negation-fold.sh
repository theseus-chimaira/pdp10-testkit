#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-move-negation-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int negreg(x)
int x;
{
    int y;

    y = x;
    return -y;
}

int negmem(p)
int *p;
{
    int y;

    y = *p;
    return -y;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

if grep -Eq 'move[[:space:]]+1,[0-9]+[[:space:]]*$' "$ASM" && \
   grep -Eq 'movn[[:space:]]+1,1[[:space:]]*$' "$ASM"; then
    echo "MOVE/MOVN register fold did not fire" >&2
    exit 1
fi

if grep -Eq 'move[[:space:]]+1,0\([0-9]+\)[[:space:]]*$' "$ASM" && \
   grep -Eq 'movn[[:space:]]+1,1[[:space:]]*$' "$ASM"; then
    echo "MOVE/MOVN memory fold did not fire" >&2
    exit 1
fi

grep -Eq 'movn[[:space:]]+[0-9]+,' "$ASM"

echo "move negation fold regression passed"
