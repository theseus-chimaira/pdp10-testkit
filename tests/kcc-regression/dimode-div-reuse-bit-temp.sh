#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-div-bit-temp-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat >"$TMP/test.c" <<'SRC'
unsigned long long f(unsigned long long a, unsigned long long b)
{
    return a / b;
}
SRC

for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" "-x=$cpu" -S -R="test-$cpu" test.c >/dev/null)
    awk '
    /%DIDIV[0-9]+L:/ { inloop=1; next }
    inloop && /%DIDIV[0-9]+NS:/ { inloop=0 }
    inloop && $1 == "MOVE" {
        split($2, a, ","); last=a[1]
        next
    }
    inloop && $1 == "LSH" && $2 ~ /,-0?43$/ {
        split($2, a, ","); bit=a[1]
        next
    }
    inloop && $1 == "TLC" && $2 ~ /,0*400000$/ {
        if (++ntlcs == 2) cmp=last
    }
    END {
        if (bit == "" || cmp == "" || bit != cmp)
            exit 1
    }
    ' "$TMP/test-$cpu.s" || {
        echo "DImode divider did not reuse comparison temporary for numerator bit on $cpu" >&2
        exit 1
    }
done

echo "DImode divider bit-temporary reuse regression passed"
