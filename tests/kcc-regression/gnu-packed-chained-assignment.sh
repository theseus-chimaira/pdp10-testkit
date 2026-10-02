#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
tmp="$TMPDIR/kcc-gnu-packed-chain-$$"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct p {
    unsigned char a, b, c;
    u16 d;
    unsigned char e;
} __attribute__((packed));
static struct p x[3];
int main(void)
{
    x[0].a = 1;
    x[0].b = 2;
    x[0].c = 3;
    x[0].d = 04567;
    x[0].e = 5;
    x[1].a = 7;
    x[2].a = 6;
    x[2] = x[1] = x[0];
    if (x[1].a != 1 || x[1].b != 2 || x[1].c != 3
      || x[1].d != 04567 || x[1].e != 5) return 1;
    if (x[2].a != 1 || x[2].b != 2 || x[2].c != 3
      || x[2].d != 04567 || x[2].e != 5) return 2;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackchain t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 600000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-chain --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackchain.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed chained assignment regression passed'
