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
DIR=$TMP/kcc-ddas-$$
trap 'rm -rf "$DIR"' EXIT HUP INT TERM
mkdir "$DIR"
cat >"$DIR/test.c" <<'SRC'
long long shl71(long long a, int n) { return a << n; }
long long shr71(long long a, int n) { return a >> n; }
unsigned long long ushr71(unsigned long long a, int n) { return a >> n; }
long long reused71(long long a, int n) { return (a << n) + a; }
extern void sink(void);
long long called71(long long a, int n) { sink(); return a << n; }
SRC
for cpu in pdp6 ka10 ki10 ks10; do
    (cd "$DIR" && "$KCC" -x="$cpu" -S -R=test test.c >/dev/null)
    asm=$DIR/test.s
    shl=$(awk '/^shl71:/{f=1;next} /^shr71:/{f=0} f' "$asm")
    shr=$(awk '/^shr71:/{f=1;next} /^ushr71:/{f=0} f' "$asm")
    ushr=$(awk '/^ushr71:/{f=1;next} /^reused71:/{f=0} f' "$asm")
    reused=$(awk '/^reused71:/{f=1;next} /^called71:/{f=0} f' "$asm")
    called=$(awk '/^called71:/{f=1;next} /^[A-Za-z_][A-Za-z0-9_]*:/{if(f)exit} f' "$asm")

    for direct in "$shl" "$shr" "$ushr"; do
        ! printf '%s\n' "$direct" | grep -Eqi 'push[[:space:]]+17,16|movem.*-1\(17\)|dmovem.*-1\(17\)'
    done
    printf '%s\n' "$shl" | grep -qi 'lshc'
    printf '%s\n' "$shr" | grep -qi 'ashc'
    printf '%s\n' "$ushr" | grep -qi 'lshc'
    printf '%s\n' "$reused" | grep -Eqi 'movem.*-1\(17\)|dmovem.*-1\(17\)'
    printf '%s\n' "$called" | grep -qi 'pushj'
done
printf '%s\n' 'direct DImode ABI shift regression passed'
