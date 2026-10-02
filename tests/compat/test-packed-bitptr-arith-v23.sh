#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-packed-bitptr-arith-v23-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -I"$root/support/common/" -R=p10pbav23 \
        "$root/tests/compat/packed-bitptr-arith-v23.c"
)
"$PDP10_GCC" -I"$root/support/common" -S -O1 -march=pdp6 \
    -o "$tmp/gcc-packed-bitptr-arith-v23.s" \
    "$root/tests/compat/packed-bitptr-arith-v23.c"

"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 3000000 --timeout 30 --workdir "$tmp/run-kcc" \
    --name packed-bitptr-arith-kcc-v23 --expect __test_exit=0 \
    "$root/support/crt0.s" "$tmp/p10pbav23.s" "$KCC_RT" >/dev/null
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 3000000 --timeout 30 --workdir "$tmp/run-gcc" \
    --name packed-bitptr-arith-gcc-v23 --expect __test_exit=0 \
    "$root/support/crt0.s" "$tmp/gcc-packed-bitptr-arith-v23.s" \
    "$root/tests/compat/mixed-call-support.s" "$KCC_RT" >/dev/null

echo "packed logical pointer arithmetic GCC/KCC ABI/runtime: PASS"
