#!/bin/sh
# Exercise version 2 GCC/PDP-10 memory formatter through a real guest.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-gcc-p10stdio-v2.XXXXXXXX")
if [ "${P10_STDIO_KEEP_WORK:-0}" != 1 ]; then
    trap 'rm -rf "$work"' EXIT HUP INT TERM
else
    echo "stdio evidence directory: $work"
fi

libdir="$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/freestanding"
for file in "$PDP10_PREFIX/pdp10-dec-none/include/stdio.h" \
            "$libdir/p10stdio-format-v2.s" \
            "$libdir/libp10stdio-v2.a" \
            "$PDP10_PREFIX/lib/libc.a" \
            "$PDP10_PREFIX/bin/pdp10-dec-none-gcc"; do
    if [ ! -f "$file" ]; then
        echo "missing installed GCC stdio implementation: $file" >&2
        exit 2
    fi
done

# The real DARC library must extract the GCC implementation when it is
# listed before the unrelated KCC/DAIMOS hosted libc.  A header-only
# implementation or an accidental KCC sprintf is not acceptable.
libgcc=$("$PDP10_GCC" -print-libgcc-file-name)
test -f "$libgcc" || {
    echo "missing installed GCC libgcc archive: $libgcc" >&2
    exit 2
}
"$PDP10_GCC" -std=c89 -ffreestanding -fno-builtin -march=pdp6 \
    -O0 -S "$root/misc/compat/gcc-p10stdio-memory-v1.c" \
    -o "$work/archive-client-v1.s"
"$PDP10_PREFIX/bin/das" -F -C -O \
    "$work/archive-client-v1.dobj" "$work/archive-client-v1.s"
for name in crt0-upstream exit abort; do
    "$PDP10_PREFIX/bin/das" -F -C -O "$work/$name-v1.dobj" \
        "$root/support/$name-v1.s"
done
"$PDP10_PREFIX/bin/dlink" -b 01000 \
    -o "$work/libp10stdio-extraction-v2.dxr" \
    -M "$work/libp10stdio-extraction-v2.map" \
    "$work/crt0-upstream-v1.dobj" "$work/archive-client-v1.dobj" \
    "$work/exit-v1.dobj" "$work/abort-v1.dobj" \
    "$libdir/libp10stdio-v2.a" "$PDP10_PREFIX/lib/libc.a" \
    "$libgcc"
for symbol in sprintf vsprintf snprintf vsnprintf; do
    grep -q "^$symbol[[:space:]]" \
        "$work/libp10stdio-extraction-v2.map" || {
        echo "real GCC stdio archive member not extracted: $symbol" >&2
        exit 1
    }
done
echo "PASS GCC stdio production archive extraction"

for machine in pdp6 ka10 ki10 ks10; do
    for profile in O0 O2; do
        echo "CHECK gcc stdio $machine $profile"
        "$P10RUN" --machine "$machine" --mode deposit --exec-mode step \
            --step-limit 100000000 --timeout 25 \
            --workdir "$work/run-$machine-$profile" \
            --name "gcc-p10stdio-$machine-$profile-v2" \
            --gcc-extra "-$profile" \
            --expect __test_exit=0 --expect fail_id=0 \
            "$root/support/crt0-upstream-v1.s" \
            "$root/misc/compat/gcc-p10stdio-memory-v1.c" \
            "$root/support/exit-v1.s" "$root/support/abort-v1.s" \
            "$libdir/p10stdio-format-v2.s"
        # The historical source has its own real hosted libc output
        # checks.  It is not allowed to substitute the KCC varargs ABI.
        "$P10RUN" --machine "$machine" --mode deposit --exec-mode step \
            --step-limit 100000000 --timeout 25 \
            --workdir "$work/original-$machine-$profile" \
            --name "gcc-p10stdio-original-$machine-$profile-v2" \
            --gcc-extra "-$profile" --expect __test_exit=0 \
            "$root/support/crt0-upstream-v1.s" \
            "$root/tests/todo/generic/920726-1.c" \
            "$root/support/exit-v1.s" "$root/support/abort-v1.s" \
            "$libdir/p10stdio-format-v2.s"
    done
done
echo "PASS GCC PDP10 stdio v2: 16 native guest cells and archive extraction"
