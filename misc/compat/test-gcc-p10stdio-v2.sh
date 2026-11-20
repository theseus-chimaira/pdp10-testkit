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

# p10run also appends PDP10_PREFIX/lib/libc.a implicitly. A raw direct
# invocation must therefore isolate its guest links, not just dlink's
# explicit archive arguments. Use the same compiler-owned prefix policy
# as the semantic runner, with the installed GCC archive and real tools.
compiler_prefix=$(
    P10TK_STDIO_RUNTIME_OUT="$work" \
    PYTHONPATH="$root/tools${PYTHONPATH:+:$PYTHONPATH}" \
    python3 -c 'import os
from compiler_stdlib_prefix_v1 import prepare_script_prefix
print(prepare_script_prefix(os.environ["P10TK_STDIO_RUNTIME_OUT"],
                            os.environ["PDP10_PREFIX"], "gcc"))'
)

libdir="$PDP10_PREFIX/lib/gcc-lib/pdp10-dec-none/3.2/freestanding"
compiler_libc="$libdir/libp10c-v2.a"
for file in "$PDP10_PREFIX/pdp10-dec-none/include/stdio.h" \
            "$libdir/p10stdio-format-v2.s" \
            "$libdir/libp10stdio-v2.a" \
            "$compiler_libc" \
            "$PDP10_PREFIX/bin/pdp10-dec-none-gcc"; do
    if [ ! -f "$file" ]; then
        echo "missing installed GCC stdio implementation: $file" >&2
        exit 2
    fi
done

# Link the actual GCC formatter and compiler freestanding C archive.
# Never link the generic prefix/lib/libc.a, which can be DAIMOS libc
# when this script is run directly instead of through the dispatcher.
# A header-only formatter or an accidental KCC sprintf is not acceptable.
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
    "$libdir/libp10stdio-v2.a" "$compiler_libc" \
    "$libgcc"
for symbol in sprintf vsprintf snprintf vsnprintf; do
    grep -q "^$symbol[[:space:]]" \
        "$work/libp10stdio-extraction-v2.map" || {
        echo "real GCC stdio archive member not extracted: $symbol" >&2
        exit 1
    }
done
echo "PASS GCC stdio production archive extraction"

# Default retains the original 16 PDP-6/KA10/KI10/KS10 guest checks.
# Select two real PDP-6 O0 guests when auditing direct raw invocation.
case ${P10_STDIO_CELLS:-all} in
    all) machines='pdp6 ka10 ki10 ks10'; profiles='O0 O2' ;;
    pdp6-O0) machines=pdp6; profiles=O0 ;;
    *) echo "unknown P10_STDIO_CELLS selection" >&2; exit 2 ;;
esac
for machine in $machines; do
    for profile in $profiles; do
        echo "CHECK gcc stdio $machine $profile"
        PDP10_PREFIX="$compiler_prefix" "$P10RUN" --machine "$machine" --mode deposit --exec-mode step \
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
        PDP10_PREFIX="$compiler_prefix" "$P10RUN" --machine "$machine" --mode deposit --exec-mode step \
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
if [ "${P10_STDIO_CELLS:-all}" = all ]; then
    echo "PASS GCC PDP10 stdio v2: 16 native guest cells and archive extraction"
else
    echo "PASS GCC PDP10 stdio v2: two selected PDP-6 O0 guests and archive extraction"
fi
