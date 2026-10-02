#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
tmp=$TMPDIR/kcc-gnu-packed-bitptr-stream-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/shape.c" <<'SRC'
typedef unsigned _KCCtype_char16 u16;
u16 rd(u16 *p) { return *p; }
void wr(u16 *p, u16 v) { *p = v; }
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitstream shape.c
if grep -qi 'adjbph' "$tmp/gpackbitstream.s"; then
    echo 'logical packed scalar load/store still uses ADJBPH' >&2
    exit 1
fi
grep -Eqi '^[[:space:]]*(ibp|ildb)[[:space:]]' "$tmp/gpackbitstream.s"
cat > "$tmp/run.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer {
    unsigned int pre:5;
    u16 a[2];
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
static u16 plain;
static u16 rd(u16 *p) { return *p; }
static void wr(u16 *p, u16 v) { *p = v; }
int main(void)
{
    struct outer *p = &x;
    p->pre = 025;
    p->post = 011;
    wr(p->a, 012345);
    wr(p->a + 1, 054321);
    wr(&plain, 076543);
    if (rd(p->a) != 012345) return 1;
    if (rd(p->a + 1) != 054321) return 2;
    if (rd(&plain) != 076543) return 3;
    if (p->pre != 025 || p->post != 011) return 4;
    return 0;
}
SRC
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitstreamrun run.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 12000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-stream --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitstreamrun.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed logical pointer streaming regression passed'
