#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work="$TMPDIR/kcc-packed-copy-stream-codegen-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"
cat > "$work/t.c" <<'SRC'
typedef unsigned _KCCtype_char16 u16;
struct p {
        unsigned char a, b, c;
        u16 d;
        unsigned char e;
} __attribute__((packed));
static struct p x[2];
struct inner {
        u16 x;
        unsigned int y:5;
        unsigned char z;
} __attribute__((packed));
struct outer {
        unsigned int pre:5;
        struct inner in;
        unsigned int post:6;
} __attribute__((packed));
static struct outer o[2];
void f(void)
{
        x[1] = x[0];
        o[1].in = o[0].in;
}
SRC
cd "$work"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=pstream t.c
if grep -q '%ADJBPH' pstream.s; then
        echo 'packed streaming copy still uses ADJBP helper' >&2
        exit 1
fi
if ! grep -Eq '^[[:space:]]*ibp[[:space:]]' pstream.s; then
        echo 'packed streaming copy did not use IBP' >&2
        exit 1
fi
printf '%s\n' 'GNU packed copy streaming codegen regression passed'
