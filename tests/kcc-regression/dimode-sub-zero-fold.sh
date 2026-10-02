#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-sub-zero-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
typedef unsigned long long Uint;
Dint ss(Dint x) { return x - 0LL; }
Uint us(Uint x) { return x - 0ULL; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    mkdir "$TMP/$cpu"
    cp "$TMP/test.c" "$TMP/$cpu/test.c"
    (cd "$TMP/$cpu" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm="$TMP/$cpu/test.s"
    if grep -q '%DISUB' "$asm"; then
        echo "$cpu: subtraction by DImode zero was not eliminated" >&2
        exit 1
    fi
done
echo 'DImode subtraction-by-zero regression passed'
