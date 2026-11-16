#!/bin/sh
# Preserve the original GCC target libgcc octal-table source assertion.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
gcc_repo=${GCC_REPO:-$root/../gcc-pdp10}
source="$gcc_repo/gcc/config/pdp10/libgcc1.s"
[ -f "$source" ] || { echo "missing GCC source: $source" >&2; exit 1; }
exec sh "$root/refs/gcc-pdp10-target-v2/libgcc-badptr-octal.sh" "$source"
