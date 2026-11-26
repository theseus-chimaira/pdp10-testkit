#!/bin/sh
# Reuse the established integer/string formatter oracle with native KCC
# stdarg, and independently extract the actual installed DARC member.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/kcc-p10stdio-v59u.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
libdir="$KCC_LIBDIR/freestanding"
libgcc=$("$PDP10_GCC" -print-libgcc-file-name)
compiler_prefix=$(PYTHONPATH="$root/tools" python3 - "$work" "$PDP10_PREFIX" <<'PY'
import sys
from compiler_stdlib_prefix_v1 import prepare_script_prefix
print(prepare_script_prefix(sys.argv[1], sys.argv[2], 'kcc'))
PY
)
for name in crt0-upstream exit abort; do
    "$PDP10_PREFIX/bin/das" -F -C -O "$work/$name.dobj" "$root/support/$name-v1.s"
done
client="$root/misc/compat/gcc-p10stdio-memory-v1.c"
for cpu in pdp6 ka10 ki10 ks10; do
    for mode in opt noopt; do
        set --
        if [ "$mode" = noopt ]; then set -- -n; fi
        asm="$work/client-$cpu-$mode.s"
        "$KCC" -S -v=nostats -m=gas -x="$cpu" "$@" \
            -I"$KCC_LIBDIR/include" -o "$asm" "$client"
        if [ "$cpu:$mode" = pdp6:noopt ]; then
            "$PDP10_PREFIX/bin/das" -F -C -O "$work/client.dobj" "$asm"
            "$PDP10_PREFIX/bin/dlink" -b 01000 -o "$work/extracted.dxr" \
                -M "$work/extracted.map" "$work/crt0-upstream.dobj" \
                "$work/client.dobj" "$work/exit.dobj" "$work/abort.dobj" \
                "$libdir/libp10stdio-v2.a" "$libdir/libp10c-v2.a" "$libgcc"
            for name in sprintf vsprintf snprintf vsnprintf; do
                grep -q "^$name[[:space:]]" "$work/extracted.map"
            done
            if "$PDP10_PREFIX/bin/dlink" -b 01000 -o "$work/no-stdio.dxr" \
                "$work/crt0-upstream.dobj" "$work/client.dobj" \
                "$work/exit.dobj" "$work/abort.dobj" \
                "$libdir/libp10c-v2.a" "$libgcc" > "$work/no-stdio.log" 2>&1; then
                echo 'unexpected link without formatter archive' >&2
                exit 1
            fi
            grep -i 'sprintf' "$work/no-stdio.log"
            echo 'PASS KCC production archive extraction and negative link'
        fi
        PDP10_PREFIX="$compiler_prefix" "$P10RUN" --machine "$cpu" \
            --mode deposit --exec-mode step --step-limit 100000000 --timeout 25 \
            --workdir "$work/run-$cpu-$mode" --name "kcc-p10stdio-$cpu-$mode-v59u" \
            --expect __test_exit=0 --expect fail_id=0 \
            "$root/support/crt0-upstream-v1.s" "$asm" \
            "$root/support/exit-v1.s" "$root/support/abort-v1.s" \
            "$libdir/p10stdio-format-v2.s"
    done
done
