#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-signed-div-power2-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
Dint d2(Dint x) { return x / 2; }
Dint d8(Dint x) { return x / 8; }
Dint d34(Dint x) { return x / 17179869184LL; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    if grep -q 'DIDIV' "$TMP/test.s"; then
        echo "signed power-of-two division used general divider on $cpu" >&2
        exit 1
    fi
    grep -Eiq '^[[:space:]]*ashc[[:space:]]+[^,]+,-1$' "$TMP/test.s"
    grep -Eiq '^[[:space:]]*ashc[[:space:]]+[^,]+,-3$' "$TMP/test.s"
    grep -Eiq '^[[:space:]]*ashc[[:space:]]+[^,]+,-42$' "$TMP/test.s"
    test "$(grep -Eic '^[[:space:]]*jumpge[[:space:]]' "$TMP/test.s")" -ge 3
    test "$(grep -Eic '^[[:space:]]*tlze[[:space:]].*,400000$' "$TMP/test.s")" -ge 3
done
echo 'signed DImode power-of-two division regression passed'
