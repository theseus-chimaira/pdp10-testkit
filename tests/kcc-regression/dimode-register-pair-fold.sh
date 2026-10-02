#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-regpair-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
: "${KCC:=$(pwd)/kcc}"
cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;
Dint addpair(Dint a, Dint b) { return a + b; }
Dint loadpair(Dint *p) { return *p; }
SRC
for cpu in ki10 ka10; do
    (cd "$TMP" && "$KCC" -S -v=nostats -x="$cpu" -R="test-$cpu" test.c)
    asm="$TMP/test-$cpu.s"
    grep -q 'DIADD' "$asm"
    if grep -Eqi '^[[:space:]]*(d?movem)[[:space:]]+[1-4],-?[0-9]+\(17\)' "$asm"; then
        echo "$cpu: direct DImode argument pair was stored to the stack" >&2
        exit 1
    fi
    grep -Eqi '^[[:space:]]*(dmove|move)[[:space:]].*,.*\(' "$asm"
done
echo 'DImode direct register-pair regression passed'
