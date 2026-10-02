#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-rotate-idiom-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
unsigned long rotv(x, n)
unsigned long x;
int n;
{
    return (x << n) | (x >> (36 - n));
}

unsigned long rot5(x)
unsigned long x;
{
    return (x << 5) | (x >> 31);
}

unsigned long rotrv(x, n)
unsigned long x;
int n;
{
    return (x >> n) | (x << (36 - n));
}

unsigned long rotr5(x)
unsigned long x;
{
    return (x >> 5) | (x << 31);
}

volatile unsigned long vx;

unsigned long rotvol(n)
int n;
{
    return (vx << n) | (vx >> (36 - n));
}

long rotsigned(x, n)
long x;
int n;
{
    return (x << n) | (x >> (36 - n));
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

block()
{
    awk -v name="$1" '
        $0 == name ":" { found = 1; next }
        found && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
        found { print }
    ' "$ASM"
}

if [ "$(block rotv | grep -ci 'rot[[:space:]]')" -ne 1 ]; then
    echo "variable rotate idiom was not folded to one ROT" >&2
    exit 1
fi

if ! block rot5 | grep -Eiq 'rot[[:space:]]+[0-7]+,5'; then
    echo "constant rotate-left idiom was not folded to ROT R,5" >&2
    exit 1
fi

if [ "$(block rotrv | grep -ci 'rot[[:space:]]')" -ne 1 ]   || [ "$(block rotrv | grep -ci 'movn[[:space:]]')" -ne 1 ]; then
    echo "variable rotate-right idiom was not folded to MOVN + ROT" >&2
    exit 1
fi

if ! block rotr5 | grep -Eiq 'rot[[:space:]]+[0-7]+,0?37'; then
    echo "constant rotate-right idiom was not folded to one ROT" >&2
    exit 1
fi

if block rotvol | grep -Eiq 'rot[[:space:]]'; then
    echo "volatile rotate expression was incorrectly folded" >&2
    exit 1
fi

if block rotsigned | grep -Eiq 'rot[[:space:]]'; then
    echo "signed-right-shift expression was incorrectly folded" >&2
    exit 1
fi

echo "rotate idiom regression passed"
