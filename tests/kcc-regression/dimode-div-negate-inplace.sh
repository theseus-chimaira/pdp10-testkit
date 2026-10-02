#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-didivneg-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir "$TMP"
cat >"$TMP/test.c" <<'SRC'
long long q(long long a, long long b) { return a / b; }
long long r(long long a, long long b) { return a % b; }
SRC
for cpu in -x=pdp6 -x=ka10 -x=ki10 -x=ks10; do
  (cd "$TMP" && "$KCC" "$cpu" -S -R=test test.c >/dev/null)
  asm="$TMP/test.s"
  grep -q 'DIDIV.*N' "$asm"
  grep -q 'DIDIV.*D' "$asm"
  grep -q 'SKIPE' "$asm"
  ! grep -q 'DIDIV.*N0' "$asm"
  ! grep -q 'DIDIV.*D0' "$asm"
  ! grep -q 'DIDIV.*MR0' "$asm"
  ! grep -q 'DIDIV.*MQ0' "$asm"
done
printf '%s\n' 'DImode division in-place sign negation regression passed'
