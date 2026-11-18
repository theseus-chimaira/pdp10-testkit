#!/bin/sh
# Real mixed KCC/GCC 71-bit ABI oracle for call-preserved divider scratch ACs.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env

: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-kcc-dimode-preserve-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

# The GCC caller retains argument pairs across the KCC division call.
# The unmodified original runtime-helper-main.c checks division followed
# by remainder, in both compiler directions. In particular, the KCC
# divider must not destroy AC10..AC14 that belong to the caller.
"$PDP10_GCC" -S -O1 -fno-inline -march=pdp6 -mlong-long-71bit \
    -o "$work/main.s" "$root/misc/compat/runtime-helper-main.c"
"$PDP10_GCC" -S -O1 -fno-inline -march=pdp6 -mlong-long-71bit \
    -o "$work/gcc.s" "$root/misc/compat/runtime-helper-gcc.c"

for target in base pdp6 ka10 ki10 ks10; do
    machine=$target
    if [ "$target" = base ]; then machine=ks10; fi
    for mode in opt noopt; do
        set --
        if [ "$mode" = noopt ]; then set -- -n; fi
        asm="$work/kcc-$target-$mode.s"
        "$KCC" -S -v=nostats -x="$target" -m=gas "$@" \
            -o "$asm" "$root/misc/compat/runtime-helper-kcc.c"
        "$P10RUN" --machine "$machine" --mode deposit --exec-mode step \
            --step-limit 5000000 --timeout 30 \
            --workdir "$work/run-$target-$mode" \
            --name "kcc-dimode-preserve-$target-$mode-v1" \
            --expect __test_exit=0 \
            "$root/support/crt0.s" "$work/main.s" "$asm" "$work/gcc.s"
        echo "PASS KCC DImode preserved scratch: $target $mode $machine"
    done
done
