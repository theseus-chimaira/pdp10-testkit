#!/bin/sh
# Check the actual preserved registers and stack across normal, tail and VLA returns.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/kcc-induction-abi-v59w.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
PDP10_PREFIX=$(PYTHONPATH="$root/tools" python3 - "$work" "$PDP10_PREFIX" <<'PY'
import sys
from compiler_stdlib_prefix_v1 import prepare_script_prefix
print(prepare_script_prefix(sys.argv[1], sys.argv[2], 'kcc'))
PY
)
export PDP10_PREFIX
pdp10_setup_env
for cpu in pdp6 ka10 ki10 ks10; do
    for mode in opt noopt; do
        set --
        if [ "$mode" = noopt ]; then set -- -n -DINDUCTION_NOOPT; fi
        asm="$work/$cpu-$mode.s"
        "$KCC" -S -v=nostats -m=gas -x="$cpu" "$@" \
            -o "$asm" "$root/misc/compat/kcc-induction-abi-v59w.c"
        if [ "$mode" = opt ]; then
            grep -Ei 'addi[[:space:]]+0?1[0-4],1' "$asm"
            grep -Ei 'jrst[[:space:]]+ind_tail_target' "$asm"
        fi
        "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
            --step-limit 5000000 --timeout 18 --workdir "$work/run-$cpu-$mode" \
            --name "kcc-induction-abi-$cpu-$mode-v59w" \
            --expect __test_exit=0 --expect fail_id=0 \
            "$root/support/crt0-upstream-v1.s" \
            "$root/misc/compat/kcc-induction-abi-oracle-v59w.s" "$asm"
    done
done
