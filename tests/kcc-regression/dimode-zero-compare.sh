#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-zero-compare-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
typedef unsigned long long Uint;
int se(Dint x) { return x == 0; }
int sn(Dint x) { return x != 0; }
int re(Dint x) { return 0 == x; }
int rn(Dint x) { return 0 != x; }
int ue(Uint x) { return x == 0; }
int un(Uint x) { return x != 0; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    mkdir "$TMP/$cpu"
    cp "$TMP/test.c" "$TMP/$cpu/test.c"
    (cd "$TMP/$cpu" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm="$TMP/$cpu/test.s"
    # Six tests must inspect the existing pair directly.  No generated zero
    # pair or CAM comparison should remain.
    test "$(grep -Eic '^[[:space:]]*skipn[[:space:]]+' "$asm")" -ge 6
    test "$(grep -Eic '^[[:space:]]*skipe[[:space:]]+' "$asm")" -ge 6
    if grep -Eiq '^[[:space:]]*cam(e|n)[[:space:]]+' "$asm"; then
        echo "$cpu: DImode zero comparison still materializes a second pair" >&2
        exit 1
    fi
done
echo 'DImode zero-comparison regression passed'
