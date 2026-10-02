#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-complement-canonical-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
typedef unsigned long long Uint;
Dint sc(Dint x) { return ~x; }
Uint uc(Uint x) { return ~x; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    mkdir "$TMP/$cpu"
    cp "$TMP/test.c" "$TMP/$cpu/test.c"
    (cd "$TMP/$cpu" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm="$TMP/$cpu/test.s"
    test "$(grep -Eic '^[[:space:]]*setca[[:space:]]+' "$asm")" -eq 4
    if grep -Eiq '^[[:space:]]*xor[[:space:]]+[^,]+,\[377777777777\]' "$asm"; then
        echo "$cpu: complement still omits the duplicated low-word sign bit" >&2
        exit 1
    fi
    if grep -Eiq '^[[:space:]]*and[[:space:]]+[^,]+,\[377777777777\]' "$asm"; then
        echo "$cpu: complement should preserve the low-word invariant directly" >&2
        exit 1
    fi
done
echo 'DImode canonical-complement regression passed'
