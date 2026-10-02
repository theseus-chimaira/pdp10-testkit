#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitfield-mixed-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
typedef unsigned _KCCtype_int32 u32;
struct mix {
    unsigned char a;
    unsigned int b:5;
    u16 c;
    unsigned int d:7;
    u32 e;
    unsigned char f;
} __attribute__((packed));
static struct mix x[2];
static struct mix sx[2] = {
    { 0123, 025, 0123456, 0101, 0123456701, 0255 },
    { 7, 3, 077777, 017, 0765432107, 1 }
};
int main(void)
{
    struct mix *p;
    if (sizeof(struct mix) != 10 || sizeof(x) != 20 || sizeof(sx) != 20) return 1;
    if (sx[0].a!=0123 || sx[0].b!=025 || sx[0].c!=0123456) return 11;
    if (sx[0].d!=0101 || sx[0].e!=0123456701 || sx[0].f!=0255) return 12;
    if (sx[1].a!=7 || sx[1].b!=3 || sx[1].c!=077777) return 13;
    if (sx[1].d!=017 || sx[1].e!=0765432107 || sx[1].f!=1) return 14;
    x[0].a=0123; x[0].b=025; x[0].c=0123456; x[0].d=0101;
    x[0].e=0123456701; x[0].f=0255;
    if (x[0].a!=0123) return 21; if (x[0].b!=025) return 22; if (x[0].c!=0123456) return 23;
    if (x[0].d!=0101 || x[0].e!=0123456701 || x[0].f!=0255) return 3;
    x[1].a=7; x[1].b=3; x[1].c=077777; x[1].d=017;
    x[1].e=0765432107; x[1].f=1;
    p=x; ++p;
    if (p->a!=7 || p->b!=3 || p->c!=077777) return 4;
    if (p->d!=017 || p->e!=0765432107 || p->f!=1) return 5;
    p->c += 3; p->d ^= 7; ++p->e;
    if (p->c!=0100002 || p->d!=010 || p->e!=0765432110) return 6;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackmixbf t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitfield-mixed --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackmixbf.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed mixed bit-field regression passed'
