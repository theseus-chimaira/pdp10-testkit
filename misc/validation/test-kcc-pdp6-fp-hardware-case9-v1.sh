#!/bin/sh
# Type 166 native FADR case 9, original DEC FDAS/EMNF hardware result.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-pdp6-fp-hardware-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

for mode in opt noopt; do
    flags=
    [ "$mode" = noopt ] && flags=-n
    "$KCC" -S -v=nostats -x=pdp6 $flags \
        -o "$work/hardware-$mode-v1.s" \
        "$root/tests/semantic/kcc-pdp6-fp-hardware-case9-v1.c"
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 450000 --timeout 30 --workdir "$work/run-$mode" \
        --name "pdp6-fp-hardware-$mode-v1" \
        --expect __test_exit=0 --expect pdp6_fp_hardware_case_v1=1 \
        "$root/support/crt0-upstream-v1.s" \
        "$work/hardware-$mode-v1.s" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    echo "PASS PDP-6 Type 166 hardware FADR case 9 ($mode)"
done
