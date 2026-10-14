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
DIR=$TMP/kcc-ddhs-$$
trap 'rm -rf "$DIR"' EXIT HUP INT TERM
mkdir "$DIR"
cat >"$DIR/test.c" <<'SRC'
long long one(long long a, long long b) { return a / b; }
long long two(long long a, long long b, long long c) { return a / b + a / c; }
long long mix(long long a, long long b) { return a / b + a % b; }
unsigned long long utwo(unsigned long long a, unsigned long long b,
                        unsigned long long c) { return a / b + a / c; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$DIR" && "$KCC" -x="$cpu" -S -R=test test.c >/dev/null)
    asm=$DIR/test.s
    one=$(awk '/^one:/{f=1;next} /^two:/{f=0} f' "$asm")
    two=$(awk '/^two:/{f=1;next} /^mix:/{f=0} f' "$asm")
    mix=$(awk '/^mix:/{f=1;next} /^utwo:/{f=0} f' "$asm")
    utwo=$(awk '/^utwo:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")
    printf '%s\n' "$one" | grep -q '%DIDIV'
    ! printf '%s\n' "$one" | grep -q '__kcc_divdi3'
    test "$(printf '%s\n' "$two" | grep -ci 'pushj.*__kcc_divdi3')" -eq 2
    printf '%s\n' "$mix" | grep -q '%DIDIV'
    ! printf '%s\n' "$mix" | grep -Eqi 'pushj.*__kcc_.*di3'
    test "$(printf '%s\n' "$utwo" | grep -ci 'pushj.*__kcc_udivdi3')" -eq 2
done
for rt in "$root/pdp6rt.s" "$root/ka10rt.s" "$root/ks10rt.s"; do
    for sym in __kcc_divdi3 __kcc_moddi3 __kcc_udivdi3 __kcc_umoddi3; do
        grep -q "^$sym:" "$rt"
    done
done
printf '%s\n' 'DImode inline/shared divider selection regression passed'
