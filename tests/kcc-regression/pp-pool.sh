#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-pp-pool-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir "$tmp"

# Force one active preprocessor token string beyond 256 KiB.  Separate
# directives are not sufficient because their token storage is reset.
awk 'BEGIN {
    printf "char *s = \""
    for (i = 0; i < 400000; ++i)
        printf "a"
    print "\";"
}' > "$tmp/pool.c"

(
    cd "$tmp"
    "$KCC" -E -x=pdp6 pool.c >/dev/null 2>&1
)

echo "preprocessor pool regression passed"
