#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-nested-wholecopy-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct inner {
    u16 x;
    unsigned int y:5;
    unsigned char z;
} __attribute__((packed));
struct outer {
    unsigned int pre:5;
    struct inner in;
    unsigned int post:6;
} __attribute__((packed));
static struct outer a[2] = {
    { 3, { 0123456, 021, 0255 }, 045 },
    { 7, { 0154321, 007, 0111 }, 017 }
};
int main(void)
{
    struct inner q;
    struct inner r;
    q.x = 076543;
    q.y = 013;
    q.z = 0222;
    a[0].in = q;
    if (a[0].pre != 3 || a[0].post != 045) return 1;
    if (a[0].in.x != 076543 || a[0].in.y != 013 || a[0].in.z != 0222) return 2;
    r = a[1].in;
    if (r.x != 0154321 || r.y != 007 || r.z != 0111) return 3;
    if (a[1].pre != 7 || a[1].post != 017) return 4;
    a[1].in = a[0].in;
    if (a[1].in.x != 076543 || a[1].in.y != 013 || a[1].in.z != 0222) return 5;
    if (a[1].pre != 7 || a[1].post != 017) return 6;
    if (a[0].pre != 3 || a[0].post != 045) return 7;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpacknestcpy t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-nested-wholecopy --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpacknestcpy.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed nested whole-copy regression passed'
