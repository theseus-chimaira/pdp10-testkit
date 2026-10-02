#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-negate-inplace-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
Dint negate(a) Dint a; { return -a; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    mkdir "$TMP/$cpu"
    cp "$TMP/test.c" "$TMP/$cpu/test.c"
    (cd "$TMP/$cpu" && "$KCC" -x="$cpu" -S test.c >/dev/null)
    asm="$TMP/$cpu/test.s"
    awk '
        $1 == "MOVN" { movn++ }
        $1 == "SKIPE" { skipe++ }
        $1 == "SUBI" { subi++ }
        $1 == "AND" { andn++ }
        END { exit !(movn >= 2 && skipe >= 1 && subi >= 1 && andn >= 1) }
    ' "$asm"
    if grep -Eq '^[[:space:]]*(SETZ|JUMPE)[[:space:]]+1[,[:space:]]' "$asm"; then
        echo "$cpu: DImode negation still allocates carry scratch AC1" >&2
        exit 1
    fi
done
echo 'DImode in-place negation regression passed'
