#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
: "${TMPDIR:?TMPDIR must be set}"
TMP=$TMPDIR/kcc-direct-assignment-store-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
extern int g;
typedef long long D;
D gd;
static D sd;

int put(int a)
{
    g = a;
    return 0;
}

D global_store(D x, D m)
{
    return (gd = x & m);
}

D static_store(D x)
{
    return (sd = x);
}

D auto_store(D x)
{
    D a;
    return (a = x);
}

D arg_store(D x, D y)
{
    return (y = x);
}
SRC

for cpu in pdp6 ka10 ki10 ks10; do
    d=$TMP/$cpu
    mkdir "$d"
    cp "$TMP/test.c" "$d/test.c"
    (
        cd "$d"
        "$KCC" -x="$cpu" -D__PDP10__ -S test.c >/dev/null
    )
    ASM=$d/test.s

    if [ "$cpu" = pdp6 ]; then
        put_body=$(sed -n '/^put:/,/^global_store:/p' "$ASM")
        printf '%s\n' "$put_body" | grep -Eq 'movem[[:space:]]+1,g'
        if printf '%s\n' "$put_body" | grep -Eq 'move[[:space:]]+[2-7],1'; then
            echo "discarded register assignment used an avoidable temporary" >&2
            exit 1
        fi
    fi

    if grep -Eq '^[[:space:]]*movei[[:space:]]+[1-7],gd$' "$ASM"; then
        echo "$cpu: DImode global store materialized gd in an AC" >&2
        exit 1
    fi

    if [ "$cpu" = pdp6 ] || [ "$cpu" = ka10 ]; then
        grep -Eq '^[[:space:]]*movem[[:space:]]+[1-7],gd$' "$ASM"
        grep -Eq '^[[:space:]]*movem[[:space:]]+[1-7],gd\+1$' "$ASM"
    else
        grep -Eq '^[[:space:]]*dmovem[[:space:]]+[1-7],gd$' "$ASM"
    fi
done

echo "direct assignment store regression passed"
