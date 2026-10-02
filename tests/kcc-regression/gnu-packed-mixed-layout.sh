#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-mixed-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
typedef unsigned _KCCtype_char18 u18;
typedef unsigned _KCCtype_int32 u32;
typedef signed _KCCtype_int32 s32;
typedef signed _KCCtype_char16 s16;
struct p16 { unsigned char a; u16 b; unsigned char c; } __attribute__((packed));
struct p18 { unsigned char a; u18 b; unsigned char c; } __attribute__((packed));
static struct p16 a16[2];
static struct p18 a18[2];
struct x16 { unsigned char a, b, c; u16 d; unsigned char e; } __attribute__((packed));
struct x18 { unsigned char a, b, c; u18 d; unsigned char e; } __attribute__((packed));
struct x32 { unsigned char a; u32 d; unsigned char e; } __attribute__((packed));
struct x36 { unsigned char a; unsigned int d; unsigned char e; } __attribute__((packed));
static struct x16 x16[3];
static struct x18 x18[2];
static struct x32 x32[2];
static struct x36 x36[2];
struct sx16 { unsigned char a, b, c; s16 d; } __attribute__((packed));
struct sx32 { unsigned char a; s32 d; } __attribute__((packed));
static struct sx16 sx16[2];
static struct sx32 sx32[2];
static struct x16 ix16[2] = {
    { 1, 2, 3, 012345, 4 },
    { 5, 6, 7, 076543, 010 }
};
static struct x18 ix18[2] = {
    { 011, 012, 013, 0123456, 014 },
    { 015, 016, 017, 0654321, 020 }
};
static struct x32 ix32[2] = {
    { 021, 012345670123U, 022 },
    { 023, 032543210123U, 024 }
};
static struct x36 ix36[2] = {
    { 025, 012345670123U, 026 },
    { 027, 076543210123U, 030 }
};
static struct sx16 isx16[1] = { { 031, 032, 033, -012345 } };
static struct sx32 isx32[1] = { { 034, -0123456701 } };
struct pin { unsigned char a; u16 b; } __attribute__((packed));
struct pout { unsigned char tag; struct pin in; struct pin many[2]; unsigned char end; } __attribute__((packed));
static struct pout nest[2] = {
    { 041, { 042, 012345 }, { { 043, 023456 }, { 044, 034567 } }, 045 },
    { 051, { 052, 045670 }, { { 053, 056701 }, { 054, 067012 } }, 055 }
};
int main(void)
{
    struct p16 *p16;
    struct p18 *p18;
    struct x16 *px16;
    struct x18 *px18;
    struct x32 *px32;
    struct x36 *px36;
    if (sizeof(struct p16) != 4 || sizeof(a16) != 8) return 1;
    if (sizeof(struct p18) != 4 || sizeof(a18) != 8) return 2;
    a16[1].a = 011; a16[1].b = 012345; a16[1].c = 013;
    a18[1].a = 021; a18[1].b = 0123456; a18[1].c = 023;
    p16 = a16; ++p16;
    p18 = a18; ++p18;
    if (p16->a != 011 || p16->b != 012345 || p16->c != 013) return 3;
    if (p18->a != 021 || p18->b != 0123456 || p18->c != 023) return 4;
    if (sizeof(struct x16) != 6 || sizeof(x16) != 18) return 5;
    if (sizeof(struct x18) != 6 || sizeof(x18) != 12) return 6;
    if (sizeof(struct x32) != 6 || sizeof(x32) != 12) return 7;
    if (sizeof(struct x36) != 6 || sizeof(x36) != 12) return 8;
    x16[1].d = 012345; x16[1].e = 031;
    x18[1].d = 0123456; x18[1].e = 032;
    x32[1].d = 012345670123U; x32[1].e = 033;
    x36[1].d = 012345670123U; x36[1].e = 034;
    if (x16[1].d != 012345 || x16[1].e != 031) return 9;
    if (x18[1].d != 0123456 || x18[1].e != 032) return 10;
    if (x32[1].d != 012345670123U || x32[1].e != 033) return 11;
    if (x36[1].d != 012345670123U || x36[1].e != 034) return 12;
    px16 = x16; ++px16; px18 = x18; ++px18;
    px32 = x32; ++px32; px36 = x36; ++px36;
    if (px16->d != 012345 || px16->e != 031) return 13;
    if (px18->d != 0123456 || px18->e != 032) return 14;
    if (px32->d != 012345670123U || px32->e != 033) return 15;
    if (px36->d != 012345670123U || px36->e != 034) return 16;
    sx16[1].d = -012345;
    sx32[1].d = -0123456701;
    if (sx16[1].d != -012345) return 17;
    if (sx32[1].d != -0123456701) return 18;
    x16[0].a = 1; x16[0].b = 2; x16[0].c = 3; x16[0].d = 04567; x16[0].e = 5;
    x16[1].a = 077; x16[2].a = 066;
    x16[1] = x16[0];
    if (x16[1].a != 1 || x16[1].b != 2 || x16[1].c != 3
        || x16[1].d != 04567 || x16[1].e != 5) return 19;
    if (x16[2].a != 066) return 20;
    x16[1].d += 7;
    x18[1].d ^= 077;
    x32[1].d -= 0123U;
    if (x16[1].d != 04576) return 21;
    if (x18[1].d != (0123456 ^ 077)) return 22;
    if (x32[1].d != (012345670123U - 0123U)) return 23;
    ++x16[1].d;
    if (x18[1].d++ != (0123456 ^ 077)) return 24;
    if (x16[1].d != 04577) return 25;
    if (x18[1].d != ((0123456 ^ 077) + 1)) return 26;
    if (ix16[0].d != 012345 || ix16[1].d != 076543 || ix16[1].e != 010) return 27;
    if (ix18[0].d != 0123456 || ix18[1].d != 0654321 || ix18[1].e != 020) return 28;
    if (ix32[0].d != 012345670123U || ix32[1].d != 032543210123U || ix32[1].e != 024) return 29;
    if (ix36[0].d != 012345670123U || ix36[1].d != 076543210123U || ix36[1].e != 030) return 30;
    if (isx16[0].d != -012345 || isx32[0].d != -0123456701) return 31;
    if (sizeof(struct pin) != 3 || sizeof(struct pout) != 11 || sizeof(nest) != 22) return 32;
    if (nest[0].in.a != 042 || nest[0].in.b != 012345) return 33;
    if (nest[0].many[1].a != 044 || nest[0].many[1].b != 034567 || nest[0].end != 045) return 34;
    if (nest[1].tag != 051 || nest[1].in.b != 045670) return 35;
    if (nest[1].many[0].b != 056701) return 36;
    if (nest[1].many[1].b != 067012) return 37;
    if (nest[1].end != 055) return 38;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackedmix t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-mixed --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackedmix.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed mixed scalar regression passed'
