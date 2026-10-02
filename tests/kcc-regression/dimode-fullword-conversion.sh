#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-dfw18-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
unsigned int u(unsigned long long x) { return (unsigned int)x; }
int s(long long x) { return (int)x; }
int main(void)
{
    unsigned long long a;
    long long b;
    a = (unsigned long long)1 << 35;
    if (u(a) != 0400000000000U) return 1;
    a = (unsigned long long)1 << 36;
    if (u(a) != 0U) return 2;
    b = (long long)1 << 35;
    if (s(b) != (int)0400000000000U) return 3;
    b = -1;
    if (s(b) != -1) return 4;
    return 0;
}
SRC
(
 cd "$tmp"
 TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=dfw18 t.c
)
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name dimode-fullword-conversion --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/dfw18.s" "$KCC_RT" >/dev/null
echo "DImode full-word conversion regression passed"
