#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-constant-branch-chain-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
extern int side(void);
volatile int sink;

int signed_chain(void)
{
    int a;
    a = -3;
    if (a < 0) sink += 1; else return 11;
    if (a <= -3) sink += 2; else return 12;
    if (a != 3) sink += 4; else return 13;
    if (3 >= a) sink += 8; else return 14;
    return 0;
}

int unsigned_chain(void)
{
    unsigned int u;
    u = 0400000000000U;
    if (u > 1U) sink += 1; else return 21;
    if (u >= 0400000000000U) sink += 2; else return 22;
    if (u != 1U) sink += 4; else return 23;
    return 0;
}

int write_barrier(void)
{
    int a;
    a = 3;
    if (a == 3) a = 4;
    if (a == 3) return 1;
    return 0;
}

int pointer_barrier(void)
{
    int a, *p;
    p = &a;
    a = 3;
    if (a == 3) *p = 4;
    if (a == 3) return 1;
    return 0;
}

int call_barrier(void)
{
    int a;
    a = 3;
    if (a == 3) side();
    if (a == 3) return 1;
    return 0;
}

int escape_barrier(void)
{
    int a, *p;
    a = 3;
    if (a == 3) p = &a;
    if (a == 3) return p != 0;
    return 0;
}
SRC

for cpu in pdp6 ka10 pdp10; do
    d="$TMP/$cpu"
    mkdir "$d"
    cp "$TMP/test.c" "$d/test.c"
    (cd "$d" && "$KCC" -x="$cpu" -D__PDP10__ -S test.c >/dev/null)
    asm="$d/test.s"

    for fn in signed_chain unsigned_chain; do
        body=$(awk -v f="$fn" '$0 == f ":" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$asm")
        if printf '%s\n' "$body" | grep -Eq 'cai|cam|jump|skip'; then
            echo "$cpu: $fn retained a constant comparison" >&2
            exit 1
        fi
    done

    for fn in write_barrier pointer_barrier call_barrier escape_barrier; do
        body=$(awk -v f="$fn" '$0 == f ":" {p=1; next} /^[A-Za-z_][A-Za-z0-9_]*:/ {if(p) exit} p' "$asm")
        if ! printf '%s\n' "$body" | grep -Eq 'cai|cam|jump|skip'; then
            echo "$cpu: $fn crossed a required branch barrier" >&2
            exit 1
        fi
    done
done

echo "constant branch-chain regression passed"
