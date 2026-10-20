#!/bin/sh
# Expected-to-fail manually registered SIMH/AAP native FP disagreement.
# Do NOT convert this into an expected-failure PASS; it is a genuine
# emulator discrepancy requiring an independently validated correction.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-pdp6-negative-fp-runtime-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

kcc=${KCC_BIN:-$KCC}
for mode in opt noopt; do
    flags=
    [ "$mode" = noopt ] && flags=-n
    "$kcc" -S -v=nostats -x=pdp6 $flags \
        -o "$work/negative-$mode.s" \
        "$root/tests/semantic/kcc-pdp6-negative-fp-runtime-v1.c"
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 300000 --timeout 30 \
        --workdir "$work/run-$mode" \
        --name "pdp6-negative-fp-runtime-$mode-v1" \
        --expect __test_exit=0 \
        "$root/support/crt0-upstream-v1.s" \
        "$work/negative-$mode.s" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
done
echo 'PASS independent PDP-6 negative rounded floating arithmetic'
