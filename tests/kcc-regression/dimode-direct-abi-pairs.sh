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
DIR=$TMP/kcc-didap-$$
trap 'rm -rf "$DIR"' EXIT HUP INT TERM
mkdir "$DIR"
cat >"$DIR/test.c" <<'SRC'
long long add71(long long a, long long b) { return a + b; }
long long id71(long long a) { return a; }
long long twice71(long long a) { return a + a; }
long long sub71(long long a, long long b) { return a - b; }
long long and71(long long a, long long b) { return a & b; }
long long or71(long long a, long long b) { return a | b; }
long long xor71(long long a, long long b) { return a ^ b; }
long long mul71(long long a, long long b) { return a * b; }
long long change71(long long a) { a += 1; return a; }
extern void sink(void);
long long call71(long long a) { sink(); return a; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$DIR" && "$KCC" -x="$cpu" -S -R=test test.c >/dev/null)
    asm=$DIR/test.s
    add=$(awk '/^add71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")
    ident=$(awk '/^id71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")
    twice=$(awk '/^twice71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")
    sub=$(awk '/^sub71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")
    and=$(awk '/^and71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")
    or=$(awk '/^or71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")
    xor=$(awk '/^xor71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")
    mul=$(awk '/^mul71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")
    change=$(awk '/^change71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")
    call=$(awk '/^call71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")

    printf '%s\n' "$add" | grep -q 'DIADD'
    ! printf '%s\n' "$add" | grep -q 'movem.*-1(17)'
    ! printf '%s\n' "$add" | grep -q 'movei.*-.*(17)'
    ! printf '%s\n' "$ident" | grep -q 'movem.*-1(17)'
    for direct in "$add" "$ident" "$sub" "$and" "$or" "$xor"; do
        ! printf '%s\n' "$direct" | grep -Eq 'push[[:space:]]+17,16|move[[:space:]]+16,0\(17\)'
    done
    ! printf '%s\n' "$mul" | grep -Eq 'push[[:space:]]+17,16|move[[:space:]]+16,0\(17\)'
    ! printf '%s\n' "$mul" | grep -q 'movem.*-1(17)'

    printf '%s\n' "$twice" | grep -q 'movem.*-1(17)'
    printf '%s\n' "$change" | grep -q 'movem.*-1(17)'
    printf '%s\n' "$call" | grep -q 'movem.*-1(17)'
done
printf '%s\n' 'DImode direct ABI pair regression passed'
