#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/kcc-target-variants-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat > "$tmp/macros.c" <<'SRC'
#if !TARGET_ITS
# error wrong ITS target macro
#endif
int variant_probe;
SRC

cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=ka10+its macros.c
TERM=dumb "$KCC" -S -v=nostats -x=kl10+its macros.c
TERM=dumb "$KCC" -S -v=nostats -x=ks10+its macros.c

if TERM=dumb "$KCC" -S -v=nostats -x=klx macros.c >bad.out 2>&1; then
    echo "klx unexpectedly accepted by a non-MULTI_SECTION build" >&2
    exit 1
fi
grep -q 'KL10 non-zero-section target requires MULTI_SECTION compiler build' bad.out

if TERM=dumb "$KCC" -S -v=nostats -x=ki10+its macros.c >bad.out 2>&1; then
    echo "ki10+its unexpectedly accepted" >&2
    exit 1
fi
grep -q 'ITS target variant requires' bad.out

cat > circ.c <<'SRC'
int f(unsigned long *pair, unsigned long *result, int count)
{
    return imuuo("CIRC", pair, result, count, 0);
}
SRC
TERM=dumb "$KCC" -S -v=nostats -x=ka10+its circ.c
grep -Eiq '^[[:space:]]*circ[[:space:]]+[0-7]+,0\([0-7]+\)' circ.s
if grep -Eiq '^[[:space:]]*tdza[[:space:]]' circ.s; then
    echo "CIRC incorrectly used monitor-call skip convention" >&2
    exit 1
fi
if TERM=dumb "$KCC" -S -v=nostats -x=ka10 circ.c >bad.out 2>&1; then
    echo "CIRC unexpectedly accepted without ITS" >&2
    exit 1
fi
grep -q 'CIRC requires an ITS target variant' bad.out

echo "target variant regression passed"
