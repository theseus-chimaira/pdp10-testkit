#!/bin/sh
# Execute an optimized local QI array boundary read on a real PDP-6 target.
# Regression against GCC's late conversion of a word MEM_OFFSET to a byte.
set -eu

: "${PDP10_PREFIX:?PDP10_PREFIX must be set}"
: "${TMPDIR:?TMPDIR must be set}"
self=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
work="$TMPDIR/pdp10-gcc-char-word-boundary-v46-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"
# Raw invocation must not use a possibly OS-owned prefix/lib/libc.a.
# The compiled source remains the historical v45 test fixture.
root=$(CDPATH= cd -- "$self/../.." && pwd -P)
compiler_prefix=$(
        P10TK_CHAR_RUNTIME_OUT="$work" \
        PYTHONPATH="$root/tools${PYTHONPATH:+:$PYTHONPATH}" \
        python3 -c 'import os
from compiler_stdlib_prefix_v1 import prepare_script_prefix
print(prepare_script_prefix(os.environ["P10TK_CHAR_RUNTIME_OUT"],
                            os.environ["PDP10_PREFIX"], "gcc"))'
)
cc=${PDP10_GCC:-$PDP10_PREFIX/bin/pdp10-dec-none-gcc}
set -- "$cc"
if [ -n "${PDP10_GCC_B:-}" ]; then
        set -- "$@" "-B$PDP10_GCC_B"
fi

for optimize in 0 1 2 s; do
        "$@" -std=c99 "-O$optimize" \
            -march=pdp6 -mcpu=pdp6 -S \
            "$self/pdp10-gcc-char-word-boundary-v45.c" -o "$work/main.s"
        PDP10_PREFIX="$compiler_prefix" TMPDIR="$work" \
            "$PDP10_PREFIX/bin/p10run" \
            --machine pdp6 --mode deposit --exec-mode step \
            --start 1000 --step-limit 200000 --timeout 15 \
            --workdir "$work/run-$optimize" \
            --name "pdp10-gcc-char-word-boundary-v46-O$optimize" \
            --expect __test_exit=0 \
            "$self/daimos-test-crt0-v1.s" \
            "$self/pdp10-gcc-char-word-boundary-helper-v45.s" \
            "$work/main.s" >/dev/null
        printf 'pdp10-gcc-char-word-boundary-v46: PASS -O%s\n' "$optimize"
done
