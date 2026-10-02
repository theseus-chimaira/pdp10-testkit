#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}
if test -z "$TMP" || test ! -d "$TMP" || test ! -w "$TMP"; then
    TMP=.git
fi
DIR=$TMP/kcc-dmpl-$$
trap 'rm -rf "$DIR"' EXIT HUP INT TERM
mkdir "$DIR"
cat >"$DIR/test.c" <<'SRC'
long long addmul71(long long a, long long b)
{
    return (a + b) * 3LL;
}
long long muladd71(long long a, long long b)
{
    return (a * b) + 1LL;
}
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$DIR" && "$KCC" -x="$cpu" -S -R=test test.c >/dev/null)
    asm=$DIR/test.s
    addmul=$(awk '/^addmul71:/{f=1;next} /^muladd71:/{f=0} f' "$asm")
    muladd=$(awk '/^muladd71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")

    ! printf '%s
' "$addmul" | grep -Eq 'MOVE[[:space:]]+3,2[[:space:]]*$'
    ! printf '%s
' "$addmul" | grep -Eq 'MOVE[[:space:]]+4,3[[:space:]]*$'
    ! printf '%s
' "$addmul" | grep -q 'movem.*-1(17)'
    ! printf '%s
' "$muladd" | grep -q 'movem.*-1(17)'
    printf '%s
' "$addmul" | grep -q 'MUL'
    printf '%s
' "$muladd" | grep -q 'MUL'
done
printf '%s
' 'DImode multiplication pair-lifetime regression passed'
