#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
tmp=$TMPDIR/kcc-mixed-byte-struct-static-init-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
typedef signed _KCCtype_char6 s6;
typedef unsigned _KCCtype_char6 u6;
typedef signed _KCCtype_char7 s7;
typedef unsigned _KCCtype_char7 u7;
typedef signed _KCCtype_char8 s8;
typedef unsigned _KCCtype_char8 u8;
typedef signed _KCCtype_char9 s9;
typedef unsigned _KCCtype_char9 u9;
typedef signed _KCCtype_char16 s16;
typedef unsigned _KCCtype_char16 u16;
typedef signed _KCCtype_char18 s18;
typedef unsigned _KCCtype_char18 u18;

struct mixed_bytes {
    s6 a;
    u6 b;
    s7 c;
    u7 d;
    s8 e;
    u8 f;
    s9 g;
    u9 h;
    s16 i;
    u16 j;
    s18 k;
    u18 l;
};

static struct mixed_bytes m = {
    -1, 077, -2, 0177, -3, 0377, -4, 0777,
    -0100, 0177777, -0200000, 0777777
};

int
probe(void)
{
    if ((int)m.a != -1) return 1;
    if ((unsigned int)m.b != 077) return 2;
    if ((int)m.c != -2) return 3;
    if ((unsigned int)m.d != 0177) return 4;
    if ((int)m.e != -3) return 5;
    if ((unsigned int)m.f != 0377) return 6;
    if ((int)m.g != -4) return 7;
    if ((unsigned int)m.h != 0777) return 8;
    if ((int)m.i != -0100) return 9;
    if ((unsigned int)m.j != 0177777) return 10;
    if ((int)m.k != -0200000) return 11;
    if ((unsigned int)m.l != 0777777) return 12;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=mixed-byte-struct t.c
printf '%s\n' 'mixed byte struct static initializer regression passed'
