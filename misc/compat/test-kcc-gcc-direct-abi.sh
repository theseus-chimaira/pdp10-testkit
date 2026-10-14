#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/p10tk-direct-abi-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cp "$root/misc/compat/mixed-abi.h" "$tmp/mixed-abi.h"

compile_kcc() {
    src=$1
    out=$2
    cp "$src" "$tmp/$out.c"
    (
        cd "$tmp"
        TERM=dumb "$KCC" -S -v=nostats -x=base \
            -I"$root/misc/compat" -R="$out" "$out.c"
    )
}

compile_gcc() {
    src=$1
    out=$2
    "$PDP10_GCC" -S -O1 -fno-inline -mlong-long-71bit \
        -I"$root/misc/compat" -o "$out" "$src"
}

compile_gcc "$root/misc/compat/mixed-abi-main.c" "$tmp/g_main.s"
compile_gcc "$root/misc/compat/mixed-abi-callee.c" "$tmp/g_callee.s"
compile_kcc "$root/misc/compat/mixed-abi-main.c" k_main
compile_kcc "$root/misc/compat/mixed-abi-callee.c" k_callee

run_case() {
    name=$1
    main_s=$2
    callee_s=$3
    "$P10RUN" --machine ks10 --mode deposit --exec-mode step \
        --step-limit 2000000 --timeout 25 --workdir "$tmp/$name" \
        --name "$name" --expect __test_exit=0 \
        "$root/support/crt0.s" "$root/misc/compat/mixed-call-support.s" \
        "$root/misc/compat/mixed-stack-support.s" \
        "$main_s" "$callee_s" "$KCC_RT" >/dev/null
}

run_case gcc_to_kcc_direct_abi "$tmp/g_main.s" "$tmp/k_callee.s"
run_case kcc_to_gcc_direct_abi "$tmp/k_main.s" "$tmp/g_callee.s"

echo "KCC/GCC direct aggregate/float/double/byte-pointer ABI: PASS"
