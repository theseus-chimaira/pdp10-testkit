#!/bin/sh
# Preserve libgcc's _eprintf/_bb exclusion and __gcc_bcmp retention oracle.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
gcc_repo=${GCC_REPO:-$root/../gcc-pdp10}
srcdir="$gcc_repo/gcc"
[ -f "$srcdir/config/pdp10/t-none" ] || {
    echo "missing GCC target make fragment: $srcdir/config/pdp10/t-none" >&2
    exit 1
}
[ -f "$srcdir/mklibgcc.in" ] || {
    echo "missing GCC libgcc generator: $srcdir/mklibgcc.in" >&2
    exit 1
}
export srcdir
exec sh "$root/refs/gcc-pdp10-target-v2/libgcc-empty-static-members.sh"
