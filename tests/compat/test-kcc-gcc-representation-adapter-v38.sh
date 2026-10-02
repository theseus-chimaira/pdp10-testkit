#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/p10tk-representation-adapter-v38-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cp "$root/support/common/daimos-language-v1.h" "$tmp/"
cp "$root/support/common/raw72.h" "$tmp/"
cp "$root/tests/compat/representation-adapter-v38.h" "$tmp/"

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
    "$PDP10_GCC" -S -O1 -fno-inline \
        -I"$root/support/common" -I"$root/tests/compat" -o "$out" "$src"
}

compile_gcc "$root/tests/compat/representation-adapter-main-v38.c" "$tmp/g_main.s"
compile_gcc "$root/tests/compat/representation-adapter-callee-v38.c" "$tmp/g_callee.s"
compile_kcc "$root/tests/compat/representation-adapter-main-v38.c" k_main
compile_kcc "$root/tests/compat/representation-adapter-callee-v38.c" k_callee

run_case() {
    name=$1
    main_s=$2
    callee_s=$3
    "$P10RUN" --machine ks10 --mode deposit --exec-mode step \
        --step-limit 1600000 --timeout 20 --workdir "$tmp/$name" \
        --name "$name" --expect __test_exit=0 \
        "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
        "$main_s" "$callee_s" "$KCC_RT" >/dev/null
}

run_case gcc_to_kcc_rep_adapter "$tmp/g_main.s" "$tmp/k_callee.s"
run_case kcc_to_gcc_rep_adapter "$tmp/k_main.s" "$tmp/g_callee.s"

echo "KCC/GCC explicit native-representation adapters: PASS"
