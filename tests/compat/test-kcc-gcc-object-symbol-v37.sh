#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/p10tk-object-symbol-v37-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
DLINK=$PDP10_PREFIX/bin/dlink
OBJDUMP=$PDP10_PREFIX/bin/pdp10-dec-none-objdump

compile_kcc() {
    src=$1
    out=$2
    cp "$src" "$tmp/$out.c"
    (
        cd "$tmp"
        TERM=dumb "$KCC" -S -v=nostats -x=base -R="$out" "$out.c"
    )
}

compile_gcc() {
    src=$1
    out=$2
    "$PDP10_GCC" -S -O1 -fno-inline -o "$out" "$src"
}

compile_gcc "$root/tests/compat/object-symbol-main-v37.c" "$tmp/g_main.s"
compile_gcc "$root/tests/compat/object-symbol-callee-v37.c" "$tmp/g_callee.s"
compile_kcc "$root/tests/compat/object-symbol-main-v37.c" k_main
compile_kcc "$root/tests/compat/object-symbol-callee-v37.c" k_callee

"$PDP10_AS" -C -O "$tmp/g_main.dobj" "$tmp/g_main.s"
"$PDP10_AS" -C -O "$tmp/g_callee.dobj" "$tmp/g_callee.s"
"$PDP10_AS" -C -O "$tmp/k_main.dobj" "$tmp/k_main.s"
"$PDP10_AS" -C -O "$tmp/k_callee.dobj" "$tmp/k_callee.s"
"$PDP10_AS" -C -O "$tmp/support.dobj" "$root/tests/compat/mixed-call-support.s"

for obj in "$tmp/g_callee.dobj" "$tmp/k_callee.dobj"; do
    "$OBJDUMP" -t "$obj" >"$obj.syms"
    grep ' MixedCaseV37$' "$obj.syms" >/dev/null
    grep ' _lead_v37$' "$obj.syms" >/dev/null
done

"$DLINK" -o "$tmp/gcc-main-kcc-callee.dxr" \
    "$tmp/g_main.dobj" "$tmp/k_callee.dobj" "$tmp/support.dobj"
"$DLINK" -o "$tmp/kcc-main-gcc-callee.dxr" \
    "$tmp/k_main.dobj" "$tmp/g_callee.dobj" "$tmp/support.dobj"

test -s "$tmp/gcc-main-kcc-callee.dxr"
test -s "$tmp/kcc-main-gcc-callee.dxr"

echo "KCC/GCC DOBJ symbol spelling and relocation link: PASS"
