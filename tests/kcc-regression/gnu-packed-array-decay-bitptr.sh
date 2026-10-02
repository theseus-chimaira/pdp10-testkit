#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-array-decay-bitptr-$$
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
int main(void)
{
    struct outer *p = &x;
    int i;
    p->pre = 025;
    p->post = 011;
    *(p->a + 0) = 012345;
    *(p->a + 1) = 054321;
    i = 2;
    *(p->a + i) = 076543;
    if (*(p->a + 0) != 012345) return 1;
    if (*(p->a + 1) != 054321) return 2;
    if (*(p->a + i) != 076543) return 3;
    if ((p->a + 2) - p->a != 2) return 4;
    if (p->pre != 025 || p->post != 011) return 5;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackdecay t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 2000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-array-decay-bitptr --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackdecay.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed bit-pointer array decay regression passed'
