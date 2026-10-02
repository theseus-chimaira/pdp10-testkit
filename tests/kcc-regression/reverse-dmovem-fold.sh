#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
TMP=${TMPDIR:-/tmp}/kcc-abi-dmovem-$$
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
    if grep -Eqi '^[[:space:]]*(d?movem)[[:space:]]+[1-4],-?[0-9]+\(17\)' "$asm"; then
        echo "$cpu: read-once DImode ABI pair was reconstructed on stack" >&2
        exit 1
    fi
done
echo 'direct DImode ABI pair prologue regression passed'
