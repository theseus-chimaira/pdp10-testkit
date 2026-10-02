#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-late-skip-jump-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int f(p, q, a, b, c, d, e, fv)
volatile int *p;
volatile int *q;
int a, b, c, d, e, fv;
{
    int s0, s1, s2, x;

    s0 = a + b;
    s1 = c + d;
    s2 = e + fv;
    x = *p;
    if (x != 0)
        return x + s0 + s2;
    return *q + s1 + s2;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

if ! grep -Eq '^[[:space:]]*jumpe[[:space:]]+[0-9]+,' "$ASM"; then
    echo "late SKIP/JRST fold did not produce a JUMPE" >&2
    exit 1
fi

if awk '
$1 == "skipn" {
    split($2, ac, ",")
    same = (ac[1] != "" && ac[1] == ac[2])
    next
}
same && $1 == "jrst" { exit 1 }
{ same = 0 }
END { if (same && $1 == "jrst") exit 1 }
' "$ASM"; then
    :
else
    echo "late same-AC SKIPN/JRST pair remains" >&2
    exit 1
fi

echo "late skip/jump regression passed"

