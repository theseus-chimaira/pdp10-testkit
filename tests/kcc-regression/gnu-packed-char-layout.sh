#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-char-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
struct pc { char a; char b; char c; } __attribute__((packed));
struct pc2 { char a; char b; } __attribute__((__packed__));
struct pc arr[3];
static int offb(void) { struct pc x; return (char *)&x.b - (char *)&x; }
static int offc(void) { struct pc x; return (char *)&x.c - (char *)&x; }
int main(void)
{
    struct pc *p;
    register struct pc *q;
    if (sizeof(struct pc) != 3 || sizeof(struct pc2) != 2) return 1;
    if (sizeof(arr) != 9) return 2;
    if (offb() != 1 || offc() != 2) return 3;
    p = arr;
    p[0].a = 1; p[0].b = 2; p[0].c = 3;
    p[1].a = 4; p[1].b = 5; p[1].c = 6;
    p[2].a = 7; p[2].b = 8; p[2].c = 9;
    if (p[0].c != 3 || p[1].a != 4 || p[1].c != 6 || p[2].a != 7) return 4;
    if ((p + 1) - p != 1) return 5;
    if ((char *)(p + 1) - (char *)p != 3) return 6;
    q = arr;
    ++q;
    if (q->a != 4 || q->b != 5 || q->c != 6) return 7;
    if ((char *)q - (char *)arr != 3) return 8;
    return 0;
}
SRC
(
 cd "$tmp"
 TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpacked t.c
)
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name gnu-packed-char --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpacked.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed char aggregate regression passed'
