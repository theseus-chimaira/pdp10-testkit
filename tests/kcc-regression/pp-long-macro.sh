#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-pp-long-macro-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir "$tmp"

awk 'BEGIN {
    printf "#define DAIMON_"
    for (i = 0; i < 4096; ++i)
        printf "X"
    print " 1"
    printf "#ifdef DAIMON_"
    for (i = 0; i < 4096; ++i)
        printf "X"
    print ""
    print "int long_macro_ok;"
    print "#endif"
}' > "$tmp/long.c"

(
    cd "$tmp"
    "$KCC" -E -x=pdp6 long.c >long.i 2>long.err
)

grep 'long_macro_ok' "$tmp/long.i" >/dev/null

echo "long macro preprocessor regression passed"
