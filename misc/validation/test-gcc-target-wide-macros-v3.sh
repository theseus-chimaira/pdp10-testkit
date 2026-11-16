#!/bin/sh
# Keep both GCC 71/72-bit feature-macro and assembly-generation assertions.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
: "${PDP10_PREFIX:?set PDP10_PREFIX to the installed toolchain}"
PDP10_GCC="$PDP10_PREFIX/bin/pdp10-dec-none-gcc"
[ -x "$PDP10_GCC" ] || { echo "missing GCC compiler: $PDP10_GCC" >&2; exit 1; }
TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"
export PDP10_GCC TMPDIR
exec sh "$root/refs/gcc-pdp10-target-v2/wide-int-mode-options.sh" \
    "$root/refs/gcc-pdp10-target-v2/wide-int-mode-macros.c"
