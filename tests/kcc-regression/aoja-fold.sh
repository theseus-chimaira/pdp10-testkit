#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-aoja-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int f(char *p, unsigned int n)
{
    unsigned int i;

    for (i = 0; i < n; ++i)
        if (p[i] == '\n')
            return (int)(i + 1U);
    return (int)n;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

grep -Eq 'aoja[[:space:]]+1,%L[0-9]+' "$ASM"
if grep -A1 -E 'addi[[:space:]]+1,1[[:space:]]*$' "$ASM" \
  | grep -Eq 'jrst[[:space:]]+%L[0-9]+'; then
    echo "AOJA fold left ADDI/JRST pair" >&2
    exit 1
fi

echo "AOJA fold regression passed"
