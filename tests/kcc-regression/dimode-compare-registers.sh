#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-compare-registers-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
typedef unsigned long long Uint;
int slt(a, b) Dint a, b; { return a < b; }
int sle(a, b) Dint a, b; { return a <= b; }
int ult(a, b) Uint a, b; { return a < b; }
int ule(a, b) Uint a, b; { return a <= b; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    mkdir "$TMP/$cpu"
    cp "$TMP/test.c" "$TMP/$cpu/test.c"
    (cd "$TMP/$cpu" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm="$TMP/$cpu/test.s"
    if grep -Eq '^[[:space:]]*PUSH[[:space:]]+17,[234567]([[:space:]]|$)' "$asm"; then
        echo "$cpu: DImode comparison still spills an operand pair" >&2
        exit 1
    fi
    awk '
        $1 == "JUMPN" { jumps++ }
        $1 == "CAML" || $1 == "CAMLE" { cmps++ }
        END { exit !(jumps >= 4 && cmps >= 4) }
    ' "$asm"
done
echo 'DImode register comparison regression passed'
