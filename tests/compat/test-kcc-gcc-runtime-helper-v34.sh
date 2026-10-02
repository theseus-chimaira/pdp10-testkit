#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/p10tk-runtime-helper-v34-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
libgcc1=$PDP10_PREFIX/share/gcc-pdp10/config/pdp10/libgcc1.s
test -f "$libgcc1" || { echo "missing installed libgcc1.s: $libgcc1" >&2; exit 1; }
cp "$root/tests/compat/runtime-helper-kcc-v34.c" "$tmp/kcc.c"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=kcc kcc.c
)
"$PDP10_GCC" -S -O1 -fno-inline -mlong-long-71bit \
    -o "$tmp/gcc.s" "$root/tests/compat/runtime-helper-gcc-v34.c"
"$PDP10_GCC" -S -O1 -fno-inline -mlong-long-71bit \
    -o "$tmp/main.s" "$root/tests/compat/runtime-helper-main-v34.c"
"$P10RUN" --machine ks10 --mode deposit --exec-mode step \
    --step-limit 3500000 --timeout 30 --workdir "$tmp/run" \
    --name kcc_gcc_runtime_helper_v34 --expect __test_exit=0 \
    "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
    "$tmp/main.s" "$tmp/kcc.s" "$tmp/gcc.s" "$libgcc1" "$KCC_RT" >/dev/null
echo "KCC/GCC runtime-helper coexistence: PASS"
