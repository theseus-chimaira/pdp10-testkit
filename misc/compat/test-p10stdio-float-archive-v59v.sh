#!/bin/sh
# Check the actual versioned DARC archive for each compiler, not a stub.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10stdio-float-archive-v59v.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
python3 "$root/tools/gen-p10stdio-float-oracle-v59v.py" --check
libgcc=$("$PDP10_GCC" -print-libgcc-file-name)
client="$root/tests/semantic/regression/pdp10-buffer-float-oracle-v59v.c"
for name in crt0-upstream exit abort; do
    "$PDP10_PREFIX/bin/das" -F -C -O "$work/$name.dobj" "$root/support/$name-v1.s"
done
for compiler in kcc gcc; do
    case $compiler in
        kcc)
            libdir="$KCC_LIBDIR/freestanding"
            "$KCC" -S -v=nostats -m=gas -x=pdp6 -n \
                -I"$KCC_LIBDIR/include" -o "$work/$compiler.s" "$client"
            ;;
        gcc)
            libdir="$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/freestanding"
            "$PDP10_GCC" -std=c99 -ffreestanding -fno-builtin -march=pdp6 \
                -O0 -S "$client" -o "$work/$compiler.s"
            ;;
    esac
    "$PDP10_PREFIX/bin/das" -F -C -O "$work/$compiler.dobj" "$work/$compiler.s"
    "$PDP10_PREFIX/bin/dlink" -b 01000 -o "$work/$compiler.dxr" \
        -M "$work/$compiler.map" "$work/crt0-upstream.dobj" \
        "$work/$compiler.dobj" "$work/exit.dobj" "$work/abort.dobj" \
        "$libdir/libp10stdio-v3.a" "$libdir/libp10c-v2.a" "$libgcc"
    for name in sprintf vsprintf snprintf vsnprintf; do
        grep -q "^$name[[:space:]]" "$work/$compiler.map"
    done
    if "$PDP10_PREFIX/bin/dlink" -b 01000 -o "$work/no-stdio-$compiler.dxr" \
        "$work/crt0-upstream.dobj" "$work/$compiler.dobj" \
        "$work/exit.dobj" "$work/abort.dobj" "$libdir/libp10c-v2.a" "$libgcc" \
        > "$work/no-stdio-$compiler.log" 2>&1; then
        echo "unexpected $compiler link without formatter archive" >&2
        exit 1
    fi
    grep -i 'sprintf' "$work/no-stdio-$compiler.log"
    echo "PASS $compiler v3 archive extraction and negative link"
done
