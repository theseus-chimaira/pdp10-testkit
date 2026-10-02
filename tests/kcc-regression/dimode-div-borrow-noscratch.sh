#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-di-div-borrow-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat >"$TMP/test.c" <<'SRC'
unsigned long long q(unsigned long long a, unsigned long long b) { return a / b; }
long long r(long long a, long long b) { return a % b; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
  (cd "$TMP" && "$KCC" "-x=$cpu" -S -R="test-$cpu" test.c >/dev/null)
  awk '
    /%DIDIV[0-9]+SUB:/ { inb=1; subi=setz=movei=nsub=0; next }
    inb && /%DIDIV[0-9]+NS:/ {
      if (subi != 1 || setz != 0 || movei != 0 || nsub != 2) exit 1
      seen++; inb=0; next
    }
    inb && $1 == "SUBI" { subi++ }
    inb && $1 == "SETZ" { setz++ }
    inb && $1 == "MOVEI" { movei++ }
    inb && $1 == "SUB" { nsub++ }
    END { if (seen < 2) exit 1 }
  ' "$TMP/test-$cpu.s" || {
    echo "DImode divider still materializes a borrow scratch on $cpu" >&2
    exit 1
  }
done
echo "DImode divider scratch-free borrow regression passed"
