#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-dead-rhs-scratch-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
typedef long long Dint;

Dint addpair(a, b)
Dint a, b;
{
    return a + b;
}

Dint subpair(a, b)
Dint a, b;
{
    return a - b;
}
SRC

(cd "$TMP" && "$KCC" -x=ki10 -S test.c >/dev/null)

# Carry and borrow are derived directly from the canonical 35-bit low word.
# There must be no dedicated carry AC setup or -43 extraction sequence.
grep -q 'DIADD' "$TMP/test.s"
grep -q 'DISUB' "$TMP/test.s"
if grep -q 'SETZ' "$TMP/test.s"; then
    echo 'DImode add/sub still allocates a carry/borrow scratch AC' >&2
    exit 1
fi
if grep -q 'LSH.*-43' "$TMP/test.s"; then
    echo 'DImode add still extracts carry through a scratch AC' >&2
    exit 1
fi

echo 'DImode scratch-free carry/borrow regression passed'
