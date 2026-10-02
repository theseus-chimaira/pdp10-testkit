#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-language-v17-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -I"$root/support/common/" -R=p10cnv17 \
        "$root/tests/compat/language-conversions-v17.c"
)
"$PDP10_GCC" -I"$root/support/common" -S -O1 -mlong-long-71bit -o "$tmp/gcc-conversions-v17.s" \
    "$root/tests/compat/language-conversions-v17.c"
for cc in kcc gcc; do
    if test "$cc" = kcc; then asm="$tmp/p10cnv17.s"; else asm="$tmp/gcc-conversions-v17.s"; fi
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 1500000 --timeout 30 --workdir "$tmp/run-$cc" \
        --name language-conversions-$cc-v17 --expect __test_exit=0 \
        "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
        "$asm" "$KCC_RT" >/dev/null
done
echo "36-bit, 71-bit, and narrow conversions: PASS"
