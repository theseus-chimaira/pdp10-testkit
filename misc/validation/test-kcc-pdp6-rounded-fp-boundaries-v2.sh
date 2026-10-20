#!/bin/sh
# 24 independently calculated native PDP-6 rounded-FP boundary cases.
# SIMH_PDP6 can select a candidate simulator without installing it.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-pdp6-rounded-fp-v2.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

for mode in opt noopt; do
    flags=
    [ "$mode" = noopt ] && flags=-n
    "$KCC" -S -v=nostats -x=pdp6 $flags \
        -o "$work/rounded-$mode-v2.s" \
        "$root/tests/semantic/kcc-pdp6-rounded-fp-boundaries-v2.c"
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 450000 --timeout 30 --workdir "$work/run-$mode" \
        --name "pdp6-rounded-fp-$mode-v2" \
        --expect __test_exit=0 --expect pdp6_fp_case_index_v2=030 \
        "$root/support/crt0-upstream-v1.s" \
        "$work/rounded-$mode-v2.s" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    echo "PASS PDP-6 rounded-FP boundary v2 ($mode, 24 cases)"
done
