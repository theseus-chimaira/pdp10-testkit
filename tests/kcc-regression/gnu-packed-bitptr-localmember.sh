#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitptr-localmember-$$
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
struct req { u16 *input; };
static struct outer x;
static u16 plain[2];
static u16 *volatile saved;
static u16 *save_reload(u16 *p)
{
    saved = p;
    return saved;
}
static void store(u16 *buf, u16 v)
{
    struct req r;
    r.input = buf;
    r.input[0] = v;
}
int main(void)
{
    x.pre = 025;
    x.post = 011;
    x.a[0] = 1;
    x.a[1] = 2;
    plain[0] = 3;
    plain[1] = 4;
    store(x.a, 012345);
    store(plain, 045670);
    if (save_reload(x.a) != x.a) return 6;
    if (save_reload(plain) != plain) return 7;
    if (x.a[0] != 012345) return 1;
    if (x.a[1] != 2) return 2;
    if (plain[0] != 045670) return 3;
    if (plain[1] != 4) return 4;
    if (x.pre != 025 || x.post != 011) return 5;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitlocalmember t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 12000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-localmember --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitlocalmember.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed function-boundary local member regression passed'
