#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-standard-char-pointer-boundary-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
static char *saved;
static char *keep(char *p)
{
    saved = p;
    return saved;
}
int main(void)
{
    char buf[3];
    char *local_null = (void *)0;
    char *p;

    buf[0] = 11;
    buf[1] = 22;
    buf[2] = 33;
    p = keep(buf + 1);
    if (p != buf + 1) return 1;
    if (*p != 22) return 2;
    if (saved != buf + 1) return 3;
    if (local_null != 0) return 4;
    return 0;
}
SRC
cat > "$tmp/nullinit.c" <<'SRC'
char *global_null = (void *)0;
int f(void)
{
    char *local_null = (void *)0;
    return global_null == local_null;
}
SRC
cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=nullinit nullinit.c
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=stdcharptr t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 5000000 --timeout 20 --workdir "$tmp/run" \
    --name standard-char-pointer-boundary --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/stdcharptr.s" "$KCC_RT" >/dev/null

printf '%s\n' 'standard char pointer boundary regression passed'
