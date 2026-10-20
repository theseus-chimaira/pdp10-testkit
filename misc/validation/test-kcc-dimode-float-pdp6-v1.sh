#!/bin/sh
# PDP-6 integer-only, software D-format 71-bit conversion acceptance.
# Does NOT imply native PDP-6 hardware FP or later PDP-10 FP support.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-kcc-dimode-float-pdp6-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

kcc=${KCC_BIN:-$KCC}
lib="$KCC_LIBDIR/freestanding/kcc-libc-dimode-float-pdp6-v1.s"
test -f "$lib"

for mode in opt noopt; do
    flags=
    if [ "$mode" = noopt ]; then
        flags=-n
    fi
    "$kcc" -S -v=nostats -x=pdp6 $flags \
        -o "$work/df-$mode.s" \
        "$root/tests/semantic/kcc-dimode-float-pdp6-v1.c"
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 2000000 --timeout 35 \
        --workdir "$work/run-$mode" \
        --name "kcc-pdp6-dimode-float-$mode-v1" \
        --expect __test_exit=0 --expect df_case_index_v1=021 \
        --expect df_fraction_case_index_v1=012 \
        "$root/support/crt0-upstream-v1.s" \
        "$work/df-$mode.s" "$lib" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    echo "PASS KCC PDP-6 software D-format ($mode)"
done
