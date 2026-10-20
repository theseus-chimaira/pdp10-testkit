#!/bin/sh
# C99 PDP-6 27-bit single-float compile-time folding and runtime agreement.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-kcc-float-fold-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
kcc=${KCC_BIN:-$KCC}

for mode in opt noopt; do
    flags=
    [ "$mode" = noopt ] && flags=-n
    "$kcc" -S -v=nostats -x=pdp6 $flags \
        -o "$work/float-fold-$mode.s" \
        "$root/tests/semantic/kcc-pdp6-float-fold-v1.c"
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 900000 --timeout 35 \
        --workdir "$work/run-$mode" \
        --name "kcc-pdp6-float-fold-$mode-v1" \
        --expect __test_exit=0 --expect kff_case_v1=024 \
        --expect kff_cmp_v1=1 \
        "$root/support/crt0-upstream-v1.s" \
        "$work/float-fold-$mode.s" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    echo "PASS KCC PDP-6 target-precision float folding ($mode)"
done
