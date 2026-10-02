#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-hllz-late-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
unsigned long highmask(unsigned long *p)
{
    unsigned long x;

    x = *p;
    return x & 0777777000000UL;
}
SRC

(
    cd "$TMP"
    "$KCC" -S test.c >/dev/null
)
ASM=$TMP/test.s

body=$(awk '
    $0 == "highmask:" { in_fn = 1; next }
    in_fn && /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
    in_fn { print }
' "$ASM")

printf '%s\n' "$body" | grep -Eiq 'hllz[[:space:]]+[0-7]+,0\([0-7]+\)'
if printf '%s\n' "$body" | grep -Eiq 'trz[[:space:]]+[0-7]+,777777'; then
    echo "left-half mask retained TRZ" >&2
    exit 1
fi

echo "late HLLZ fold regression passed"
