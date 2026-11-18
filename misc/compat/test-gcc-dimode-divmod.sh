#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/p10tk-gcc-dimode-divmod-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
# P10RUN supplies the installed canonical libgcc.a. Do not assemble the old
# monolithic libgcc1.s: its local symbols collide under the current DAS.
"$PDP10_GCC" -S -O2 -mlong-long-71bit -o "$tmp/gcc.s" \
    "$root/misc/compat/gcc-dimode-divmod.c"
"$P10RUN" --machine ks10 --mode deposit --exec-mode step \
    --step-limit 3000000 --timeout 30 --workdir "$tmp/run" \
    --name gcc_dimode_divmod_v33 --expect __test_exit=0 \
    "$root/support/crt0.s" \
    "$tmp/gcc.s" >/dev/null
echo "GCC signed/unsigned 71-bit divide/modulo runtime: PASS"
