#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-exact-width-32-semantics-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef signed _KCCtype_int32 s32;
typedef unsigned _KCCtype_int32 u32;
struct pair32 { s32 a; u32 b; };
static s32 gs = (s32)020000000000;
static u32 gu = (u32)037777777777;
static struct pair32 gst = {
    (s32)020000000000,
    (u32)037777777777
};

s32
ids32(s32 x)
{
    return x;
}

u32
idu32(u32 x)
{
    return x;
}

int
main(void)
{
    s32 s;
    u32 u;
    s32 sa[2];
    u32 ua[2];
    struct pair32 x;
    unsigned int w;

    s = (s32)020000000000;
    u = (u32)037777777777;

    if ((int)s != -020000000000) return 1;
    if ((unsigned int)u != 037777777777) return 2;
    if ((int)gs != -020000000000) return 3;
    if ((unsigned int)gu != 037777777777) return 4;

    x.a = s;
    x.b = u;
    if ((int)x.a != -020000000000) return 5;
    if ((unsigned int)x.b != 037777777777) return 6;

    sa[0] = s;
    ua[0] = u;
    if ((int)sa[0] != -020000000000) return 7;
    if ((unsigned int)ua[0] != 037777777777) return 8;

    if ((int)gst.a != -020000000000) return 9;
    if ((unsigned int)gst.b != 037777777777) return 10;
    if ((int)ids32(s) != -020000000000) return 11;
    if ((unsigned int)idu32(u) != 037777777777) return 12;
    if (s >= 0) return 13;
    if (u != (u32)-1) return 14;
    if ((s32)037777777777 != -1) return 15;
    if ((u32)-1 != 037777777777) return 16;

    /* foldskip() must compare the full PDP-10 value.  On a 32-bit host,
     * 037777777777 truncates to host -1; it is still a positive 36-bit C
     * unsigned int and must not be rewritten as a comparison against -1.
     */
    w = 037777777777;
    if (w == (unsigned int)-1) return 17;
    if (w != 037777777777) return 18;

    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=exact-width-32 t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name exact-width-32 --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/exact-width-32.s" "$KCC_RT" >/dev/null
printf '%s\n' 'exact 32-bit semantics regression passed'
