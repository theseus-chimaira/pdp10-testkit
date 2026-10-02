#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-dimode-low-mask-direct.$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
unsigned long long m2(unsigned long long x) { return x % 2ULL; }
unsigned long long m8(unsigned long long x) { return x % 256ULL; }
unsigned long long mask(unsigned long long x) { return x & 4095ULL; }
unsigned long long rmask(unsigned long long x) { return 1023ULL & x; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
  (
    cd "$TMP"
    "$KCC" -x="$cpu" -S -R="t-$cpu" test.c >/dev/null
  )
  ASM="$TMP/t-$cpu.s"
  grep -qi 'SETZ' "$ASM"
  grep -qi 'AND.*\[1\]' "$ASM"
  grep -qi 'AND.*\[377\]' "$ASM"
  grep -qi 'AND.*\[7777\]' "$ASM"
  grep -qi 'AND.*\[1777\]' "$ASM"
  # No separate zero/mask DImode pair should be constructed.
  if grep -Eqi 'SETZ[[:space:]]+[4-7],|MOVEI[[:space:]]+[4-7],(1|377|7777|1777)' "$ASM"; then
    echo "DImode low mask still materializes a constant register pair on $cpu" >&2
    exit 1
  fi
done
printf '%s\n' 'direct DImode low-mask regression passed'
