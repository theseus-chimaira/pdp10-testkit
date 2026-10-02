#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitptr-callstore-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[3];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain[3];
static void wr(u16 *p, u16 v) { *p = v; }
static void wridx(u16 *p, int i, u16 v) { p[i] = v; }
static void addidx(u16 *p, int i, u16 v) { p[i] += v; }
int main(void)
{
    struct outer *p = &x;

    p->pre = 025;
    p->post = 011;
    p->a[0] = 1;
    p->a[1] = 2;
    p->a[2] = 3;
    plain[0] = 4;
    plain[1] = 5;
    plain[2] = 6;

    wr(p->a, 012345);
    wr(&plain[0], 045670);
    wridx(p->a, 2, 034567);
    wridx(plain, 2, 067012);
    addidx(p->a, 1, 7);
    addidx(plain, 1, 011);

    if (p->a[0] != 012345) return 1;
    if (p->a[1] != 011) return 2;
    if (p->a[2] != 034567) return 3;
    if (plain[0] != 045670) return 4;
    if (plain[1] != 016) return 5;
    if (plain[2] != 067012) return 6;
    if (p->pre != 025 || p->post != 011) return 7;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitstore t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 12000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-callstore --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitstore.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed function-boundary logical pointer store regression passed'
