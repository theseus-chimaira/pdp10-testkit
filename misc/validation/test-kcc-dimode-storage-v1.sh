#!/bin/sh
# PDP-6 KCC signed DImode automatic-load and D-format negation regressions.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-kcc-dimode-storage-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
kcc=${KCC_BIN:-$KCC}

for source in kcc-dimode-local-load-v1 kcc-dformat-negative-v1; do
    for profile in opt noopt; do
        flags=
        if [ "$profile" = noopt ]; then
            flags=-n
        fi
        "$kcc" -S -v=nostats -x=pdp6 $flags \
            -o "$work/$source-$profile.s" \
            "$root/tests/semantic/$source.c"
        "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
            --step-limit 500000 --timeout 22 \
            --workdir "$work/run-$source-$profile" \
            --name "$source-$profile" --expect __test_exit=0 \
            "$root/support/crt0-upstream-v1.s" \
            "$work/$source-$profile.s" \
            "$root/support/exit-v1.s" "$root/support/abort-v1.s"
        echo "PASS KCC $source $profile PDP-6"
    done
done
