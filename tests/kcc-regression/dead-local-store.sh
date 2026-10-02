#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dead-local-store-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int dead_scalar(void)
{
    int x;
    x = 012345;
    return 7;
}

int dead_wide(void)
{
    long long x;
    x = 012345670123LL;
    return 7;
}

long long live_wide(void)
{
    long long x;
    x = 012345670123LL;
    return x;
}

void volatile_wide(void)
{
    volatile long long x;
    x = 012345670123LL;
}

int addressed_wide(void)
{
    long long x;
    long long *p;
    p = &x;
    x = 012345670123LL;
    return p != 0;
}

int used_result(void)
{
    int x;
    return (x = 012345) == 012345;
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

for cpu in pdp6 ka10 pdp10; do
    d="$TMP/$cpu"
    mkdir "$d"
    cp "$TMP/test.c" "$d/test.c"
    (cd "$d" && "$KCC" -x="$cpu" -D__PDP10__ -S test.c >/dev/null)
    asm="$d/test.s"

    if body dead_scalar "$asm" | grep -Eiq '12345|movem'; then
        echo "$cpu: dead scalar assignment survived" >&2
        exit 1
    fi
    if body dead_wide "$asm" | grep -Eiq '12345670123|movem'; then
        echo "$cpu: dead two-word assignment survived" >&2
        exit 1
    fi
    if ! body live_wide "$asm" | grep -Eiq 'movem'; then
        echo "$cpu: live two-word assignment was removed" >&2
        exit 1
    fi
    if ! body volatile_wide "$asm" | grep -Eiq 'movem'; then
        echo "$cpu: volatile two-word assignment was removed" >&2
        exit 1
    fi
    if ! body addressed_wide "$asm" | grep -Eiq 'movem'; then
        echo "$cpu: address-taken two-word assignment was removed" >&2
        exit 1
    fi
    if ! body used_result "$asm" | grep -Eq '12345'; then
        echo "$cpu: used assignment result was removed" >&2
        exit 1
    fi
done

echo "dead local store regression passed"
