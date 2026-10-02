#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-halfword-memory-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
unsigned long low(unsigned long *p)
{
    return *p & 0777777UL;
}

unsigned long high(unsigned long *p)
{
    return (*p >> 18) & 0777777UL;
}

unsigned long shift18(unsigned long *p)
{
    return *p >> 18;
}

unsigned long sink;

void lowreg(unsigned long x)
{
    unsigned long y;

    y = x;
    sink = y & 0777777UL;
}

void highreg(unsigned long x)
{
    unsigned long y;

    y = x;
    sink = (y >> 18) & 0777777UL;
}
SRC

(
    cd "$TMP"
    "$KCC" -S test.c >/dev/null
)
ASM=$TMP/test.s

function_body()
{
    name=$1
    awk -v name="$name" '
        $0 == name ":" { in_fn = 1; next }
        in_fn && /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
        in_fn { print }
    ' "$ASM"
}

low_body=$(function_body low)
high_body=$(function_body high)
shift18_body=$(function_body shift18)
lowreg_body=$(function_body lowreg)
highreg_body=$(function_body highreg)

printf '%s\n' "$low_body" | grep -Eq 'hrrz[[:space:]]+[0-7]+,0\(1\)'
printf '%s\n' "$high_body" | grep -Eq 'hlrz[[:space:]]+[0-7]+,0\(1\)'
printf '%s\n' "$shift18_body" | grep -Eq 'hlrz[[:space:]]+[0-7]+,0\(1\)'
if printf '%s\n' "$shift18_body" | grep -Eq 'lsh[[:space:]]+[0-7]+,-22'; then
    echo "18-bit logical shift retained an LSH" >&2
    exit 1
fi
printf '%s\n' "$lowreg_body" | grep -Eq 'hrrz[[:space:]]+[0-7]+,[0-7]+'
printf '%s\n' "$highreg_body" | grep -Eq 'hlrz[[:space:]]+[0-7]+,[0-7]+'

if printf '%s\n%s\n' "$low_body" "$high_body" | grep -Eq 'move[[:space:]]+[0-7]+,0\(1\)'; then
    echo "halfword memory extraction retained a redundant MOVE" >&2
    exit 1
fi

if printf '%s\n' "$lowreg_body" | grep -Eq 'move[[:space:]]+2,10[[:space:]]*$'; then
    echo "right-half register extraction retained a redundant MOVE" >&2
    exit 1
fi
if printf '%s\n' "$highreg_body" | grep -Eq 'move[[:space:]]+2,10[[:space:]]*$'; then
    echo "left-half register extraction retained a redundant MOVE" >&2
    exit 1
fi

echo "halfword memory fold regression passed"
