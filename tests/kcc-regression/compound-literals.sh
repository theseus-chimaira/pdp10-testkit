#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-compound-literals-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;

struct pair {
    int x;
    int y;
};

struct outer {
    int tag;
    struct pair p;
};

static struct pair *file_pair = &(struct pair){ .x = 70, .y = 71 };
static int *file_array = (int[]){ 72, 73, 74 };
static int *file_scalar = &(int){ 75 };

static int member_value(int v)
{
    return (struct pair){ .x = v, .y = v + 1 }.y;
}

static int array_value(int v)
{
    int *p;
    p = (int[]){ v, v + 1, v + 2 };
    return p[2];
}

static int address_value(int v)
{
    struct pair *p;
    p = &(struct pair){ .x = v, .y = v + 3 };
    p->x += 2;
    return p->x + p->y;
}

static int scalar_value(int v)
{
    return (int){ v + 4 };
}


static int ordinary_auto(int v)
{
    struct pair p = { v, v + 1 };
    int a[3] = { v + 2, v + 3, v + 4 };
    return p.y + a[2];
}

static int nested_value(int v)
{
    return (struct outer){ .tag = 1, .p = { .x = v, .y = v + 5 } }.p.y;
}

int main(void)
{
    int i;
    int sum;

    if (member_value(10) != 11) return 1;
    if (array_value(20) != 22) return 2;
    if (address_value(30) != 65) return 3;
    if (scalar_value(40) != 44) return 4;
    if (nested_value(50) != 55) return 5;
    if (ordinary_auto(60) != 125) return 6;
    if (sizeof((int[]){ 1, 2, 3, 4 }) / sizeof(int) != 4) return 7;
    if (file_pair->x != 70 || file_pair->y != 71) return 8;
    if (file_array[0] != 72 || file_array[2] != 74) return 9;
    if (*file_scalar != 75) return 10;
    file_pair->x += 1;
    if (file_pair->x != 71) return 11;

    sum = 0;
    for (i = 0; i < 4; ++i)
        sum += (struct pair){ .x = i, .y = i + 10 }.y;
    if (sum != 46) return 12;

    return 0;
}
SRC

cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=compound t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name compound-literals --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/compound.s" "$KCC_RT" >/dev/null

cat > "$tmp/bad-file.c" <<'SRC'
struct pair { int x; int y; };
int runtime_value;
static struct pair *bad = &(struct pair){ .x = runtime_value, .y = 1 };
SRC
if TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=bad-file \
    "$tmp/bad-file.c" >"$tmp/bad.out" 2>"$tmp/bad.err"; then
    echo 'file-scope compound literal accepted nonconstant initializer' >&2
    exit 1
fi
if grep -q '\[Internal error\]' "$tmp/bad.err"; then
    echo 'file-scope compound literal diagnostic triggered internal error' >&2
    cat "$tmp/bad.err" >&2
    exit 1
fi

printf '%s\n' 'compound literal regression passed'
