#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/p10tk-mixed-call-depth-v24-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

compile_kcc() {
    src=$1
    out=$2
    (
        cd "$tmp"
        TERM=dumb "$KCC" -S -v=nostats -x=base -R="$out" "$src"
    )
}

compile_gcc() {
    src=$1
    out=$2
    "$PDP10_GCC" -S -O1 -fno-inline -mlong-long-71bit -o "$out" "$src"
}

compile_gcc "$root/tests/compat/mixed-call-depth-main-v24.c" "$tmp/g_main.s"
compile_kcc "$root/tests/compat/mixed-call-depth-main-v24.c" k_main

for unit in stack-callee register-pressure aggregate-callee width-callee; do
    compile_gcc "$root/tests/compat/mixed-$unit-v24.c" "$tmp/g_$unit.s"
    compile_kcc "$root/tests/compat/mixed-$unit-v24.c" "k_$unit"
done

run_case() {
    name=$1
    main_s=$2
    prefix=$3
    "$P10RUN" --machine ks10 --mode deposit --exec-mode step \
        --step-limit 2000000 --timeout 25 --workdir "$tmp/$name" \
        --name "$name" --expect __test_exit=0 \
        "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
        "$main_s" \
        "$tmp/${prefix}_stack-callee.s" \
        "$tmp/${prefix}_register-pressure.s" \
        "$tmp/${prefix}_aggregate-callee.s" \
        "$tmp/${prefix}_width-callee.s" \
        "$root/tests/compat/mixed-stack-support-v24.s" \
        "$root/tests/compat/mixed-register-support-v24.s" \
        "$KCC_RT" >/dev/null
}

run_case gcc_to_kcc_deep "$tmp/g_main.s" k
run_case kcc_to_gcc_deep "$tmp/k_main.s" g

echo "mixed KCC/GCC deep calling-convention ABI: PASS"
