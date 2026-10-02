#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/p10tk-gcc-cross-word-bitfield-v26-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

for opt in 0 1; do
    asm=$tmp/cross-o$opt.s
    "$PDP10_GCC" -S -O$opt -o "$asm" \
        "$root/tests/compat/gcc-cross-word-bitfield-v26.c"
    "$P10RUN" --machine ks10 --mode deposit --exec-mode step \
        --step-limit 1000000 --timeout 20 --workdir "$tmp/run-o$opt" \
        --name "gcc-cross-word-bitfield-o$opt" --expect __test_exit=0 \
        "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
        "$asm" "$KCC_RT" >/dev/null
done

echo "GCC cross-word bit-field stores preserve adjacent fields: PASS"
