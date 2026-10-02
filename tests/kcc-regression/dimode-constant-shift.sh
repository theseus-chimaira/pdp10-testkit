#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-constant-shift-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
typedef unsigned long long Uint;
Dint sl1(Dint x) { return x << 1; }
Dint sl5(Dint x) { return x << 5; }
Dint sr1(Dint x) { return x >> 1; }
Uint ur5(Uint x) { return x >> 5; }
Dint sv(Dint x, int n) { return x << n; }
Dint srv(Dint x, int n) { return x >> n; }
SRC
(cd "$TMP" && "$KCC" -x=ki10 -S test.c >/dev/null)
# Canonical DImode is high36:low35.  Every hardware doubleword shift must
# convert that representation to a contiguous pair and restore it afterward.
grep -Eiq '^[[:space:]]*TLZ[[:space:]]+[^,]+,0400000$' "$TMP/test.s"
grep -Eiq '^[[:space:]]*TRNE[[:space:]]+[^,]+,1$' "$TMP/test.s"
grep -Eiq '^[[:space:]]*LSH[[:space:]]+[^,]+,-1$' "$TMP/test.s"
grep -Eiq '^[[:space:]]*LSH[[:space:]]+[^,]+,1$' "$TMP/test.s"
grep -Eiq '^[[:space:]]*AND[[:space:]]+[^,]+,\[0377777777777\]$' "$TMP/test.s"

# Left and unsigned-right shifts use LSHC; signed right shifts use ASHC.
grep -Eiq '^[[:space:]]*lshc[[:space:]]+[^,]+,0\([^)]*\)$' "$TMP/test.s"
grep -Eiq '^[[:space:]]*ashc[[:space:]]+[^,]+,0\([^)]*\)$' "$TMP/test.s"
echo 'DImode constant-shift regression passed'
