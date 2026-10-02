#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-unsigned-wide-power2-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef unsigned long long U;
U d35(U x) { return x / (1ULL << 35); }
U d36(U x) { return x / (1ULL << 36); }
U d70(U x) { return x / (1ULL << 70); }
U m35(U x) { return x % (1ULL << 35); }
U m36(U x) { return x % (1ULL << 36); }
U m70(U x) { return x % (1ULL << 70); }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm=$TMP/test.s
    grep -Eiq '^[[:space:]]*LSHC[[:space:]]+[^,]+,-43$' "$asm"
    grep -Eiq '^[[:space:]]*LSHC[[:space:]]+[^,]+,-44$' "$asm"
    grep -Eiq '^[[:space:]]*LSHC[[:space:]]+[^,]+,-106$' "$asm"
    grep -Eiq '^[[:space:]]*SETZ[[:space:]]+[^,]+,$' "$asm"
    grep -Eiq '^[[:space:]]*AND[[:space:]]+[^,]+,\[1\]$' "$asm"
    grep -Eiq '^[[:space:]]*AND[[:space:]]+[^,]+,\[377777777777\]$' "$asm"
    if grep -Eq '%DI[VQMR]|^[[:space:]]*(PUSH|POP)[[:space:]]+17,[0-9]+$' "$asm"; then
        echo "wide unsigned power-of-two operation used divider state on $cpu" >&2
        exit 1
    fi
done
echo 'unsigned DImode wide power-of-two division/remainder regression passed'
