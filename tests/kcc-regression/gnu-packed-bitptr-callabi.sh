#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitptr-callabi-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain;
static int rd(u16 *p) { return *p; }
static int rd5(int a, int b, int c, int d, u16 *p)
{
    return a + b + c + d + *p;
}
static u16 *retp(struct outer *p) { return p->a; }
static u16 *retplain(void) { return &plain; }
int main(void)
{
    struct outer *p = &x;
    u16 *q;

    p->pre = 025;
    p->post = 011;
    p->a[0] = 012345;
    plain = 054321;

    if (rd(p->a) != 012345) return 1;
    if (rd(&plain) != 054321) return 2;
    if (rd5(1, 2, 3, 4, p->a) != 012357) return 3;
    if (rd5(1, 2, 3, 4, &plain) != 054333) return 4;

    q = retp(p);
    if (*q != 012345) return 5;
    q = retplain();
    if (*q != 054321) return 6;

    if (p->pre != 025 || p->post != 011) return 7;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitcall t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 7000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-callabi --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitcall.s" "$KCC_RT" >/dev/null

printf '%s\n' 'GNU packed function-boundary logical pointer regression passed'
