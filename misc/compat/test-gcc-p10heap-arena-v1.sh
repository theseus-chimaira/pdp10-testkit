#!/bin/sh
# Targeted real freestanding allocator guest and archive-extraction checks.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-gcc-heap-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
libdir="$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/freestanding"
heap="$libdir/libp10heap-arena-v1.a"
source="$libdir/p10heap-arena-v1.s"
header="$PDP10_PREFIX/pdp10-dec-none/include"
libgcc=$("$PDP10_GCC" -print-libgcc-file-name)
for file in "$heap" "$source" "$header/p10heap-arena-v1.h"; do
    test -f "$file" || { echo "missing allocator: $file" >&2; exit 2; }
done
for cpu in pdp6 ka10 ki10 ks10; do
    for opt in O0 O2; do
        "$PDP10_GCC" -std=c89 -ffreestanding -fno-builtin \
            -march="$cpu" -"$opt" -I "$root/support/include" \
            -I "$header" -S "$root/misc/compat/gcc-p10heap-arena-v1.c" \
            -o "$work/client-$cpu-$opt.s"
        "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
            --step-limit 3000000 --timeout 25 \
            --workdir "$work/run-$cpu-$opt" \
            --name "gcc-heap-$cpu-$opt-v1" --expect __test_exit=0 \
            "$root/support/crt0-upstream-v1.s" \
            "$work/client-$cpu-$opt.s" "$source" \
            "$root/support/exit-v1.s" "$root/support/abort-v1.s"
        echo "PASS: GCC heap $cpu $opt"
    done
done
"$PDP10_PREFIX/bin/das" -F -C -O "$work/client.dobj" \
    "$work/client-pdp6-O0.s"
for name in crt0-upstream exit abort; do
    "$PDP10_PREFIX/bin/das" -F -C -O "$work/$name-v1.dobj" \
        "$root/support/$name-v1.s"
done
"$PDP10_PREFIX/bin/dlink" -b 01000 -o "$work/archive.dxr" \
    -M "$work/archive.map" "$work/crt0-upstream-v1.dobj" \
    "$work/client.dobj" "$work/exit-v1.dobj" "$work/abort-v1.dobj" \
    "$heap" "$libgcc"
for symbol in malloc free calloc realloc p10heap_init_v1; do
    grep -q "^$symbol[[:space:]]" "$work/archive.map" || {
        echo "allocator archive did not extract $symbol" >&2; exit 1;
    }
done
echo 'PASS: GCC heap archive extraction'
