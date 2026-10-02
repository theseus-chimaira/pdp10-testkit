#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
TMP=${TMPDIR:-/tmp}
if test -z "$TMP" || test ! -d "$TMP" || test ! -w "$TMP"; then
    TMP=.git
fi
DIR=$TMP/kcc-abipair24-$$
trap 'rm -rf "$DIR"' EXIT HUP INT TERM
mkdir "$DIR"
cat >"$DIR/test.c" <<'SRC'
typedef long long int71_t;

int71_t abi_pair_lifetime_v24(int a, int71_t b, int c)
{
    return b + a + c;
}
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (
        cd "$DIR"
        TERM=dumb "$KCC" -S -v=nostats -x="$cpu" -R="test-$cpu" test.c \
            >/dev/null
    )
    test -s "$DIR/test-$cpu.s"
done
printf '%s\n' 'consumed ABI pair lifetime regression passed'
