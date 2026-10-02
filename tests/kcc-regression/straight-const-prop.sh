#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-straight-const-prop-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
extern int side(void);
volatile int vg;

int chain(void)
{
    int a, b;
    a = -3;
    b = a + 5;
    if (b == 2)
        return 7;
    return 9;
}

int reassignment(void)
{
    int a;
    a = 1;
    a = 4;
    if (a == 4)
        return 1;
    return 0;
}

int call_barrier(void)
{
    int a;
    a = 3;
    side();
    if (a == 3)
        return 1;
    return 0;
}

int pointer_barrier(void)
{
    int a;
    int *p;
    p = &a;
    a = 3;
    *p = 4;
    if (a == 3)
        return 1;
    return 0;
}

int volatile_barrier(void)
{
    int a;
    a = 3;
    if (vg && a == 3)
        return 1;
    return 0;
}
SRC

for cpu in pdp6 ka10 pdp10; do
    d="$TMP/$cpu"
    mkdir "$d"
    cp "$TMP/test.c" "$d/test.c"
    (cd "$d" && "$KCC" -x="$cpu" -D__PDP10__ -S test.c >/dev/null)
    asm="$d/test.s"

    chain=$(awk '$0 == "chain:" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$asm")
    printf '%s\n' "$chain" | grep -Eq 'movei[[:space:]]+1,7'
    if printf '%s\n' "$chain" | grep -Eq 'cai|cam|jrst[[:space:]]+%L'; then
        echo "$cpu: constant chain retained comparison/control flow" >&2
        exit 1
    fi

    reassign=$(awk '$0 == "reassignment:" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$asm")
    printf '%s\n' "$reassign" | grep -Eq 'movei[[:space:]]+1,1'
    if printf '%s\n' "$reassign" | grep -Eq 'cai|cam'; then
        echo "$cpu: reassigned constant was not propagated" >&2
        exit 1
    fi

    for fn in call_barrier pointer_barrier volatile_barrier; do
        body=$(awk -v f="$fn" '$0 == f ":" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$asm")
        if ! printf '%s\n' "$body" | grep -Eq 'cai|cam|jump|skip'; then
            echo "$cpu: $fn crossed a required propagation barrier" >&2
            exit 1
        fi
    done
done

echo "straight-line constant propagation regression passed"
