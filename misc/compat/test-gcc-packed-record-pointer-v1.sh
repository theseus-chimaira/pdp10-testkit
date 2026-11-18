#!/bin/sh
# Preserve the complete GCC PDP-10 packed-record byte-pointer contract.
# All original assertions remain enabled, including pointer stepping,
# stores through a pointer and cross-word reads at constant array indices.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env

: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-gcc-packed-record-pointer-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

for cpu in pdp6 ka10 ki10 ks10; do
    for opt in O0 O1 O2 Os; do
        for name in original extended; do
            if [ "$name" = original ]; then
                source="$root/misc/compat/packed-char.c"
            else
                source="$root/misc/compat/gcc-packed-record-pointer-v1.c"
            fi
            asm="$work/$name-$cpu-$opt.s"
            "$PDP10_GCC" -S "-$opt" "-march=$cpu" -o "$asm" "$source"
            "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
                --step-limit 2000000 --timeout 20 \
                --workdir "$work/run-$name-$cpu-$opt" \
                --name "packed-record-$name-$cpu-$opt-v1" \
                --expect __test_exit=0 \
                "$root/support/crt0.s" "$asm"
            echo "PASS GCC packed record: $name $cpu $opt"
        done
    done
done
