#!/bin/sh
# Verify the actual return PC, not just equality of two builtin results.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/kcc-return-address-v59q.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
PDP10_PREFIX=$(PYTHONPATH="$root/tools" python3 - "$work" "$PDP10_PREFIX" <<'PY'
import sys
from compiler_stdlib_prefix_v1 import prepare_script_prefix
print(prepare_script_prefix(sys.argv[1], sys.argv[2], 'kcc'))
PY
)
export PDP10_PREFIX
pdp10_setup_env
for target in base pdp6 ka10 ki10 ks10; do
    machine=$target
    if [ "$target" = base ]; then machine=ks10; fi
    for mode in opt noopt; do
        set --
        if [ "$mode" = noopt ]; then set -- -n; fi
        asm="$work/kcc-$target-$mode.s"
        "$KCC" -S -v=nostats -x="$target" -m=gas "$@" \
            -o "$asm" "$root/misc/compat/kcc-return-address-v59q.c" \
            > "$work/compile-$target-$mode.log" 2>&1
        grep 'Unsupported __builtin_return_address frame level' "$work/compile-$target-$mode.log"
        if grep -Ei '(^|[[:space:],])(alloca|__builtin_return_address)([[:space:],]|$)' "$asm"; then
            echo 'unexpected external builtin reference' >&2
            exit 1
        fi
        "$P10RUN" --machine "$machine" --mode deposit --exec-mode step \
            --step-limit 5000000 --timeout 18 \
            --workdir "$work/run-$target-$mode" \
            --name "kcc-return-address-$target-$mode-v59q" \
            --expect __test_exit=0 --expect fail_id=0 \
            "$root/support/crt0-upstream-v1.s" \
            "$root/misc/compat/kcc-return-address-oracle-v59q.s" "$asm"
        echo "PASS exact KCC return PC: $target $mode $machine"
    done
done
