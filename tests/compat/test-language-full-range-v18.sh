#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-language-v18-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -I"$root/support/common/" -R=p10fr18 \
        "$root/tests/compat/language-full-range-v18.c"
)
"$PDP10_GCC" -I"$root/support/common" -S -O1 -march=pdp6 -mlong-long-71bit -o "$tmp/gcc-full-range-v18.s" \
    "$root/tests/compat/language-full-range-v18.c"
for cc in kcc gcc; do
    if test "$cc" = kcc; then
        asm="$tmp/p10fr18.s"
    else
        asm="$tmp/gcc-full-range-v18.s"
    fi
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 2000000 --timeout 30 --workdir "$tmp/run-$cc" \
        --name language-full-range-$cc-v18 --expect __test_exit=0 \
        "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
        "$asm" "$KCC_RT" >/dev/null
done
echo "full-range 36-bit and 71-bit conversion helpers: PASS"
