#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-language-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
(
 cd "$tmp"
 TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=p10ce20 \
   "$root/misc/compat/language-char-enum.c"
)
"$PDP10_GCC" -S -O1 -march=pdp6 -mlong-long-71bit \
 -o "$tmp/gcc-char-enum.s" \
 "$root/misc/compat/language-char-enum.c"
for cc in kcc gcc; do
 case "$cc" in
  kcc) asm="$tmp/p10ce20.s" ;;
  gcc) asm="$tmp/gcc-char-enum.s" ;;
 esac
 "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
  --step-limit 1000000 --timeout 30 --workdir "$tmp/run-$cc" \
  --name language-char-enum-$cc --expect __test_exit=0 \
  "$root/support/crt0.s" "$root/misc/compat/mixed-call-support.s" \
  "$asm" "$KCC_RT" >/dev/null
done
echo "plain char and enumeration language rules: PASS"
