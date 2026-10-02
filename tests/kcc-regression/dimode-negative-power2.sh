#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

TMP=${TMPDIR:-/tmp}/kcc-dimode-negative-power2-$$
mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

cat > "$TMP/test.c" <<'SRC'
long long d1(long long x) { return x / -2LL; }
long long d34(long long x) { return x / -(1LL << 34); }
long long d35(long long x) { return x / -(1LL << 35); }
long long d36(long long x) { return x / -(1LL << 36); }
long long d70(long long x) { return x / -(1LL << 70); }
long long m1(long long x) { return x % -2LL; }
long long m34(long long x) { return x % -(1LL << 34); }
long long m35(long long x) { return x % -(1LL << 35); }
long long m36(long long x) { return x % -(1LL << 36); }
long long m70(long long x) { return x % -(1LL << 70); }
SRC

KCC=$PDP10_PREFIX/bin/kcc
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm=$TMP/test.s
    if grep -Eq '%DIDIV|^[[:space:]]*(PUSH|POP)[[:space:]]+17,[0-9]+$' "$asm"; then
        echo "negative power-of-two operation used general divider on $cpu" >&2
        exit 1
    fi
    grep -Eiq '^[[:space:]]*ASHC[[:space:]]+[^,]+,-1$' "$asm"
    grep -Eiq '^[[:space:]]*ASHC[[:space:]]+[^,]+,-42$' "$asm"
    grep -Eiq '^[[:space:]]*ASHC[[:space:]]+[^,]+,-43$' "$asm"
    grep -Eiq '^[[:space:]]*ASHC[[:space:]]+[^,]+,-44$' "$asm"
    grep -Eiq '^[[:space:]]*ASHC[[:space:]]+[^,]+,-106$' "$asm"
    # Five quotient functions must negate their folded positive-power result.
    n=$(grep -Eic '^[[:space:]]*MOVN[[:space:]]+' "$asm")
    [ "$n" -ge 5 ] || {
        echo "negative power-of-two quotients were not negated on $cpu" >&2
        exit 1
    }
done

echo 'negative DImode power-of-two division/remainder regression passed'
