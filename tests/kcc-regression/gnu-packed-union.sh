#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-union-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
typedef unsigned _KCCtype_int32 u32;
struct pin { unsigned char a; u16 b; } __attribute__((packed));
union pu {
    u32 w;
    u16 h[2];
    unsigned char b[4];
} __attribute__((packed));
union pn {
    struct pin p;
    unsigned char b[3];
} __attribute__((packed));
static union pu x[3];
static union pu init = { 032543210123U };
static union pn ni = { { 077, 012345 } };
static union pu makeu(u32 v) { union pu q; q.w = v; return q; }
static u32 takeu(union pu q) { return q.w; }
int main(void)
{
    union pu *p;
    union pu q;
    if (sizeof(union pu) != 4 || sizeof(x) != 12) return 1;
    if (sizeof(union pn) != 3) return 2;
    x[1].w = 012345670123U;
    if (x[1].w != 012345670123U) return 3;
    x[2].h[0] = 012345; x[2].h[1] = 067012;
    if (x[2].h[0] != 012345 || x[2].h[1] != 067012) return 4;
    x[0].b[0] = 1; x[0].b[1] = 2; x[0].b[2] = 3; x[0].b[3] = 4;
    if (x[0].b[0] != 1 || x[0].b[3] != 4) return 5;
    p = x; ++p;
    if (p->w != 012345670123U) return 6;
    if (init.w != 032543210123U) return 7;
    if (ni.p.a != 077 || ni.p.b != 012345) return 8;
    q = makeu(036543210123U);
    if (q.w != 036543210123U) return 9;
    if (takeu(q) != 036543210123U) return 10;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackedunion t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-union --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackedunion.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed union regression passed'
