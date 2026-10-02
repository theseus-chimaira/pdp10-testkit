#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-language-v19-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
(
 cd "$tmp"
 TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=p10dw19 \
   "$root/tests/compat/language-direct-widening-v19.c"
)
"$PDP10_GCC" -S -O1 -march=pdp6 -mlong-long-71bit \
 -o "$tmp/gcc-direct-widening-v19.s" \
 "$root/tests/compat/language-direct-widening-v19.c"
for cc in kcc gcc; do
 case "$cc" in
  kcc) asm="$tmp/p10dw19.s" ;;
  gcc) asm="$tmp/gcc-direct-widening-v19.s" ;;
 esac
 "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
  --step-limit 2000000 --timeout 30 --workdir "$tmp/run-$cc" \
  --name language-direct-widening-$cc-v19 --expect __test_exit=0 \
  "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
  "$asm" "$KCC_RT" >/dev/null
done
echo "direct 36-to-71-bit widening: PASS"
