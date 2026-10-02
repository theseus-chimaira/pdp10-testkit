#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/p10tk-kcc-gcc-aggregate-stack-v28-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

compile_kcc() {
    src=$1
    out=$2
    cp "$src" "$tmp/$out.c"
    (
        cd "$tmp"
        TERM=dumb "$KCC" -S -v=nostats -x=base -I"$root/tests/compat/" \
            -R="$out" "$out.c"
    )
}

compile_gcc() {
    src=$1
    out=$2
    "$PDP10_GCC" -S -O1 -fno-inline -I"$root/tests/compat" \
        -o "$out" "$src"
}

compile_gcc "$root/tests/compat/mixed-aggregate-stack-main-v28.c" "$tmp/g_main.s"
compile_gcc "$root/tests/compat/mixed-aggregate-stack-callee-v28.c" "$tmp/g_callee.s"
compile_kcc "$root/tests/compat/mixed-aggregate-stack-main-v28.c" k_main
compile_kcc "$root/tests/compat/mixed-aggregate-stack-callee-v28.c" k_callee

run_case() {
    name=$1
    main_s=$2
    callee_s=$3
    "$P10RUN" --machine ks10 --mode deposit --exec-mode step \
        --step-limit 1000000 --timeout 20 --workdir "$tmp/$name" \
        --name "$name" --expect __test_exit=0 \
        "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
        "$main_s" "$callee_s" "$KCC_RT" >/dev/null
}

run_case gcc_to_kcc_aggregate_stack "$tmp/g_main.s" "$tmp/k_callee.s"
run_case kcc_to_gcc_aggregate_stack "$tmp/k_main.s" "$tmp/g_callee.s"

echo "KCC/GCC 3/4-word aggregate register-stack ABI: PASS"
