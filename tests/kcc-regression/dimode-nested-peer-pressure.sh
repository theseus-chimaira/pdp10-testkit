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
DIR=$TMP/kcc-dinpp-$$
trap 'rm -rf "$DIR"' EXIT HUP INT TERM
mkdir "$DIR"
cat >"$DIR/test.c" <<'SRC'
struct pair71 { long long a; long long b; };
struct nested71 { struct pair71 p; long long tail; };

long long
nested_add(p, x)
struct nested71 *p;
long long x;
{
    return p->p.a + p->tail + x;
}
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$DIR" && "$KCC" -x="$cpu" -S -R=test test.c >/dev/null)
    test -s "$DIR/test.s"
done
printf '%s\n' 'DImode nested peer pressure regression passed'
