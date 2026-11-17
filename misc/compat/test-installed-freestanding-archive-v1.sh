#!/bin/sh
# Verify installed KCC/GCC headers, selective DARC extraction and real PDP-6 calls.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env

: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-installed-libp10c-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

libdir="$KCC_LIBDIR/freestanding"
klib="$libdir/libp10c-v2.a"
gccdir="$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2"
glib="$gccdir/freestanding/libp10c-v2.a"
libgcc="$gccdir/libgcc.a"
src="$root/misc/compat/installed-freestanding-archive-v1.c"

for file in "$KCC_LIBDIR/include/string.h" \
            "$PDP10_PREFIX/pdp10-dec-none/include/string.h" \
            "$PDP10_PREFIX/bin/das" "$PDP10_PREFIX/bin/dlink" \
            "$klib" "$glib" "$libgcc"; do
    if [ ! -f "$file" ]; then
        echo "missing installed freestanding prerequisite: $file" >&2
        exit 2
    fi
done
cmp "$klib" "$glib"

for sym in memcpy strlen strcmp strstr; do
    test -f "$libdir/kcc-libc-$sym-v1.s" || {
        echo "missing installed runtime source: $sym" >&2
        exit 2
    }
done
"$PDP10_PREFIX/bin/das" -F -C -O "$work/crt.dobj" \
    "$root/support/crt0-upstream-v1.s"

for compiler in kcc gcc; do
    asm="$work/$compiler.s"
    obj="$work/$compiler.dobj"
    map="$work/$compiler.map"
    image="$work/$compiler.dxr"
    case "$compiler" in
        kcc)
            "$KCC" -S -v=nostats -x=pdp6 -m=gas \
                -I"$KCC_LIBDIR/include" -o "$asm" "$src"
            library=$klib
            ;;
        gcc)
            # GCC's installed string.h uses C99 'restrict'.
            "$PDP10_GCC" -S -std=gnu99 -O0 -fno-builtin \
                -march=pdp6 -o "$asm" "$src"
            library=$glib
            ;;
    esac
    "$PDP10_PREFIX/bin/das" -F -C -O "$obj" "$asm"
    if [ "$compiler" = gcc ]; then
        "$PDP10_PREFIX/bin/dlink" -b 020 -M "$map" -o "$image" \
            "$work/crt.dobj" "$obj" "$library" "$libgcc"
        grep -q '^__main[[:space:]]' "$map"
    else
        "$PDP10_PREFIX/bin/dlink" -b 020 -M "$map" -o "$image" \
            "$work/crt.dobj" "$obj" "$library"
    fi
    test -s "$image"
    for sym in memcpy strlen strcmp strstr; do
        grep -q "^$sym[[:space:]]" "$map" || {
            echo "archive did not extract $sym for $compiler" >&2
            exit 1
        }
    done
    # No unrelated archive member may increase this tiny program's RAM use.
    if grep -Eq '^(memset|memmove|strspn|strpbrk|p10bcopy_v2)[[:space:]]' "$map"; then
        echo "unneeded archive member extracted for $compiler" >&2
        exit 1
    fi
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 1000000 --timeout 25 \
        --workdir "$work/run-$compiler" \
        --name "installed-libp10c-$compiler-v1" \
        --expect __test_exit=0 \
        "$root/support/crt0-upstream-v1.s" "$asm" \
        "$libdir/kcc-libc-memcpy-v1.s" \
        "$libdir/kcc-libc-strlen-v1.s" \
        "$libdir/kcc-libc-strcmp-v1.s" \
        "$libdir/kcc-libc-strstr-v1.s"
    echo "PASS installed $compiler archive extraction and PDP-6 libc ABI"
done
