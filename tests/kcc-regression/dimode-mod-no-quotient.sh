#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-di-mod-no-quotient-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat >"$TMP/test.c" <<'SRC'
long long sr(long long a, long long b) { return a % b; }
unsigned long long ur(unsigned long long a, unsigned long long b) { return a % b; }
SRC

for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" "-x=$cpu" -S -R="test-$cpu" test.c >/dev/null)
    asm="$TMP/test-$cpu.s"
    awk '
      /^sr:/ { f="sr"; next }
      /^ur:/ { f="ur"; next }
      /^%DIDIV[0-9]+L:/ { loop=1; next }
      loop && /^%DIDIV[0-9]+NS:/ { loop=0; f=""; next }
      loop && /^[[:space:]]*IORI[[:space:]]/ { iori[f]++ }
      loop && /^[[:space:]]*SETZ[[:space:]]/ { setz[f]++ }
      END {
        if (iori["sr"] != 0 || iori["ur"] != 0)
          exit 1
      }
    ' "$asm" || {
        echo "$cpu: DImode remainder still maintains discarded quotient state" >&2
        exit 1
    }
    for fn in sr ur; do
        awk -v fn="$fn" '
          $0 == fn ":" { in_fn=1; next }
          in_fn && /^%DIDIV[0-9]+L:/ { found=1; exit }
          in_fn && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
          in_fn && /^[[:space:]]*(PUSH|POP)[[:space:]]/ { bad=1 }
          END { exit !(found && !bad) }
        ' "$asm" || {
            echo "$cpu: $fn did not retain the register-resident remainder path" >&2
            exit 1
        }
    done
done

printf '%s\n' 'DImode remainder quotient-state elimination regression passed'
