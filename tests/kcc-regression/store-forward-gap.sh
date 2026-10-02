#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-store-forward-gap-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
extern void side(void);
volatile int vg;
int gh;

int safe_gap(int *p, int x, int y)
{
    *p = x;
    y += 3;
    return *p + y;
}

int memory_barrier(int *p, int x)
{
    *p = x;
    gh = 3;
    return *p;
}

int call_barrier(int *p, int x)
{
    *p = x;
    side();
    return *p;
}

int volatile_barrier(volatile int *p, int x)
{
    *p = x;
    return *p;
}
SRC

body()
{
    awk -v fn="$1" '
        $0 == fn ":" { in_fn = 1; next }
        in_fn && $0 ~ /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
        in_fn { print }
    ' "$2"
}

for cpu in pdp6 ka10 pdp10 ki10; do
    d="$TMP/$cpu"
    mkdir "$d"
    cp "$TMP/test.c" "$d/test.c"
    (cd "$d" && "$KCC" -x="$cpu" -D__PDP10__ -S test.c >/dev/null)
    asm="$d/test.s"

    safe=$(body safe_gap "$asm")
    if printf '%s\n' "$safe" | grep -Eq 'move[[:space:]]+1,0\(1\)'; then
        echo "$cpu: harmless register-only gap retained memory reload" >&2
        exit 1
    fi
    printf '%s\n' "$safe" | grep -Eq 'movem[[:space:]]+[0-7]+,0\(1\)'

    mem=$(body memory_barrier "$asm")
    printf '%s\n' "$mem" | grep -Eq 'move[[:space:]]+1,0\(1\)'

    call=$(body call_barrier "$asm")
    printf '%s\n' "$call" | grep -Eq 'move[[:space:]]+[0-7]+,0\([0-7]+\)'

    vol=$(body volatile_barrier "$asm")
    printf '%s\n' "$vol" | grep -Eq 'move[[:space:]]+[0-7]+,0\([0-7]+\)'
done

echo "one-word store forwarding gap regression passed"
