#!/bin/sh
# Real KCC archive and explicit initialization acceptance.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/kcc-p10heap-v59x.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
libdir="$KCC_LIBDIR/freestanding"
libgcc=$("$PDP10_GCC" -print-libgcc-file-name)
compiler_prefix=$(PYTHONPATH="$root/tools" python3 - "$work" "$PDP10_PREFIX" <<'PY'
import sys
from compiler_stdlib_prefix_v1 import prepare_script_prefix
print(prepare_script_prefix(sys.argv[1], sys.argv[2], 'kcc'))
PY
)
for cpu in pdp6 ka10 ki10 ks10; do
    for mode in opt noopt; do
        set --
        if [ "$mode" = noopt ]; then set -- -n; fi
        asm="$work/client-$cpu-$mode.s"
        "$KCC" -S -v=nostats -m=gas -x="$cpu" "$@" \
            -I"$KCC_LIBDIR/include" -o "$asm" \
            "$root/misc/compat/gcc-p10heap-arena-v1.c"
        PDP10_PREFIX="$compiler_prefix" "$P10RUN" --machine "$cpu" \
            --mode deposit --exec-mode step --step-limit 3000000 --timeout 25 \
            --workdir "$work/run-$cpu-$mode" --name "kcc-heap-$cpu-$mode-v59x" \
            --expect __test_exit=0 \
            "$root/support/crt0-upstream-v1.s" "$asm" \
            "$libdir/p10heap-arena-v1.s" \
            "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    done
done
"$PDP10_PREFIX/bin/das" -F -C -O "$work/client.dobj" "$work/client-pdp6-noopt.s"
for name in crt0-upstream exit abort; do
    "$PDP10_PREFIX/bin/das" -F -C -O "$work/$name.dobj" "$root/support/$name-v1.s"
done
"$PDP10_PREFIX/bin/dlink" -b 01000 -o "$work/archive.dxr" \
    -M "$work/archive.map" "$work/crt0-upstream.dobj" "$work/client.dobj" \
    "$work/exit.dobj" "$work/abort.dobj" \
    "$libdir/libp10heap-arena-v1.a" "$libdir/libp10c-v2.a" "$libgcc"
for name in malloc free calloc realloc p10heap_init_v1; do
    grep -q "^$name[[:space:]]" "$work/archive.map"
done
if "$PDP10_PREFIX/bin/dlink" -b 01000 -o "$work/no-heap.dxr" \
    "$work/crt0-upstream.dobj" "$work/client.dobj" \
    "$work/exit.dobj" "$work/abort.dobj" "$libdir/libp10c-v2.a" "$libgcc" \
    > "$work/no-heap.log" 2>&1; then
    echo 'unexpected successful link without heap provider' >&2
    exit 1
fi
grep -Ei 'undefined symbol: (malloc|free|calloc|realloc|p10heap_init_v1)' "$work/no-heap.log"
echo 'PASS: KCC heap archive extraction and negative link'
