#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-diu-nosign-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir "$TMP"
cat >"$TMP/test.c" <<'SRC'
unsigned long long q(unsigned long long a, unsigned long long b) { return a / b; }
unsigned long long r(unsigned long long a, unsigned long long b) { return a % b; }
SRC
for cpu in -x=pdp6 -x=ka10 -x=ki10 -x=ks10; do
  (cd "$TMP" && "$KCC" "$cpu" -S -R=test test.c >/dev/null)
  asm="$TMP/test.s"
  grep -q '%DIDIV' "$asm"
  n=`grep -c '^[[:space:]]*SETZ[[:space:]]' "$asm" || true`
  [ "$n" -eq 6 ] || {
    echo "unsigned DImode divider emitted $n SETZ instructions, expected 6" >&2
    exit 1
  }
done
printf '%s\n' 'unsigned DImode divider sign-flag regression passed'
