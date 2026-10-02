#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-wide-literal-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef unsigned long long U;
typedef long long S;
U b34m1(void) { return 0x3ffffffffULL; }
U b34(void) { return 0x400000000ULL; }
U b35m1(void) { return 0x7ffffffffULL; }
U b35(void) { return 0x800000000ULL; }
U b36(void) { return 0x1000000000ULL; }
U b70(void) { return 0x400000000000000000ULL; }
U b70m1(void) { return 0x3fffffffffffffffffULL; }
U b70dec(void) { return 1180591620717411303424ULL; }
S n70(void) { return -0x400000000000000000LL; }
U cast70(void) { return (U)0x400000000000000000ULL; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    dir="$TMP/$cpu"
    mkdir -p "$dir"
    cp "$TMP/test.c" "$dir/test.c"
    (cd "$dir" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm="$dir/test.s"
    grep -Eiq 'move[i]?[[:space:]]+1,\[?0?377777777777\]?' "$asm"
    grep -Eiq 'move[i]?[[:space:]]+2,\[?0?377777777777\]?' "$asm"
    grep -Eiq 'movsi[[:space:]]+1,0?400000' "$asm"
    count=$(grep -Eic 'movsi[[:space:]]+1,0?400000' "$asm")
    test "$count" -ge 4
    grep -Eiq 'move[[:space:]]+1,\[0?377777777777\]' "$asm"
    grep -Eiq 'move[[:space:]]+2,\[0?377777777777\]' "$asm"
done
echo 'DImode wide literal parsing regression passed'
