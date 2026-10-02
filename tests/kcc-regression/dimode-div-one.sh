#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-di-div-one-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat >"$TMP/test.c" <<'SRC'
extern long long source(void);
extern unsigned long long usource(void);
long long sq(long long x) { return x / 1; }
long long sr(long long x) { return x % 1; }
unsigned long long uq(unsigned long long x) { return x / 1U; }
unsigned long long ur(unsigned long long x) { return x % 1U; }
long long sideq(void) { return source() / 1; }
unsigned long long usideq(void) { return usource() / 1U; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" "-x=$cpu" -S -R="test-$cpu" test.c >/dev/null)
    asm="$TMP/test-$cpu.s"
    grep '%DIDIV' "$asm" >/dev/null && {
        echo "DImode division by one retained restoring divider on $cpu" >&2
        exit 1
    }
    awk '
      /^sq:|^uq:/ { f="q"; next }
      /^sr:|^ur:/ { f="r"; next }
      /^sideq:|^usideq:/ { f=""; next }
      /^[A-Za-z_][A-Za-z0-9_]*:/ { f="" }
      f == "q" && toupper($1) == "SETZ" { qsetz++ }
      f == "r" && toupper($1) == "SETZ" { rsetz++ }
      END {
        if (qsetz != 0 || rsetz != 4)
          exit 1
      }
    ' "$asm" || {
        echo "DImode /1 or %1 identity regression failed on $cpu" >&2
        exit 1
    }
    [ "$(grep -Ec '^[[:space:]]*jrst[[:space:]]+(source|usource)$' "$asm")" -eq 2 ] || {
        echo "DImode /1 dropped dividend call evaluation on $cpu" >&2
        exit 1
    }
done
printf '%s\n' 'DImode division and remainder by one regression passed'
