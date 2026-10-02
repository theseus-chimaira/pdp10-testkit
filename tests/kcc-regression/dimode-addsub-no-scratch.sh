#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dias-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir "$TMP"
cat >"$TMP/test.c" <<'SRC'
long long add71(long long a, long long b) { return a + b; }
long long sub71(long long a, long long b) { return a - b; }
unsigned long long addu71(unsigned long long a, unsigned long long b) { return a + b; }
unsigned long long subu71(unsigned long long a, unsigned long long b) { return a - b; }
SRC
for cpu in -x=pdp6 -x=ka10 -x=ki10 -x=ks10; do
  (cd "$TMP" && "$KCC" "$cpu" -S -R=test test.c >/dev/null)
  asm="$TMP/test.s"
  grep -q 'DIADD' "$asm"
  grep -q 'DISUB' "$asm"
  ! grep -q 'SETZ' "$asm"
  ! grep -q 'LSH.*-43' "$asm"
done
printf '%s\n' 'DImode scratch-free add/sub regression passed'
