#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-loop-induction-address-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
volatile int sink;
extern void use_word(int);

int simple(int a)
{
    int v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
        v[i] = a + i;
        s += v[i];
    }
    return s;
}

int with_continue(int a)
{
    int v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
        if (i == 2)
            continue;
        v[i] = a + i;
        s += v[i];
    }
    return s;
}

int branch_calls(int a)
{
    int v[6];
    int expect[6];
    int i;
    for (i = 0; i < 6; ++i) {
        if (v[i] != expect[i]) {
            use_word(v[i]);
            use_word(expect[i]);
        }
    }
    return a;
}

int body_write(int a)
{
    int v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
        v[i] = a;
        if (a)
            ++i;
        s += v[i];
    }
    return s;
}

int address_taken(int a)
{
    int v[6];
    int i, s = 0;
    int *q = &i;
    for (i = 0; i < 6; ++i) {
        v[i] = a;
        s += v[i];
    }
    sink = *q;
    return s;
}

int volatile_array(int a)
{
    volatile int v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
        v[i] = a;
        s += v[i];
    }
    return s;
}

int byte_array(int a)
{
    char v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
        v[i] = a;
        s += v[i];
    }
    return s;
}

int stride_two(int a)
{
    int v[6];
    int i, s = 0;
    for (i = 0; i < 6; i += 2) {
        v[i] = a;
        s += v[i];
    }
    return s;
}

int labelled(int a)
{
    int v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
again:
        v[i] = a;
        s += v[i];
        if (s == -1)
            goto again;
    }
    return s;
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

    for fn in simple with_continue; do
        text=$(body "$fn" "$asm")
        printf '%s\n' "$text" | grep -Eq 'addi[[:space:]]+[0-7]+,1'
        nbase=$(printf '%s\n' "$text" | grep -Ec 'movei[[:space:]]+[0-7]+,-[0-9]+\(17\)' || true)
        test "$nbase" -le 1 || {
            echo "$cpu: $fn still rebuilds local array base" >&2
            exit 1
        }
    done

    for fn in body_write address_taken volatile_array byte_array stride_two labelled branch_calls; do
        text=$(body "$fn" "$asm")
        if printf '%s\n' "$text" | grep -Eq 'addi[[:space:]]+[0-7]+,1'; then
            echo "$cpu: $fn incorrectly strength-reduced" >&2
            exit 1
        fi
    done
done

echo "loop induction address strength-reduction regression passed"
