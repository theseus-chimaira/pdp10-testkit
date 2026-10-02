#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-flexible-array-members-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;

struct flex_char {
    int n;
    char data[];
};

struct flex_int {
    char tag;
    int data[];
};

struct flex_packed {
    char tag;
    char data[];
} __attribute__((packed));

int
main(void)
{
    int raw[8];
    struct flex_char *c;
    struct flex_int *i;

    if (sizeof(struct flex_char) != 4) return 1;
    if (sizeof(struct flex_int) != 4) return 2;
    if (sizeof(struct flex_packed) != 1) return 3;

    c = (struct flex_char *)raw;
    c->n = 3;
    c->data[0] = 11;
    c->data[1] = 22;
    c->data[2] = 33;
    if (c->n != 3 || c->data[0] != 11 || c->data[1] != 22
        || c->data[2] != 33) return 4;

    i = (struct flex_int *)raw;
    i->tag = 7;
    i->data[0] = 101;
    i->data[1] = 202;
    if (i->tag != 7 || i->data[0] != 101 || i->data[1] != 202) return 5;

    return 0;
}
SRC

cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=flexfam t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name flexible-array-members --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/flexfam.s" "$KCC_RT" >/dev/null

check_rejected()
{
    name=$1
    text=$2
    expect=$3
    printf '%s\n' "$text" > "$tmp/$name.c"
    if TERM=dumb "$KCC" -S -v=nostats -x=pdp6 \
        -R="$tmp/$name" "$tmp/$name.c" >"$tmp/$name.out" 2>&1; then
        echo "expected $name to be rejected" >&2
        exit 1
    fi
    if ! grep "$expect" "$tmp/$name.out" >/dev/null 2>&1; then
        cat "$tmp/$name.out" >&2
        echo "missing expected diagnostic for $name: $expect" >&2
        exit 1
    fi
}

check_rejected notlast \
    'struct S { int n; char data[]; int x; };' \
    'Flexible array member must be last in struct'
check_rejected union \
    'union U { int n; char data[]; };' \
    'Flexible array member not allowed in union'
check_rejected only \
    'struct S { char data[]; };' \
    'Flexible array member in otherwise empty struct'
check_rejected unnamed_only \
    'struct S { int :1; char data[]; };' \
    'Flexible array member in otherwise empty struct'
check_rejected initializer \
    'struct S { int n; char data[]; }; struct S s = { 1, { 2, 3 } };' \
    'Flexible or incomplete array member cannot be initialized'

printf '%s\n' 'flexible array member regression passed'
