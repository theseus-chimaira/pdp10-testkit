#!/bin/sh
# PDP-6 signed 71-bit integer <-> 36-bit native single-precision float.
# The software D-format helper remains a separate internal conversion step.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-nativefloat-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
kcc=${KCC_BIN:-$KCC}
library="$KCC_LIBDIR/freestanding/kcc-libc-dimode-float-pdp6-v1.s"
test -f "$library"

for mode in opt noopt; do
    flags=
    [ "$mode" = noopt ] && flags=-n
    "$kcc" -S -v=nostats -x=pdp6 $flags \
        -o "$work/native-float-$mode.s" \
        "$root/tests/semantic/kcc-pdp6-dimode-nativefloat-v1.c"
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 900000 --timeout 30 \
        --workdir "$work/run-$mode" \
        --name "kcc-pdp6-nativefloat-$mode-v1" \
        --expect __test_exit=0 --expect native_float_case_v1=025 \
        "$root/support/crt0-upstream-v1.s" \
        "$work/native-float-$mode.s" "$library" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    echo "PASS KCC PDP-6 signed DImode/native float ($mode)"
done
