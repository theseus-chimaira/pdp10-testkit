#!/bin/sh
# PDP-6 regression for original upstream GCC 930622-2.
# Compile and execute unchanged under both KCC optimization modes.
# The software D-format implementation is not PDP-6 native floating point
# and is not evidence of KA10/KI10/KS10/KL10 conversion correctness.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-kcc-71bit-floatcast-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
kcc=${KCC_BIN:-$KCC}
source="$root/tests/semantic/upstream/wide-int/930622-2.c"
# PDP-6 software D-format is a standalone integer-only library member.
# The generic p10run driver injects libgcc, not the complete KCC
# freestanding archive.  Link the installed production member explicitly.
floatlib="$KCC_LIBDIR/freestanding/kcc-libc-dimode-float-pdp6-v1.s"
test -f "$floatlib"

for mode in opt noopt; do
    flags=
    if [ "$mode" = noopt ]; then
        flags=-n
    fi
    "$kcc" -S -v=nostats -x=pdp6 $flags \
        -o "$work/930622-2-$mode.s" "$source"
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 4000000 --timeout 35 \
        --workdir "$work/run-$mode" \
        --name "kcc-71bit-floatcast-$mode-v1" --expect __test_exit=0 \
        "$root/support/crt0-upstream-v1.s" \
        "$work/930622-2-$mode.s" \
        "$floatlib" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    echo "PASS KCC upstream 930622-2 $mode PDP-6"
done
