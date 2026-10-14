#!/bin/sh
# PDP-6 packed byte-pointer width, word-copy and unsigned-compare regression.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env

tmpbase=${TMPDIR:-$HOME/tmp}
mkdir -p "$tmpbase"
work=$(mktemp -d "$tmpbase/p10tk-byte-widths-v2.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

library=${KCC_FREESTANDING_DIR:-$PDP10_PREFIX/lib/kcc/freestanding}
if [ ! -f "$library/p10bytes-v2.s" ]; then
    echo "missing installed packed-byte primitives: $library/p10bytes-v2.s" >&2
    exit 2
fi

"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 100000 --timeout 12 \
    --workdir "$work/run" --name p10byte-widths-v2 \
    --expect __test_exit=0 \
    "$root/support/crt0-upstream-v1.s" \
    "$root/tests/semantic/p10-byte-pointer-widths-v2.s" \
    "$library/p10bytes-v2.s"
