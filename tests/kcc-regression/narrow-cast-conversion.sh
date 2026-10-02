#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-narrow-cast-v1-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/ncast.c" <<'SRC'
typedef signed _KCCtype_char6 s6;
typedef unsigned _KCCtype_char6 u6;
typedef signed _KCCtype_char9 s9;
typedef unsigned _KCCtype_char9 u9;
int cs6(int x) { return (s6)x; }
int cu6(int x) { return (u6)x; }
int cs9(int x) { return (s9)x; }
int cu9(int x) { return (u9)x; }
SRC
(
 cd "$tmp"
 "$KCC" -S -x=pdp6 ncast.c >/dev/null 2>&1
)
# Signed casts must truncate and sign extend exactly once.
[ "$(grep -ci 'trne[[:space:]]*1,0*40$' "$tmp/ncast.s")" -eq 1 ]
[ "$(grep -ci 'trne[[:space:]]*1,0*400' "$tmp/ncast.s")" -eq 1 ]
# Unsigned casts must mask exactly once.
[ "$(grep -ci 'andi[[:space:]]*1,0*77$' "$tmp/ncast.s")" -eq 2 ]
[ "$(grep -ci 'andi[[:space:]]*1,0*777' "$tmp/ncast.s")" -eq 2 ]
echo "narrow cast conversion regression passed"
