#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}
if test -z "$TMP" || test ! -d "$TMP" || test ! -w "$TMP"; then
    TMP=.git
fi
DIR=$TMP/kcc-dsap-$$
trap 'rm -rf "$DIR"' EXIT HUP INT TERM
mkdir "$DIR"
cat >"$DIR/test.c" <<'SRC'
long highmul_add(x, y, q)
long x;
long y;
long q;
{
    long long p;

    p = (long long)x * (long long)y;
    return (long)(p >> 35) + q;
}

long highmul_assign(x, y, q)
long x;
long y;
long q;
{
    long long p;

    p = (long long)x * (long long)y;
    x = (long)(p >> 35);
    return x + q;
}
SRC
for cpu in base pdp10 pdp6 ka10; do
    (cd "$DIR" && "$KCC" -x="$cpu" -S -R=test test.c >/dev/null)
    test -s "$DIR/test.s"
done
printf '%s\n' 'DImode scalar-argument pressure regression passed'
