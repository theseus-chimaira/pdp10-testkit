#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
TMP=${TMPDIR:-/tmp}/kcc-dimode-address-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
: "${KCC:=$(pwd)/kcc}"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
Dint addpair(Dint a, Dint b) { return a + b; }
SRC
for cpu in ki10 ka10; do
    (cd "$TMP" && "$KCC" -S -v=nostats -x="$cpu" -R="test-$cpu" test.c)
    asm="$TMP/test-$cpu.s"
    grep -q 'DIADD' "$asm"
    if grep -Eqi '^[[:space:]]*(setm|movei)[[:space:]].*\(17\)' "$asm"; then
        echo "$cpu: direct DImode pair still uses a copied stack address" >&2
        exit 1
    fi
done
echo 'DImode direct-pair address elimination regression passed'
