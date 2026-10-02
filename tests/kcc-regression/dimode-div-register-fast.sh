#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-di-div-fast-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat >"$TMP/test.c" <<'SRC'
long long sq(long long a, long long b) { return a / b; }
long long sr(long long a, long long b) { return a % b; }
unsigned long long uq(unsigned long long a, unsigned long long b) { return a / b; }
unsigned long long ur(unsigned long long a, unsigned long long b) { return a % b; }
void dq(long long *p, long long b) { *p = *p / b; }
void dr(long long *p, long long b) { *p = *p % b; }
long long pressure(long long a, long long b, long c, long d, long e)
{
    register long x = c;
    register long y = d;
    register long z = e;
    long long q = a / b;
    return q + x + y + z;
}
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" "-x=$cpu" -S -R="test-$cpu" test.c >/dev/null)
    asm="$TMP/test-$cpu.s"
    for fn in sq sr uq ur; do
        awk -v fn="$fn" '
          $0 == fn ":" { in_fn=1; next }
          in_fn && /^%DIDIV[0-9]+L:/ { found=1; exit }
          in_fn && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
          in_fn && /^[[:space:]]*(PUSH|POP)[[:space:]]/ { bad=1 }
          END { exit !(found && !bad) }
        ' "$asm" || {
            echo "$cpu: $fn spilled an operand before the register divider" >&2
            exit 1
        }
    done
    grep -q '^pressure:' "$asm" || {
        echo "$cpu: high-pressure divider case did not compile" >&2
        exit 1
    }
done
printf '%s\n' 'DImode register-resident divider fast-path regression passed'
