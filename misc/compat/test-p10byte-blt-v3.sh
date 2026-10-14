#!/bin/sh
# Long 6/9/18/36-bit packed-copy and fill BLT regression on baseline PDP-6.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
base=${TMPDIR:-$HOME/tmp}
mkdir -p "$base"
work=$(mktemp -d "$base/p10-byte-blt-v3.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
library=${KCC_FREESTANDING_DIR:-$PDP10_PREFIX/lib/kcc/freestanding}
for kind in blt blt-fill; do
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 100000 --timeout 12 \
        --workdir "$work/$kind" --name "p10-byte-$kind-v3" \
        --expect __test_exit=0 \
        "$root/support/crt0-upstream-v1.s" \
        "$root/tests/semantic/p10-byte-$kind-v3.s" \
        "$library/p10bytes-v2.s"
done
