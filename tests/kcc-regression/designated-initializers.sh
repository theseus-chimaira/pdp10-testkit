#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-designated-initializers-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;

struct triple {
    int a;
    int b;
    int c;
};

struct pair {
    int x;
    int y;
};

union choice {
    int scalar;
    struct pair pair;
};

struct bits {
    unsigned int a:3;
    unsigned int b:3;
    int x;
};

struct nested {
    int tag;
    struct pair p;
    struct pair a[3];
    union choice u;
};

static struct triple st = { .c = 3, .a = 1, .b = 2 };
static struct triple cont = { .b = 20, 30 };
static int sparse[6] = { [4] = 9, [1] = 3 };
static int inferred[] = { [3] = 7, 9 };
static char bytes[5] = { [3] = 7 };
static struct bits sbits = { .x = 9 };
static union choice uc = { .pair = { .y = 8, .x = 7 } };
static struct nested chain = {
    .p.y = 21,
    .a[2].x = 22,
    .u.pair.y = 23,
    .tag = 24
};

int main(void)
{
    struct triple au = { .b = 5, .a = 4, .c = 6 };
    int aa[5] = { [2] = 12, [4] = 14 };
    union choice acu = { .pair = { .x = 17, .y = 18 } };
    struct nested achain = {
        .a[1].y = 31,
        .p.x = 32,
        .u.pair.x = 33
    };

    if (st.a != 1 || st.b != 2 || st.c != 3) return 1;
    if (sparse[0] != 0 || sparse[1] != 3 || sparse[2] != 0 ||
        sparse[3] != 0 || sparse[4] != 9 || sparse[5] != 0) return 2;
    if (sizeof(inferred) / sizeof(inferred[0]) != 5) return 3;
    if (inferred[0] != 0 || inferred[1] != 0 || inferred[2] != 0 ||
        inferred[3] != 7 || inferred[4] != 9) return 4;
    if (uc.pair.x != 7 || uc.pair.y != 8) return 5;
    if (au.a != 4 || au.b != 5 || au.c != 6) return 6;
    if (aa[0] != 0 || aa[1] != 0 || aa[2] != 12 || aa[3] != 0 ||
        aa[4] != 14) return 7;
    if (cont.a != 0 || cont.b != 20 || cont.c != 30) return 8;
    if (bytes[0] != 0 || bytes[1] != 0 || bytes[2] != 0 ||
        bytes[3] != 7 || bytes[4] != 0) return 9;
    if (sbits.a != 0 || sbits.b != 0 || sbits.x != 9) return 10;
    if (acu.pair.x != 17 || acu.pair.y != 18) return 11;
    if (chain.tag != 24 || chain.p.x != 0 || chain.p.y != 21) return 12;
    if (chain.a[0].x != 0 || chain.a[2].x != 22 || chain.a[2].y != 0) return 13;
    if (chain.u.pair.x != 0 || chain.u.pair.y != 23) return 14;
    if (achain.p.x != 32 || achain.p.y != 0 || achain.a[1].y != 31) return 15;
    if (achain.u.pair.x != 33 || achain.u.pair.y != 0) return 16;
    return 0;
}
SRC

cd "$tmp"

check_bad()
{
    name=$1
    diagnostic=$2
    src=$3
    cat > "$tmp/$name.c" <<SRC
$src
SRC
    set +e
    TERM=dumb "$KCC" -S -v=nostats "$tmp/$name.c" \
        >"$tmp/$name.out" 2>"$tmp/$name.err"
    status=$?
    set -e
    if test "$status" -eq 0; then
        echo "$name unexpectedly accepted" >&2
        exit 1
    fi
    if test "$status" -gt 128; then
        echo "$name terminated KCC by signal" >&2
        cat "$tmp/$name.err" >&2
        exit 1
    fi
    if ! grep -q "$diagnostic" "$tmp/$name.err"; then
        echo "$name missing expected diagnostic: $diagnostic" >&2
        cat "$tmp/$name.err" >&2
        exit 1
    fi
}

check_bad unknown-member 'Unknown struct/union member in initializer' \
'struct S { int a; }; struct S s = { .missing = 1 };'
check_bad negative-index 'Array designator index must not be negative' \
'int a[3] = { [-1] = 1 };'
check_bad bounds-index 'Array designator index exceeds array bounds' \
'int a[3] = { [3] = 1 };'
check_bad nonconstant-index 'Integral constant expected' \
'int i; int a[3] = { [i] = 1 };'
check_bad missing-member-equals '= required after designator' \
'struct S { int a; }; struct S s = { .a 1 };'

TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=designated t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name designated-initializers --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/designated.s" "$KCC_RT" >/dev/null
printf '%s\n' 'designated initializer regression passed'
