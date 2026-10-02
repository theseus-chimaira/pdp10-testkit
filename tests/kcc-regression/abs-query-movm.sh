#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-abs-query-movm-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int f(x)
int x;
{
    return x < 0 ? -x : x;
}

int g(x)
int x;
{
    return 0 > x ? -x : x;
}

volatile int vv;
int vf()
{
    return vv < 0 ? -vv : vv;
}

unsigned int uf(x)
unsigned int x;
{
    return x < 0 ? -x : x;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

for fn in f g; do
    body=$(awk -v fn="$fn" '$0 == fn ":" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$ASM")
    printf '%s\n' "$body" | grep -Eq '^[[:space:]]*movm[[:space:]]'
    if printf '%s\n' "$body" | grep -Eq '^[[:space:]]*(jumpge|jumpl|jrst)[[:space:]]'; then
        echo "$fn retained conditional branch around absolute value" >&2
        exit 1
    fi
done

vbody=$(awk '$0 == "vf:" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$ASM")
if printf '%s\n' "$vbody" | grep -Eq '^[[:space:]]*movm[[:space:]]'; then
    echo "volatile absolute-value ternary was incorrectly folded" >&2
    exit 1
fi

ubody=$(awk '$0 == "uf:" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$ASM")
if printf '%s\n' "$ubody" | grep -Eq '^[[:space:]]*movm[[:space:]]'; then
    echo "unsigned ternary was incorrectly folded as signed absolute value" >&2
    exit 1
fi

echo "absolute-value MOVM regression passed"
