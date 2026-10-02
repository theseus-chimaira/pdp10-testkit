#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-mixed-fixed-v12-$$
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

compile_kcc "$root/tests/compat/mixed-call-kcc-callee.c" kcallee
compile_kcc "$root/tests/compat/mixed-call-kcc-main.c" kmain
"$PDP10_GCC" -S -O1 -mlong-long-71bit -o "$tmp/gmain.s" \
    "$root/tests/compat/mixed-call-gcc-main.c"
"$PDP10_GCC" -S -O1 -mlong-long-71bit -o "$tmp/gcallee.s" \
    "$root/tests/compat/mixed-call-gcc-callee.c"

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

run_case gcc_to_kcc "$tmp/gmain.s" "$tmp/kcallee.s"
run_case kcc_to_gcc "$tmp/kmain.s" "$tmp/gcallee.s"
echo "mixed KCC/GCC 71-bit fixed-call execution: PASS"
