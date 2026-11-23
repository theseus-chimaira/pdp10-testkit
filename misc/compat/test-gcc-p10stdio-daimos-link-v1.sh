#!/bin/sh
# Check archive extraction against the genuine DAIMOS WRITECHAR veneer.
# This is a link test, not evidence of guest execution or GCC/KCC ABI parity.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-stdio-daimos-link-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
libdir="$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/freestanding"
for name in libp10stdio-daimos-v1.a libp10stdio-v2.a libp10c-v2.a; do
    test -f "$libdir/$name" || { echo "missing $name" >&2; exit 2; }
done
"$PDP10_GCC" -std=c89 -ffreestanding -fno-builtin -march=pdp6 \
    -O0 -I "$PDP10_PREFIX/pdp10-dec-none/include" \
    -S "$root/misc/compat/gcc-p10stdio-daimos-link-v1.c" \
    -o "$work/client.s"
"$PDP10_PREFIX/bin/das" -F -C -O "$work/client.dobj" "$work/client.s"
"$PDP10_PREFIX/bin/das" -F -C -O "$work/syscall.dobj" \
    "$root/../DAIMOS/userland/libc/syscall.s"
for name in crt0-upstream exit abort; do
    "$PDP10_PREFIX/bin/das" -F -C -O "$work/$name.dobj" \
        "$root/support/$name-v1.s"
done
libgcc=$("$PDP10_GCC" -print-libgcc-file-name)
"$PDP10_PREFIX/bin/dlink" --daimos-uuo-relax -b 01000 \
    -o "$work/client.dxr" -M "$work/client.map" \
    "$work/crt0-upstream.dobj" "$work/client.dobj" \
    "$work/exit.dobj" "$work/abort.dobj" \
    "$libdir/libp10stdio-daimos-v1.a" "$libdir/libp10stdio-v2.a" \
    "$work/syscall.dobj" "$libdir/libp10c-v2.a" "$libgcc"
# A DAIMOS console archive must not silently become a bare-metal libc.
# Without the monitor veneer, its WRITECHAR dependency must stay unresolved.
if "$PDP10_PREFIX/bin/dlink" --daimos-uuo-relax -b 01000 \
    -o "$work/no-veneer.dxr" \
    "$work/crt0-upstream.dobj" "$work/client.dobj" \
    "$work/exit.dobj" "$work/abort.dobj" \
    "$libdir/libp10stdio-daimos-v1.a" "$libdir/libp10stdio-v2.a" \
    "$libdir/libp10c-v2.a" "$libgcc" \
    >"$work/no-veneer.log" 2>&1; then
    echo 'unexpected successful link without DAIMOS syscall veneer' >&2
    exit 1
fi
for symbol in printf vprintf putchar puts dsys_writechar __p10stdio_vformat_v2; do
    grep -q "^$symbol[[:space:]]" "$work/client.map" || {
        echo "missing linked symbol: $symbol" >&2; exit 1;
    }
done
printf '%s\n' 'PASS: GCC console archives link with real DAIMOS syscall veneer'
