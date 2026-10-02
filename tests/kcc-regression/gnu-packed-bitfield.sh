#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitfield-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
struct bf1 {
    unsigned int a:3;
    unsigned int b:5;
    unsigned int c:10;
} __attribute__((packed));
struct bf2 {
    unsigned int a:8;
    unsigned int b:12;
    unsigned int c:16;
} __attribute__((packed));
static struct bf1 x[2];
static struct bf2 y[2];
static struct bf1 sx[2] = { {5,17,0777}, {3,7,0123} };
static struct bf2 sy[2] = { {0255,02777,012345}, {1,2,3} };
int main(void)
{
    struct bf1 *p;
    if (sizeof(struct bf1) != 2 || sizeof(x) != 4 || sizeof(sx) != 4) return 1;
    if (sizeof(struct bf2) != 4 || sizeof(y) != 8 || sizeof(sy) != 8) return 2;
    if (sx[0].a!=5 || sx[0].b!=17 || sx[0].c!=0777) return 11;
    if (sx[1].a!=3 || sx[1].b!=7 || sx[1].c!=0123) return 12;
    if (sy[0].a!=0255 || sy[0].b!=02777 || sy[0].c!=012345) return 13;
    if (sy[1].a!=1 || sy[1].b!=2 || sy[1].c!=3) return 14;
    x[0].a=5; x[0].b=17; x[0].c=0777;
    x[1].a=3; x[1].b=7; x[1].c=0123;
    if (x[0].a!=5 || x[0].b!=17 || x[0].c!=0777) return 3;
    if (x[1].a!=3 || x[1].b!=7 || x[1].c!=0123) return 4;
    p=x; ++p;
    if (p->a!=3 || p->b!=7 || p->c!=0123) return 5;
    y[1].a=0255; y[1].b=02777; y[1].c=012345;
    if (y[1].a!=0255 || y[1].b!=02777 || y[1].c!=012345) return 6;
    y[1].b += 3;
    ++y[1].c;
    if (y[1].b!=03002 || y[1].c!=012346) return 7;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbf t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitfield --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbf.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed bit-field regression passed'
