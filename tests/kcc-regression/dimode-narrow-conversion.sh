#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-din17-$$
# cleanup disabled for debugging
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;
typedef signed _KCCtype_char6 s6;
typedef unsigned _KCCtype_char6 u6;
int f(long long x) { return (int)x; }
unsigned int g(unsigned long long x) { return (unsigned int)x; }
int h(long long x) { return (s6)x; }
int i(unsigned long long x) { return (u6)x; }
int main(void)
{
    if (f((long long)-1234567) != -1234567) return 1;
    if (g((unsigned long long)07654321U) != 07654321U) return 2;
    if (h((long long)-041) != 037) return 3;
    if (i((unsigned long long)0100) != 0) return 4;
    return 0;
}
SRC
(
 cd "$tmp"
 TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=din17 t.c
)
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name dimode-narrow-conversion --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/din17.s" "$KCC_RT" >/dev/null
echo "DImode narrow conversion regression passed"
