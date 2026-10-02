#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/kcc-exact-width-layout-stride-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef signed _KCCtype_char16 s16;
typedef signed _KCCtype_int32 s32;
struct p16 { s16 a, b; };
struct p32 { s32 a, b; };
int main(void)
{
    s16 a16[3];
    s32 a32[3];
    struct p16 q16;
    struct p32 q32;
    if (sizeof(s16) != 1) return 1;
    if (sizeof(a16) != 3) return 2;
    if (&a16[1] - &a16[0] != 1) return 3;
    if (&a16[2] - &a16[0] != 2) return 4;
    if (sizeof(s32) != 4) return 5;
    if (sizeof(a32) != 014) return 6;
    if (&a32[1] - &a32[0] != 1) return 7;
    if (&a32[2] - &a32[0] != 2) return 8;
    if (sizeof(q16) != 4) return 9;
    if (sizeof(q32) != 010) return 10;
    return 0;
}
SRC
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=t t.c >/dev/null
)
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 2000000 --timeout 30 --workdir "$tmp/run" \
    --name exact-width-layout-stride --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/t.s" "$KCC_RT" >/dev/null
printf '%s\n' 'exact-width layout/stride regression passed'
