#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitptr-callarith-$$
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
static u16 rdindex(u16 *p, int i) { return p[i]; }
static u16 *step(u16 *p, int i) { return p + i; }
static u16 rdprev(u16 *p) { return p[-1]; }
int main(void)
{
    struct outer *p = &x;
    u16 *q;

    p->pre = 025;
    p->post = 011;
    p->a[0] = 012345;
    p->a[1] = 023456;
    p->a[2] = 034567;
    plain[0] = 045670;
    plain[1] = 056701;
    plain[2] = 067012;

    if (rdindex(p->a, 0) != 012345) return 1;
    if (rdindex(p->a, 1) != 023456) return 2;
    if (rdindex(p->a, 2) != 034567) return 3;
    if (rdindex(plain, 0) != 045670) return 4;
    if (rdindex(plain, 1) != 056701) return 5;
    if (rdindex(plain, 2) != 067012) return 6;

    q = step(p->a, 2);
    if (*q != 034567) return 7;
    if (rdprev(q) != 023456) return 8;
    q = step(plain, 2);
    if (*q != 067012) return 9;
    if (rdprev(q) != 056701) return 10;

    if (p->pre != 025 || p->post != 011) return 11;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitarith t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 9000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-callarith --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitarith.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed function-boundary logical pointer arithmetic regression passed'
