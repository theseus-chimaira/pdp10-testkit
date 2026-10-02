#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/p10tk-gcc-dimode-divmod-v33-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
libgcc1=$PDP10_PREFIX/share/gcc-pdp10/config/pdp10/libgcc1.s
test -f "$libgcc1" || { echo "missing installed libgcc1.s: $libgcc1" >&2; exit 1; }
"$PDP10_GCC" -S -O2 -mlong-long-71bit -o "$tmp/gcc.s" \
    "$root/tests/compat/gcc-dimode-divmod-v33.c"
"$P10RUN" --machine ks10 --mode deposit --exec-mode step \
    --step-limit 3000000 --timeout 30 --workdir "$tmp/run" \
    --name gcc_dimode_divmod_v33 --expect __test_exit=0 \
    "$root/support/crt0.s" "$root/tests/compat/mixed-call-support.s" \
    "$tmp/gcc.s" "$libgcc1" "$KCC_RT" >/dev/null
echo "GCC signed/unsigned 71-bit divide/modulo runtime: PASS"
