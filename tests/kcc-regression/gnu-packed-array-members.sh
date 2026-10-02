#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-arrays-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
typedef unsigned _KCCtype_char18 u18;
typedef unsigned _KCCtype_int32 u32;
struct pa {
    unsigned char tag;
    u16 a16[2];
    u18 a18[2];
    u32 a32[2];
    unsigned char a9[3];
    unsigned char end;
} __attribute__((packed));
static struct pa x[2];
static struct pa init = {
    01,
    { 012345, 067012 },
    { 0123456, 0654321 },
    { 012345670123U, 032543210123U },
    { 02, 03, 04 },
    05
};
int main(void)
{
    struct pa *p;
    if (sizeof(struct pa) != 21 || sizeof(x) != 42) return 1;
    x[1].tag = 011;
    x[1].a16[0] = 012345; x[1].a16[1] = 067012;
    x[1].a18[0] = 0123456; x[1].a18[1] = 0654321;
    x[1].a32[0] = 012345670123U; x[1].a32[1] = 032543210123U;
    x[1].a9[0] = 012; x[1].a9[1] = 013; x[1].a9[2] = 014;
    x[1].end = 015;
    if (x[1].a16[0] != 012345 || x[1].a16[1] != 067012) return 2;
    if (x[1].a18[0] != 0123456 || x[1].a18[1] != 0654321) return 3;
    if (x[1].a32[0] != 012345670123U || x[1].a32[1] != 032543210123U) return 4;
    if (x[1].a9[0] != 012 || x[1].a9[1] != 013 || x[1].a9[2] != 014) return 5;
    if (x[1].tag != 011 || x[1].end != 015) return 6;
    p = x; ++p;
    if (p->a16[1] != 067012 || p->a32[1] != 032543210123U) return 7;
    if (*(p->a16 + 1) != 067012 || (p->a16 + 1) - p->a16 != 1) return 8;
    if (*(p->a32 + 1) != 032543210123U || (p->a32 + 1) - p->a32 != 1) return 9;
    p->a16[0] += 7;
    ++p->a32[0];
    if (p->a16[0] != 012354) return 10;
    if (p->a32[0] != 012345670124U) return 11;
    if (init.tag != 01 || init.a16[1] != 067012) return 12;
    if (init.a18[1] != 0654321 || init.a32[1] != 032543210123U) return 13;
    if (init.a9[2] != 04 || init.end != 05) return 14;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackedarr t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-array-members --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackedarr.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed scalar-array member regression passed'
