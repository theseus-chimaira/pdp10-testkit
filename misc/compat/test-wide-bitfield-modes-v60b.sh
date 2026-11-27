#!/bin/sh
# The original and independently generated field oracles must also
# retain their separate raw72 semantics. No changes to the default matrix.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/wide-bitfield-modes-v60b.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
python3 "$root/tools/gen-wide-bitfield-oracle-v60b.py" --check
prefix=$(PYTHONPATH="$root/tools" python3 - "$work" "$PDP10_PREFIX" <<'PY'
import sys
from compiler_stdlib_prefix_v1 import prepare_script_prefix
print(prepare_script_prefix(sys.argv[1], sys.argv[2], 'gcc'))
PY
)
for cpu in pdp6 ka10 ki10 ks10; do
    for opt in O0 O2; do
        for source in pdp10-signed-bitfields-operations-v1 gcc-wide-bitfield-words-v60b; do
            name="$source-$cpu-$opt-raw72"
            asm="$work/$name.s"
            "$PDP10_GCC" -S -"$opt" -march="$cpu" -mlong-long-72bit \
                "$root/tests/semantic/regression/$source.c" -o "$asm"
            PDP10_PREFIX="$prefix" "$P10RUN" --machine "$cpu" \
                --mode deposit --exec-mode step --step-limit 100000000 --timeout 18 \
                --workdir "$work/$name" --name "$name" \
                --expect __test_exit=0 --expect fail_id=0 \
                "$root/support/crt0-upstream-v1.s" "$asm" \
                "$root/support/exit-v1.s" "$root/support/abort-v1.s"
        done
    done
done
