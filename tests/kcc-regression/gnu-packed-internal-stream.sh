#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
tmp=$TMPDIR/kcc-gnu-packed-internal-stream-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/shape.c" <<'SRC'
typedef unsigned _KCCtype_char16 u16;
struct S {
    unsigned int pre:5;
    u16 x;
    unsigned int post:3;
} __attribute__((packed));
struct B {
    unsigned int a:5;
    unsigned int b:16;
    unsigned int c:7;
} __attribute__((packed));
static struct S s;
static struct B b;
u16 rds(void) { return s.x; }
void wrs(u16 x) { s.x = x; }
unsigned rdb(void) { return b.b; }
void wrb(unsigned x) { b.b = x; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    d=$tmp/$cpu
    mkdir -p "$d"
    cp "$tmp/shape.c" "$d/t.c"
    (cd "$d" && TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -R=gpackint t.c)
    s=$d/gpackint.s
    setms=$(grep -Eic '^[[:space:]]*setm[[:space:]]' "$s" || true)
    ildbs=$(grep -Eic '^[[:space:]]*ildb[[:space:]]' "$s" || true)
    if [ "$setms" -gt 12 ]; then
        echo "$cpu: packed scalar access rebuilt byte pointers ($setms SETM instructions)" >&2
        exit 1
    fi
    if [ "$ildbs" -lt 8 ]; then
        echo "$cpu: packed scalar access lost streaming ILDB sequence" >&2
        exit 1
    fi
done
cat > "$tmp/run.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct S {
    unsigned int pre:5;
    u16 x;
    unsigned int post:3;
} __attribute__((packed));
struct B {
    unsigned int a:5;
    unsigned int b:16;
    unsigned int c:7;
} __attribute__((packed));
static struct S s;
static struct B b;
static u16 rds(void) { return s.x; }
static void wrs(u16 x) { s.x = x; }
static unsigned rdb(void) { return b.b; }
static void wrb(unsigned x) { b.b = x; }
int main(void)
{
    s.pre = 025;
    s.post = 5;
    wrs(012345);
    if (rds() != 012345) return 1;
    if (s.pre != 025 || s.post != 5) return 2;
    b.a = 021;
    b.c = 0105;
    wrb(054321);
    if (rdb() != 054321) return 3;
    if (b.a != 021 || b.c != 0105) return 4;
    wrs(076543);
    wrb(012345);
    if (rds() != 076543 || rdb() != 012345) return 5;
    if (s.pre != 025 || s.post != 5 || b.a != 021 || b.c != 0105) return 6;
    return 0;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackintrun run.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 3000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-internal-stream --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackintrun.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed internal scalar streaming regression passed'
