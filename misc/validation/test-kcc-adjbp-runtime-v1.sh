#!/bin/sh
set -eu

# Run the installed KCC signed byte-pointer adjustment helpers on real
# PDP-10 instruction-set simulators.  The assembly fixture also verifies
# preservation of the caller's scratch accumulators.

if [ -z "${TMPDIR:-}" ]; then
    TMPDIR="$HOME/tmp"
fi
mkdir -p "$TMPDIR"
PDP10_PREFIX="${PDP10_PREFIX:-$HOME/cross}"
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root=$(CDPATH= cd -- "$here/../.." && pwd)
p10run="$PDP10_PREFIX/bin/p10run"
fixture="$here/kcc-adjbp-runtime-v1.s"
scratch=$(mktemp -d "$TMPDIR/p10tk-adjbp-runtime-v1.XXXXXX")
trap 'rm -rf "$scratch"' EXIT HUP INT TERM

# A raw p10run invocation must not resolve the operating-system libc.a.
# Prepare the same compiler-only runtime overlay used by other isolated
# testkit guest fixtures, even though this fixture currently needs no libc.
compiler_prefix=$(
    P10TK_ADJBP_RUNTIME_OUT="$scratch" \
    PYTHONPATH="$root/tools${PYTHONPATH:+:$PYTHONPATH}" \
    python3 -c 'import os
from compiler_stdlib_prefix_v1 import prepare_script_prefix
print(prepare_script_prefix(os.environ["P10TK_ADJBP_RUNTIME_OUT"],
                            os.environ["PDP10_PREFIX"], "kcc"))'
)

for cpu in pdp6 ka10 ks10; do
    runtime="$PDP10_PREFIX/lib/kcc/${cpu}rt-adjbp.s"
    mkdir -p "$scratch/run-$cpu"
    if PDP10_PREFIX="$compiler_prefix" "$p10run" \
        --machine "$cpu" --mode deposit --exec-mode step \
        --step-limit 100000000 --timeout 18 \
        --workdir "$scratch/run-$cpu" --name kcc_adjp_runtime_v1 \
        --expect __test_exit=0 \
        "$root/support/crt0-upstream-v1.s" "$fixture" "$runtime" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s" \
        >"$scratch/$cpu.log" 2>&1; then
        printf 'PASS: signed ADJBP runtime on %s\n' "$cpu"
    else
        cat "$scratch/$cpu.log"
        printf 'FAIL: signed ADJBP runtime on %s (logs: %s)\n' \
            "$cpu" "$scratch" >&2
        exit 1
    fi
done
