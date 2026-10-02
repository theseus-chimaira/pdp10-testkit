#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitptr-local-$$
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
    u16 *q = p->a;
    u16 *r;
    int i = 2;

    p->pre = 025;
    p->post = 011;
    q[0] = 012345;
    q[1] = 054321;
    r = p->a;
    r[i] = 076543;
    if (*q != 012345) return 1;
    if (*(q + 1) != 054321) return 2;
    if (r[i] != 076543) return 3;
    q[1] += 7;
    if (q[1] != 054330) return 4;
    if ((r + 2) - r != 2) return 5;
    if (p->pre != 025 || p->post != 011) return 6;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitlocal t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 3000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-local --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitlocal.s" "$KCC_RT" >/dev/null
cat > "$tmp/mix.c" <<'SRC'
typedef unsigned _KCCtype_char16 u16;
struct outer { unsigned int pre:5; u16 a[2]; } __attribute__((packed));
static u16 x;
void f(struct outer *p)
{
    u16 *q = p->a;
    q = &x;
}
SRC
if TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitmix "$tmp/mix.c" >"$tmp/mix.out" 2>&1; then
    echo 'ordinary pointer unexpectedly replaced logical packed pointer' >&2
    exit 1
fi
grep -q 'ordinary pointer cannot replace a non-byte-aligned GNU packed logical pointer' "$tmp/mix.out"
printf '%s\n' 'GNU packed local logical pointer regression passed'
