#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitptr-aggregate-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct inner {
    u16 x;
    unsigned int b:3;
    unsigned char y;
} __attribute__((packed));
struct outer {
    unsigned int pre:5;
    struct inner in;
    unsigned int post:4;
} __attribute__((packed));
static struct outer x;
int main(void)
{
    struct outer *p = &x;
    struct inner *q = &p->in;
    struct inner *r;

    p->pre = 025;
    p->post = 011;
    q->x = 012345;
    q->b = 5;
    q->y = 0321;
    if (q->x != 012345) return 1;
    if (q->b != 5) return 2;
    if (q->y != 0321) return 3;
    if ((*q).x != 012345) return 010;
    q->x += 7;
    q->b ^= 3;
    if (q->x != 012354) return 4;
    if (q->b != 6) return 5;
    r = &p->in;
    r->y += 4;
    if (r->y != 0325) return 6;
    if (p->pre != 025 || p->post != 011) return 7;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitaggptr t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 3000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-aggregate --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackbitaggptr.s" "$KCC_RT" >/dev/null
cat > "$tmp/escape.c" <<'SRC'
struct inner { unsigned char x; } __attribute__((packed));
struct outer { unsigned int pre:5; struct inner in; } __attribute__((packed));
static void sink(struct inner *p) { (void)p; }
struct inner *ret(struct outer *p) { return &p->in; }
void call(struct outer *p) { sink(&p->in); }
SRC
if TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackbitaggescape "$tmp/escape.c" >"$tmp/escape.out" 2>&1; then
    echo 'logical packed aggregate pointer unexpectedly escaped through function ABI' >&2
    exit 1
fi
grep -q 'cannot yet escape its local logical pointer representation' "$tmp/escape.out"
printf '%s\n' 'GNU packed aggregate logical pointer regression passed'
