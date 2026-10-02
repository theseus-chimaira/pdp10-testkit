#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

TMP=${TMPDIR:-/tmp}/kcc-dimode-signed-wide-power2-$$
mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

cat > "$TMP/test.c" <<'SRC'
long long d35(long long x) { return x / (1LL << 35); }
long long d36(long long x) { return x / (1LL << 36); }
long long d70(long long x) { return x / (1LL << 70); }
long long m35(long long x) { return x % (1LL << 35); }
long long m36(long long x) { return x % (1LL << 36); }
long long m70(long long x) { return x % (1LL << 70); }
SRC

KCC=$PDP10_PREFIX/bin/kcc
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm=$TMP/test.s
    if grep -Eq '%DI[VQMR]|^[[:space:]]*(PUSH|POP)[[:space:]]+17,[0-9]+$' "$asm"; then
        echo "signed wide power-of-two operation used general divider on $cpu" >&2
        exit 1
    fi
    grep -Eiq '^[[:space:]]*ASHC[[:space:]]+[^,]+,-43$' "$asm"
    grep -Eiq '^[[:space:]]*ASHC[[:space:]]+[^,]+,-44$' "$asm"
    grep -Eiq '^[[:space:]]*ASHC[[:space:]]+[^,]+,-106$' "$asm"
    grep -Eiq '^[[:space:]]*AND[[:space:]]+[^,]+,\[1\]$' "$asm"
    grep -Eiq '^[[:space:]]*AND[[:space:]]+[^,]+,\[377777777777\]$' "$asm"
done

echo 'signed DImode wide power-of-two division/remainder regression passed'
