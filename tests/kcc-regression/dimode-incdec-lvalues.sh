#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-incdec-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat >"$TMP/test.c" <<'SRC'
long long global_value;
static long long static_value;
long long array_value[4];
long long pre_g(void) { return ++global_value; }
long long post_g(void) { return global_value++; }
long long predec_g(void) { return --global_value; }
long long postdec_g(void) { return global_value--; }
long long auto_all(int k) { long long x; x = k; ++x; x++; --x; return x--; }
long long ptr_pre(long long *p) { return ++*p; }
long long ptr_post(long long *p) { return (*p)++; }
long long arr_pre(int i) { return ++array_value[i]; }
long long arr_post(int i) { return array_value[i]++; }
void discard(void) { ++static_value; static_value++; --static_value; static_value--; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" -S -x="$cpu" test.c >/dev/null)
    asm=$TMP/test.s
    grep -q 'DIINC' "$asm"
    grep -q 'DIDEC' "$asm"
    grep -q 'MOVEM' "$asm"
    if grep -qi 'internal error' "$asm"; then
        echo "DImode inc/dec internal error on $cpu" >&2
        exit 1
    fi
done
echo "DImode inc/dec lvalue regression passed"
