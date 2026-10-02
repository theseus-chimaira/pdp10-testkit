#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

TOP=$(cd "$(dirname "$0")/.." && pwd)
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-return-register-chain-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
unsigned long
shift1(x)
unsigned long x;
{
    return x << 1;
}

unsigned long
shift_add_self(x)
unsigned long x;
{
    return (x << 1) + x;
}

unsigned long
shift_add_other(x, y)
unsigned long x;
unsigned long y;
{
    return (x << 1) + y;
}

unsigned long
shift_xor(x)
unsigned long x;
{
    return (x >> 3) ^ 5;
}

long
ash_add(x)
long x;
{
    return (x >> 2) + 1;
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

# A return-only temporary should be renamed back into AC1.
if ! block shift1 | grep -Eiq 'lsh[[:space:]]+1,1'; then
    echo "return shift was not generated directly in AC1" >&2
    exit 1
fi
if block shift1 | grep -Eiq 'move[[:space:]]+[0-7]+,1|move[[:space:]]+1,[0-7]+'; then
    echo "return shift still contains temporary MOVE traffic" >&2
    exit 1
fi

# If AC1 is still needed as an input, changereg must refuse the rewrite.
if ! block shift_add_self | grep -Eiq 'move[[:space:]]+[0-7]+,1'; then
    echo "live AC1 input was incorrectly overwritten" >&2
    exit 1
fi

# AC1 may be reused when only the other argument remains live.
if ! block shift_add_other | grep -Eiq 'lsh[[:space:]]+1,1'; then
    echo "safe two-argument return chain was not renamed to AC1" >&2
    exit 1
fi

if ! block shift_xor | grep -Eiq 'lsh[[:space:]]+1,-3'; then
    echo "multi-op return chain was not renamed to AC1" >&2
    exit 1
fi
if ! block ash_add | grep -Eiq 'ash[[:space:]]+1,-2'; then
    echo "signed return chain was not renamed to AC1" >&2
    exit 1
fi

echo "return register chain regression passed"
