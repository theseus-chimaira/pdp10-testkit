#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-di-div-one-scratch-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat >"$TMP/test.c" <<'SRC'
long long sq(long long a, long long b) { return a / b; }
long long sr(long long a, long long b) { return a % b; }
unsigned long long uq(unsigned long long a, unsigned long long b) { return a / b; }
unsigned long long ur(unsigned long long a, unsigned long long b) { return a % b; }
SRC

for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$TMP" && "$KCC" "-x=$cpu" -S -R="test-$cpu" test.c >/dev/null)
    asm="$TMP/test-$cpu.s"
    awk '
      /^sq:/ { f="sq"; next }
      /^sr:/ { f="sr"; next }
      /^uq:/ { f="uq"; next }
      /^ur:/ { f="ur"; next }
      /^%DIDIV[0-9]+L:/ { loop=1; next }
      loop && /^%DIDIV[0-9]+NS:/ { loop=0; next }
      loop && /^[[:space:]]*LSH[[:space:]][^,]+,-0?43/ { top[f]++ }
      loop && /^[[:space:]]*LSH[[:space:]][^,]+,-0?42/ { carrytmp[f]++ }
      loop && /^[[:space:]]*TLNN[[:space:]][^,]+,200000000000/ { direct[f]++ }
      END {
        if (top["sq"] != 1 || top["sr"] != 1 || top["uq"] != 1 || top["ur"] != 1)
          exit 1
        if (carrytmp["sq"] != 3 || carrytmp["uq"] != 3 ||
          carrytmp["sr"] != 2 || carrytmp["ur"] != 2)
          exit 1
        if (direct["sq"] || direct["uq"] || direct["sr"] || direct["ur"])
          exit 1
      }
    ' "$asm" || {
        echo "$cpu: DImode divider did not capture pair carries before shifting" >&2
        exit 1
    }
done

printf '%s\n' 'DImode divider pre-shift carry regression passed'
