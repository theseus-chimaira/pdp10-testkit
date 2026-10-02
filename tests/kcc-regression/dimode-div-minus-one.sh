#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-div-minus-one.$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
long long divm1(long long x) { return x / -1LL; }
long long modm1(long long x) { return x % -1LL; }
extern long long source(void);
long long modside(void) { return source() % -1LL; }
SRC
(
  cd "$TMP"
  "$KCC" -x=ka10 -S -R=test test.c >/dev/null
)
ASM="$TMP/test.s"
# Division uses the compact in-place negation, modulo directly zeros the pair.
grep -qi 'MOVN' "$ASM"
grep -qi 'SETZ' "$ASM"
grep -q 'source' "$ASM"
# No restoring-divider loop or 71-iteration counter should remain.
if grep -q '%DIDIV' "$ASM"; then
  echo 'DImode / or % -1 still uses restoring divider' >&2
  exit 1
fi
printf '%s\n' 'DImode division/remainder by -1 regression passed'
