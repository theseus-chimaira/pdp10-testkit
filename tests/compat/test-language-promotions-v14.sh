#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-language-v14-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -I"$root/support/common/" -R=p10prmv14 \
        "$root/tests/compat/language-promotions-v14.c"
)
"$PDP10_GCC" -I"$root/support/common" -S -O1 -o "$tmp/gcc-promotions-v14.s" \
    "$root/tests/compat/language-promotions-v14.c"
for cc in kcc gcc; do
    if test "$cc" = kcc; then asm="$tmp/p10prmv14.s"; else asm="$tmp/gcc-promotions-v14.s"; fi
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 1000000 --timeout 20 --workdir "$tmp/run-$cc" \
        --name language-promotions-$cc-v14 --expect __test_exit=0 \
        "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
        "$asm" "$KCC_RT" >/dev/null
done
echo "language promotions and constants: PASS"
