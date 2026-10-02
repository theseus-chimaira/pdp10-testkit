#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-mul-no-snapshots.$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
long long smul(long long a, long long b) { return a * b; }
unsigned long long umul(unsigned long long a, unsigned long long b) { return a * b; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
  (
    cd "$TMP"
    "$KCC" -x="$cpu" -S -R="test-$cpu" test.c >/dev/null
  )
  ASM="$TMP/test-$cpu.s"
  moves=$(grep -c '^[[:space:]]*MOVE[[:space:]]' "$ASM" || true)
  [ "$moves" -le 10 ] || {
    echo "DImode multiply still has redundant result copies for $cpu ($moves MOVE instructions)" >&2
    exit 1
  }
done
printf '%s\n' 'DImode snapshot-free multiplication regression passed'
