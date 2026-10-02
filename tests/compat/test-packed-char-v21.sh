#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-packed-char-v21-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -I"$root/support/common/" -R=p10pkv21 \
        "$root/tests/compat/packed-char-v21.c"
)
"$PDP10_GCC" -I"$root/support/common" -S -O1 -o "$tmp/gcc-packed-v21.s" \
    "$root/tests/compat/packed-char-v21.c"

"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run-kcc" \
    --name packed-char-kcc-v21 --expect __test_exit=0 \
    "$root/support/crt0.s" "$tmp/p10pkv21.s" "$KCC_RT" >/dev/null
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run-gcc" \
    --name packed-char-gcc-v21 --expect __test_exit=0 \
    "$root/support/crt0.s" "$tmp/gcc-packed-v21.s" "$KCC_RT" >/dev/null

echo "packed char GCC/KCC ABI/runtime: PASS"
