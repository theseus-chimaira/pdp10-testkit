#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-bitwise-registers-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
Dint aand(a,b) Dint a,b; { return a & b; }
Dint oor(a,b) Dint a,b; { return a | b; }
Dint xxor(a,b) Dint a,b; { return a ^ b; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
  mkdir "$TMP/$cpu"
  cp "$TMP/test.c" "$TMP/$cpu/test.c"
  (cd "$TMP/$cpu" && "$KCC" -x="$cpu" -S test.c >/dev/null)
  asm="$TMP/$cpu/test.s"
  for op in AND IOR XOR; do
    n=$(awk -v op="$op" '$1 == op { n++ } END { print n+0 }' "$asm")
    [ "$n" -eq 2 ] || { echo "$cpu: expected two $op instructions, found $n" >&2; exit 1; }
  done
  if grep -q 'SUB[[:space:]]*17,\[2,,2\]' "$asm"; then
    echo "$cpu: DImode bitwise operation still spills through stack temporaries" >&2
    exit 1
  fi
done
echo 'DImode register-resident bitwise regression passed'
