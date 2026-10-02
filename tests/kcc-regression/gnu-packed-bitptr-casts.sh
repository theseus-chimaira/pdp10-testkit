#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitptr-casts-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef signed _KCCtype_char16 s16;
typedef unsigned _KCCtype_char16 u16;
typedef unsigned _KCCtype_char18 u18;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain;

static int signed_read(u16 *p)
{
    s16 *q = (s16 *)p;
    return *q;
}

static int const_read(u16 *p)
{
    const u16 *q = (const u16 *)p;
    return *q;
}

static u16 *same_cast(u16 *p)
{
    return (u16 *)(s16 *)p;
}

int main(void)
{
    struct outer *p = &x;
    u18 *wide;
    u16 *q;

    p->pre = 025;
    p->post = 011;
    p->a[0] = 012345;
    p->a[1] = 054321;
    plain = 023456;

    if (signed_read(p->a) != 012345) return 1;
    if (signed_read(&plain) != 023456) return 2;
    if (const_read(p->a) != 012345) return 3;
    if (const_read(&plain) != 023456) return 4;

    q = same_cast(p->a);
    if (*q != 012345) return 5;
    q = same_cast(&plain);
    if (*q != 023456) return 6;

    wide = (u18 *)p->a;
    q = (u16 *)wide;
    if (*q != 012345) return 7;
    if (p->pre != 025 || p->post != 011) return 8;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitcast t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 7000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-casts --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitcast.s" "$KCC_RT" >/dev/null

cat > "$tmp/void.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain;
static u16 *roundtrip(u16 *p)
{
    void *v = (void *)p;
    return (u16 *)v;
}
int main(void)
{
    u16 *q;
    x.a[0] = 012345;
    plain = 023456;
    q = roundtrip(x.a);
    if (*q != 012345) return 1;
    q = roundtrip(&plain);
    if (*q != 023456) return 2;
    return 0;
}
SRC
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitvoid "$tmp/void.c"
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 7000000 --timeout 20 --workdir "$tmp/void-run" \
    --name gnu-packed-bitptr-void --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitvoid.s" "$KCC_RT" >/dev/null

cat > "$tmp/maywide.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
typedef unsigned _KCCtype_char18 u18;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain;
static u18 *widen(u16 *p)
{
    return (u18 *)p;
}
static u16 *narrow(u18 *p)
{
    return (u16 *)p;
}
int main(void)
{
    u16 *q;
    x.a[0] = 012345;
    plain = 023456;
    q = narrow(widen(x.a));
    if (*q != 012345) return 1;
    q = narrow(widen(&plain));
    if (*q != 023456) return 2;
    return 0;
}
SRC
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitmaywide "$tmp/maywide.c"
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 7000000 --timeout 20 --workdir "$tmp/maywide-run" \
    --name gnu-packed-bitptr-maywide --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitmaywide.s" "$KCC_RT" >/dev/null

printf '%s\n' 'GNU packed logical pointer cast regression passed'
