#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-bool-semantics-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
static _Bool sb5 = 5;
static _Bool ba[5] = { 0, 2, 0, -3, 1 };

struct bstruct {
    _Bool a;
    _Bool b;
    int x;
};

struct bfields {
    _Bool a:1;
    _Bool b:2;
    _Bool c:7;
    int x;
};

static struct bstruct bs = { 2, 0, 7 };
static struct bfields bf = { 2, 0, 7, 9 };

_Bool
ident(_Bool x)
{
    return x;
}

_Bool
fromint(int x)
{
    return x;
}

int
main(void)
{
    _Bool b, c;
    struct bfields af;
    int x = 3;
    char *p = (char *)&x;

    if (sizeof(_Bool) != 1 || sizeof(_Bool[3]) != 3) return 1;
    if (sizeof(struct bstruct) != 8) return 2;
    if (sb5 != 1 || bs.a != 1 || bs.b != 0) return 3;
    if (ba[0] || ba[1] != 1 || ba[2] || ba[3] != 1 || ba[4] != 1) return 4;
    if (bf.a != 1 || bf.b != 0 || bf.c != 1 || bf.x != 9) return 5;

    af.a = 0;
    af.b = 0;
    af.c = 0;
    af.x = 0;
    af.a = 3;
    af.b = 2;
    af.c = -4;
    if (af.a != 1 || af.b != 1 || af.c != 1) return 6;

    b = 17;
    if (b != 1) return 7;
    b = -2;
    if (b != 1) return 8;
    b = 0.2;
    if (b != 1) return 9;
    b = p;
    if (b != 1) return 10;

    if ((_Bool)0.0 != 0 || (_Bool)0.2 != 1 ||
        (_Bool)2 != 1 || (_Bool)-2 != 1) return 11;
    if (ident(7) != 1 || fromint(7) != 1 || fromint(0) != 0) return 12;

    b = 0;
    c = b++;
    if (c != 0 || b != 1) return 13;
    c = b++;
    if (c != 1 || b != 1) return 14;
    b = 0;
    c = ++b;
    if (c != 1 || b != 1) return 15;
    c = ++b;
    if (c != 1 || b != 1) return 16;
    b = 0;
    c = b--;
    if (c != 0 || b != 1) return 17;
    c = b--;
    if (c != 1 || b != 0) return 18;

    b = 1;
    b += 3;
    if (b != 1) return 19;
    b = 1;
    b -= 1;
    if (b != 0) return 20;
    b = 1;
    if ((b *= -1) != 1 || b != 1) return 21;
    b = 1;
    b /= 2;
    if (b != 0) return 22;
    b = 1;
    b |= 2;
    if (b != 1) return 23;
    b = 1;
    b ^= 1;
    if (b != 0) return 24;

    return 0;
}
SRC

cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=bool-semantics t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name bool-semantics --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/bool-semantics.s" "$KCC_RT" >/dev/null
printf '%s\n' 'bool semantics regression passed'
