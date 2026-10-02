#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMPBASE=${TMPDIR:-/tmp}
TMP=$TMPBASE/kcc-dimode-wide-identity-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef long long S;
typedef unsigned long long U;
S sd35(S x) { return x / 0x800000000LL; }
S sd36(S x) { return x / 0x1000000000LL; }
S sd70(S x) { return x / 0x400000000000000000LL; }
U ud35(U x) { return x / 0x800000000ULL; }
U um35(U x) { return x % 0x800000000ULL; }
U and35(U x) { return x & 0x800000000ULL; }
U or35(U x) { return x | 0x800000000ULL; }
U xor35(U x) { return x ^ 0x800000000ULL; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    dir="$TMP/$cpu"
    mkdir -p "$dir"
    cp "$TMP/test.c" "$dir/test.c"
    (cd "$dir" && "$KCC" -x="$cpu" -S test.c >out 2>err)
    if grep -qi 'division by zero' "$dir/err"; then
        echo "wide constant was mistaken for zero on $cpu" >&2
        exit 1
    fi
    test -s "$dir/test.s"
    grep -Eiq '^[[:space:]]*LSHC[[:space:]]+[^,]+,-43$' "$dir/test.s"
    grep -Eiq '^[[:space:]]*LSHC[[:space:]]+[^,]+,-44$' "$dir/test.s"
    grep -Eiq '^[[:space:]]*LSHC[[:space:]]+[^,]+,-106$' "$dir/test.s"
    if grep -q 'lshc[[:space:]].*,-1' "$dir/test.s"; then
        echo "wide divisor was mistaken for two on $cpu" >&2
        exit 1
    fi
done
echo 'DImode normalized wide identity regression passed'
