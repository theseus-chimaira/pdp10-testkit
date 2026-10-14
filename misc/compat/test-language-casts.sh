#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10lc15-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/cast.c" <<'SRC'
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
 "$KCC" -S -x=pdp6 cast.c >/dev/null 2>&1
)
[ "$(grep -ci 'trne[[:space:]]*1,0*40$' "$tmp/cast.s")" -eq 1 ]
[ "$(grep -ci 'trne[[:space:]]*1,0*400$' "$tmp/cast.s")" -eq 1 ]
[ "$(grep -ci 'andi[[:space:]]*1,0*77$' "$tmp/cast.s")" -eq 2 ]
[ "$(grep -ci 'andi[[:space:]]*1,0*777$' "$tmp/cast.s")" -eq 2 ]
echo "narrow cast language compatibility: PASS"
