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
DIR=$TMP/kcc-ddcost-$$
trap 'rm -rf "$DIR"' EXIT HUP INT TERM
mkdir "$DIR"
cat >"$DIR/test.c" <<'SRC'
long long d1(long long a, long long b) { return a / b; }
long long d2(long long a, long long b, long long c) { return a / b + a / c; }
long long d4(long long a, long long b, long long c, long long d,
             long long e) { return a / b + a / c + a / d + a / e; }
long long d8(long long a, long long b, long long c, long long d,
             long long e, long long f, long long g, long long h,
             long long i) {
    return a / b + a / c + a / d + a / e
         + a / f + a / g + a / h + a / i;
}
SRC
count_body()
{
    awk -v name="$2" '
        $0 == name ":" { inbody = 1; next }
        inbody && /^[A-Za-z_][A-Za-z0-9_]*:/ { exit }
        inbody && /^[ \t]+[A-Za-z]/ { count++ }
        END { print count + 0 }
    ' "$1"
}
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$DIR" && "$KCC" -x="$cpu" -S -R=test test.c >/dev/null)
    asm=$DIR/test.s
    n1=`count_body "$asm" d1`
    n2=`count_body "$asm" d2`
    n4=`count_body "$asm" d4`
    n8=`count_body "$asm" d8`
    test "$n1" -gt "$n2"
    test "$n4" -lt `expr "$n1" \* 4`
    test "$n8" -lt `expr "$n1" \* 8`
    test `grep -ci 'pushj.*__kcc_divdi3' "$asm"` -eq 14
done
printf '%s\n' 'DImode divider inline/helper cost regression passed'
