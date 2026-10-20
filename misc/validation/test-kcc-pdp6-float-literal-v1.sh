#!/bin/sh
# PDP-10 single-float literal encoding must preserve all 27 fraction bits.
# In particular, 134217732.0F must not round through host IEEE binary32.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-float-literal-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
kcc=${KCC_BIN:-$KCC}
for mode in opt noopt; do
    flags=
    [ "$mode" = noopt ] && flags=-n
    "$kcc" -S -v=nostats -x=pdp6 $flags \
        -o "$work/float-literal-$mode.s" \
        "$root/tests/semantic/kcc-pdp6-float-literal-v1.c"
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 300000 --timeout 30 --workdir "$work/run-$mode" \
        --name "kcc-float-literal-$mode-v1" \
        --expect __test_exit=0 --expect literal_case_v1=011 \
        "$root/support/crt0-upstream-v1.s" \
        "$work/float-literal-$mode.s" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    echo "PASS KCC PDP-6 single-float literal ($mode)"
done
