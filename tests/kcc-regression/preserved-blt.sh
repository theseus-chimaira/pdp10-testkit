#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-preserved-blt-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
extern int sink4(int, int, int, int);
extern void usep(int *);

int keep4(int a, int b, int c, int d)
{
    int x = a + 1;
    int y = b + 2;
    int z = c + 3;
    int w = d + 4;

    sink4(a, b, c, d);
    return x + y + z + w + a + b + c + d;
}

int keep3(int a, int b, int c)
{
    int x = a + 1;
    int y = b + 2;
    int z = c + 3;

    sink4(a, b, c, 0);
    return x + y + z + a + b + c;
}

int keep4_auto(int a, int b, int c, int d)
{
    int local;

    usep(&local);
    sink4(a, b, c, d);
    return a + b + c + d + local;
}
SRC

(
    cd "$TMP"
    "$KCC" -S test.c >/dev/null
)
ASM=$TMP/test.s

body()
{
    name=$1
    awk -v name="$name" '
        $0 == name ":" { in_fn = 1; next }
        in_fn && /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
        in_fn { print }
    ' "$ASM"
}

keep4=$(body keep4)
keep3=$(body keep3)
keep4_auto=$(body keep4_auto)

printf '%s\n' "$keep4" | grep -q 'BLT[[:space:]]*0,13'
printf '%s\n' "$keep4" | grep -q 'MOVEI[[:space:]]*0,10'
printf '%s\n' "$keep4" | grep -q 'HRLI[[:space:]]*0,'
if printf '%s\n' "$keep4" | grep -q 'move[[:space:]]*10,-'; then
    echo "keep4: four-register epilogue used scalar restore" >&2
    exit 1
fi

if printf '%s\n' "$keep3" | grep -q 'BLT[[:space:]]'; then
    echo "keep3: three-register epilogue should remain scalar" >&2
    exit 1
fi
printf '%s\n' "$keep3" | grep -q 'move[[:space:]]*10,-'
printf '%s\n' "$keep3" | grep -q 'move[[:space:]]*11,-'
printf '%s\n' "$keep3" | grep -q 'move[[:space:]]*12,-'

printf '%s\n' "$keep4_auto" | grep -q 'adjsp[[:space:]]*17,5'
printf '%s\n' "$keep4_auto" | grep -q 'MOVEI[[:space:]]*0,-4(17)'
printf '%s\n' "$keep4_auto" | grep -q 'HRLI[[:space:]]*0,10'
printf '%s\n' "$keep4_auto" | grep -q 'BLT[[:space:]]*0,-1(17)'
if printf '%s\n' "$keep4_auto" | grep -q 'push[[:space:]]*17,1[0-3]'; then
    echo "keep4_auto: prologue used scalar preserved-register saves" >&2
    exit 1
fi

echo "preserved register BLT save/restore regression passed"
