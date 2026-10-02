#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=$TMPDIR/kcc-gnu-packed-nested-bitoffset-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct inner {
    u16 x;
    unsigned int y:5;
    unsigned char z;
} __attribute__((packed));
struct outer {
    unsigned int pre:5;
    struct inner in;
    unsigned int post:6;
} __attribute__((packed));
static struct outer a[2] = {
    { 3, { 0123456, 021, 0255 }, 045 },
    { 7, { 0154321, 007, 0111 }, 017 }
};
int main(void)
{
    struct outer *p;
    if (sizeof(struct inner) != 4) return 1;
    if (sizeof(struct outer) != 6 || sizeof(a) != 12) return 2;
    if (a[0].pre != 3 || a[0].in.x != 0123456) return 3;
    if (a[0].in.y != 021 || a[0].in.z != 0255 || a[0].post != 045) return 4;
    if (a[1].pre != 7 || a[1].in.x != 0154321) return 5;
    if (a[1].in.y != 007 || a[1].in.z != 0111 || a[1].post != 017) return 6;
    a[0].in.x = 077777;
    a[0].in.y ^= 037;
    ++a[0].in.z;
    if (a[0].in.x != 077777 || a[0].in.y != 016 || a[0].in.z != 0256) return 7;
    p = a; ++p;
    p->in.x += 3;
    p->in.y = 012;
    if (p->in.x != 0154324 || p->in.y != 012) return 8;
    if (p->pre != 7 || p->post != 017) return 9;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpacknestbit t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-nested-bitoffset --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpacknestbit.s" "$KCC_RT" >/dev/null
cat > "$tmp/addr.c" <<'SRC'
volatile int __test_exit;
struct inner { unsigned char x; } __attribute__((packed));
struct outer { unsigned int pre:5; struct inner in; unsigned int post:4; } __attribute__((packed));
static struct outer a[2];
int main(void)
{
    struct outer *p = a;
    if (&p->in == (struct inner *)0) return 1;
    return 0;
}
SRC
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpacknestaddr "$tmp/addr.c"
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run-addr" \
    --name gnu-packed-nested-address --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpacknestaddr.s" "$KCC_RT" >/dev/null

cat > "$tmp/stream.c" <<'SRC'
typedef unsigned _KCCtype_char16 u16;
struct inner { u16 x; unsigned int y:5; unsigned char z; } __attribute__((packed));
struct outer { unsigned int pre:5; struct inner in; unsigned int post:6; } __attribute__((packed));
static struct outer o[3];
void copy1(void) { o[1].in = o[0].in; }
void chain(void) { o[2].in = o[1].in = o[0].in; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    mkdir -p "$tmp/stream-$cpu"
    (cd "$tmp/stream-$cpu" && TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -R=gpackneststream "$tmp/stream.c")
    s="$tmp/stream-$cpu/gpackneststream.s"
    if grep -qi '%ADJBPH' "$s"; then
        echo "$cpu: nested bit-offset packed copy still uses ADJBP helper" >&2
        exit 1
    fi
    n=$(grep -E '^[[:space:]]*[A-Za-z]' "$s" | wc -l)
    if [ "$n" -gt 200 ]; then
        echo "$cpu: nested bit-offset packed copy rebuilt byte pointers ($n instructions)" >&2
        exit 1
    fi
done

cat > "$tmp/chain.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct inner {
    u16 x;
    unsigned int y:5;
    unsigned char z;
} __attribute__((packed));
struct outer {
    unsigned int pre:5;
    struct inner in;
    unsigned int post:6;
} __attribute__((packed));
static struct outer o[3];
int main(void)
{
    o[0].in.x = 0123456;
    o[0].in.y = 021;
    o[0].in.z = 0255;
    o[1].in.x = 1;
    o[2].in.x = 2;
    o[2].in = o[1].in = o[0].in;
    if (o[1].in.x != 0123456 || o[1].in.y != 021 || o[1].in.z != 0255) return 1;
    if (o[2].in.x != 0123456 || o[2].in.y != 021 || o[2].in.z != 0255) return 2;
    return 0;
}
SRC
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpacknestchain "$tmp/chain.c"
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 2000000 --timeout 20 --workdir "$tmp/run-chain" \
    --name gnu-packed-nested-chain --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpacknestchain.s" "$KCC_RT" >/dev/null

printf '%s\n' 'GNU packed nested bit-offset regression passed'
