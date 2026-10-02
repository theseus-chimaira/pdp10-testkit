#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-packed-bitptr-v22-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -I"$root/support/common/" -R=p10pbv22 \
        "$root/tests/compat/packed-bitptr-v22.c"
)
"$PDP10_GCC" -I"$root/support/common" -S -O1 -march=pdp6 -o "$tmp/gcc-packed-bitptr-v22.s" \
    "$root/tests/compat/packed-bitptr-v22.c"

"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run-kcc" \
    --name packed-bitptr-kcc-v22 --expect __test_exit=0 \
    "$root/support/crt0.s" "$tmp/p10pbv22.s" "$KCC_RT" >/dev/null
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run-gcc" \
    --name packed-bitptr-gcc-v22 --expect __test_exit=0 \
    "$root/support/crt0.s" "$tmp/gcc-packed-bitptr-v22.s" \
    "$root/tests/compat/mixed-call-support.s" "$KCC_RT" >/dev/null

echo "packed logical pointer GCC/KCC ABI/runtime: PASS"
