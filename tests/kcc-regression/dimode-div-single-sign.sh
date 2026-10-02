#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-di-div-sign-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat >"$TMP/test.c" <<'SRC'
long long q(long long a, long long b) { return a / b; }
long long r(long long a, long long b) { return a % b; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" "-x=$cpu" -S -R="test-$cpu" test.c >/dev/null)
    asm="$TMP/test-$cpu.s"
    awk '
      /^q:/ { f="q"; next }
      /^r:/ { f="r"; next }
      /^%DIDIV[0-9]+L:/ { loop=1 }
      f && !loop && /^[[:space:]]*SETZ[[:space:]]/ { setz[f]++ }
      f && !loop && /^[[:space:]]*XOR[[:space:]]/ { xors[f]++ }
      /^%DIDIV[0-9]+M[QR]:/ { f=""; loop=0 }
      END {
        if (setz["q"] != 5 || setz["r"] != 3 || xors["q"] != 1 || xors["r"] != 0)
          exit 1
      }
    ' "$asm" || {
        echo "signed DImode divider did not use one result-specific sign AC on $cpu" >&2
        exit 1
    }
done
printf '%s\n' 'signed DImode single-sign-AC regression passed'
