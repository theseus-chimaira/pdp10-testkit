#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-mul-ac-operands.$$
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
  grep -qi 'MUL' "$ASM"
  grep -qi 'IMUL' "$ASM"
  if sed -n '/%DIMUM/,/POPJ/p' "$ASM" | grep -Eq 'PUSH[[:space:]]+17|POP[[:space:]]+17|SUB[[:space:]]+17,\[1,,1\]'; then
    echo "DImode multiply still uses operand stack temporaries for $cpu" >&2
    exit 1
  fi
done
printf '%s\n' 'DImode AC-operand multiplication regression passed'
