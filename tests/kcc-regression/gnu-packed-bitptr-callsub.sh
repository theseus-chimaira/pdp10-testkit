#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitptr-callsub-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[4];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain[4];
static int dist(u16 *a, u16 *b) { return a - b; }
static int dist5(int x1, int x2, int x3, int x4, u16 *a, u16 *b)
{
    return a - b + x1 - x1 + x2 - x2 + x3 - x3 + x4 - x4;
}
int main(void)
{
    struct outer *p = &x;

    if (dist(p->a + 3, p->a) != 3) return 1;
    if (dist(p->a, p->a + 3) != -3) return 2;
    if (dist(p->a + 2, p->a + 2) != 0) return 3;
    if (dist(plain + 3, plain) != 3) return 4;
    if (dist(plain, plain + 3) != -3) return 5;
    if (dist5(1, 2, 3, 4, p->a + 3, p->a) != 3) return 6;
    if (dist5(1, 2, 3, 4, plain + 3, plain) != 3) return 7;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitsub t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 9000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-callsub --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitsub.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed function-boundary logical pointer subtraction regression passed'
