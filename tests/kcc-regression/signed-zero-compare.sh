#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-signed-zero-compare-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int ne0(int x) { return x != 0; }
int lt0(int x) { return x < 0; }
int le0(int x) { return x <= 0; }
int gt0(int x) { return x > 0; }
int ge0(int x) { return x >= 0; }
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

for op in skipn skipl skiple skipg skipge; do
    grep -Eq "^[[:space:]]*$op[[:space:]]+[0-7]+,[0-7]+[[:space:]]*$" "$ASM"
done

if grep -Eiq '^[[:space:]]*(setz|cam[e-ngl]*)[[:space:]]' "$ASM"; then
    echo "signed zero comparison materialized a zero AC" >&2
    exit 1
fi

echo "signed zero comparison regression passed"
