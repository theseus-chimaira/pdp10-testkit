#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-wide-varargs-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

# Keep compiling the common probe with both compilers.  Their private va_list
# implementations need not look alike; the ABI requirement is the external
# caller/callee stack shape for arguments after `...`.
"$PDP10_GCC" -S -O1 -mlong-long-71bit \
    -I"$root/support/common" -I"$root/support/gcc" \
    -o "$tmp/gcc.s" "$root/tests/compat/wide-varargs-abi.c"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base \
        -I"$root/support/common/" -I"$root/support/kcc/" \
        -R=kcc "$root/tests/compat/wide-varargs-abi.c"
)
test -s "$tmp/gcc.s"
test -s "$tmp/kcc.s"

# Build one current-KCC variadic callee and callers from both compilers.  The
# executable GCC->KCC case proves that GCC's unnamed stack arguments are
# consumable by KCC's va_start/va_arg implementation, including a 71-bit value.
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base \
        -I"$root/support/common/" -I"$root/support/kcc/" \
        -R=va-kcc-callee "$root/tests/compat/wide-varargs-mixed-callee.c"
    TERM=dumb "$KCC" -S -v=nostats -x=base \
        -I"$root/support/common/" -I"$root/support/kcc/" \
        -R=va-kcc-main "$root/tests/compat/wide-varargs-mixed-main.c"
)
"$PDP10_GCC" -S -O1 -mlong-long-71bit \
    -I"$root/support/common" -I"$root/support/gcc" \
    -o "$tmp/va-gcc-main.s" "$root/tests/compat/wide-varargs-mixed-main.c"

run_case() {
    name=$1
    main_s=$2
    "$P10RUN" --machine ks10 --mode deposit --exec-mode step \
        --step-limit 1000000 --timeout 20 --workdir "$tmp/$name" \
        --name "$name" --expect __test_exit=0 \
        "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
        "$main_s" "$tmp/va-kcc-callee.s" "$KCC_RT" >/dev/null
}

run_case kcc_varargs_control "$tmp/va-kcc-main.s"
run_case gcc_to_kcc_varargs "$tmp/va-gcc-main.s"

echo "KCC/GCC variadic external ABI agrees"
