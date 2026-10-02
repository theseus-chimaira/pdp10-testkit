#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-language-v13-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -I"$root/support/common/" -R=p10lngv13 \
        "$root/tests/compat/language-narrow-v13.c"
)
"$PDP10_GCC" -I"$root/support/common" -S -O1 -o "$tmp/gcc-language-v13.s" \
    "$root/tests/compat/language-narrow-v13.c"

"$P10RUN" --machine ks10 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run-kcc" \
    --name language-kcc-v13 --expect __test_exit=0 \
    "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
    "$tmp/p10lngv13.s" "$KCC_RT" >/dev/null
"$P10RUN" --machine ks10 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run-gcc" \
    --name language-gcc-v13 --expect __test_exit=0 \
    "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
    "$tmp/gcc-language-v13.s" "$KCC_RT" >/dev/null

if (
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -I"$root/support/common/" -R=p10atrv13 \
        "$root/tests/compat/language-attr-reject-v13.c"
) >/dev/null 2>&1; then
    echo "KCC accepted a semantic layout attribute that must be diagnosed" >&2
    exit 1
fi

"$PDP10_GCC" -I"$root/support/common" -S -O1 -o "$tmp/gcc-attr-v13.s" \
    "$root/tests/compat/language-attr-reject-v13.c"

echo "language exact-width and attribute policy: PASS"
