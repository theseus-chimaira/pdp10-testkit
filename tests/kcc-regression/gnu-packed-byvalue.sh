#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-byvalue-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
struct p3 { unsigned char a0; unsigned char a1; unsigned char a2; } __attribute__((packed));
struct p6 { unsigned char a0; unsigned char a1; unsigned char a2; unsigned char a3; unsigned char a4; unsigned char a5; } __attribute__((packed));
struct p11 { unsigned char a0; unsigned char a1; unsigned char a2; unsigned char a3; unsigned char a4; unsigned char a5; unsigned char a6; unsigned char a7; unsigned char a8; unsigned char a9; unsigned char a10; } __attribute__((packed));
struct p20 { unsigned char a0; unsigned char a1; unsigned char a2; unsigned char a3; unsigned char a4; unsigned char a5; unsigned char a6; unsigned char a7; unsigned char a8; unsigned char a9; unsigned char a10; unsigned char a11; unsigned char a12; unsigned char a13; unsigned char a14; unsigned char a15; unsigned char a16; unsigned char a17; unsigned char a18; unsigned char a19; } __attribute__((packed));
static struct p3 mk3(int b) { struct p3 r; r.a0=b; r.a1=b+1; r.a2=b+2; return r; }
static int sum3(struct p3 p) { return p.a0+p.a1+p.a2; }
static struct p6 mk6(int b) { struct p6 r; r.a0=b; r.a1=b+1; r.a2=b+2; r.a3=b+3; r.a4=b+4; r.a5=b+5; return r; }
static int sum6(struct p6 p) { return p.a0+p.a1+p.a2+p.a3+p.a4+p.a5; }
static struct p11 mk11(int b) { struct p11 r; r.a0=b; r.a1=b+1; r.a2=b+2; r.a3=b+3; r.a4=b+4; r.a5=b+5; r.a6=b+6; r.a7=b+7; r.a8=b+8; r.a9=b+9; r.a10=b+10; return r; }
static int sum11(struct p11 p) { return p.a0+p.a1+p.a2+p.a3+p.a4+p.a5+p.a6+p.a7+p.a8+p.a9+p.a10; }
static struct p20 mk20(int b) { struct p20 r; r.a0=b; r.a1=b+1; r.a2=b+2; r.a3=b+3; r.a4=b+4; r.a5=b+5; r.a6=b+6; r.a7=b+7; r.a8=b+8; r.a9=b+9; r.a10=b+10; r.a11=b+11; r.a12=b+12; r.a13=b+13; r.a14=b+14; r.a15=b+15; r.a16=b+16; r.a17=b+17; r.a18=b+18; r.a19=b+19; return r; }
static int sum20(struct p20 p) { return p.a0+p.a1+p.a2+p.a3+p.a4+p.a5+p.a6+p.a7+p.a8+p.a9+p.a10+p.a11+p.a12+p.a13+p.a14+p.a15+p.a16+p.a17+p.a18+p.a19; }
int main(void)
{
    struct p3 a; struct p6 b; struct p11 c; struct p20 d;
    a = mk3(1); if (a.a2 != 3 || sum3(a) != 6) return 1;
    b = mk6(2); if (b.a5 != 7 || sum6(b) != 27) return 2;
    c = mk11(3); if (c.a10 != 13 || sum11(c) != 88) return 3;
    d = mk20(4); if (d.a19 != 23 || sum20(d) != 270) return 4;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackedbv t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 3000000 --timeout 30 --workdir "$tmp/run" \
    --name gnu-packed-byvalue --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackedbv.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed by-value aggregate regression passed'
