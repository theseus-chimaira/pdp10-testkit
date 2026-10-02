#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitptr-static-$$
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
static struct outer g = { 025, { 01111, 02222, 03333 }, 011 };
static u16 *q = g.a;
static u16 *r;
static void *v;

static int check_local_static(void)
{
    static u16 *s = g.a;
    return s[2] == 03333;
}

int main(void)
{
    if (q[0] != 01111 || q[1] != 02222 || q[2] != 03333) return 1;
    q[1] += 3;
    if (g.a[1] != 02225) return 2;

    r = g.a;
    if (r[2] != 03333) return 3;
    r[0] = 04444;
    if (g.a[0] != 04444) return 4;

    v = (void *)g.a;
    r = (u16 *)v;
    if (r[1] != 02225) return 5;

    if (!check_local_static()) return 6;
    if (g.pre != 025 || g.post != 011) return 7;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitstatic t.c
# The constant initializer must be emitted as an exact one-bit pointer.
grep -Eq 'POINT[[:space:]]+1,g,5' "$tmp/gpackbitstatic.s"
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 10000000 --timeout 25 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-static --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitstatic.s" "$KCC_RT" >/dev/null

cat > "$tmp/external.c" <<'SRC'
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer g;
u16 *q = g.a;
SRC
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitext "$tmp/external.c"
grep -Eq 'POINT[[:space:]]+1,g,5' "$tmp/gpackbitext.s"

printf '%s\n' 'GNU packed logical pointer static-storage regression passed'
