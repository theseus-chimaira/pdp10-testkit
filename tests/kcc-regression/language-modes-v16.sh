#!/bin/sh
set -eu

testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-language-modes-v16-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat > "$tmp/c89.c" <<'SRC'
int f(int x) { int y = x + 1; return y; }
SRC
cat > "$tmp/c99.c" <<'SRC'
int f(int n) {
    int a[n];
    for (int i = 0; i < n; ++i) a[i] = i;
    int z = (int){3};
    return z + a[0];
}
SRC
cat > "$tmp/gnu.c" <<'SRC'
int f(int x) { typeof(x) y = x; return ({ y + 1; }); }
SRC
cat > "$tmp/c11.c" <<'SRC'
int f(int x) { return _Generic(x, int: x, default: 0); }
SRC
cat > "$tmp/inline.c" <<'SRC'
inline int f(int x) { return x; }
SRC
cat > "$tmp/hex.c" <<'SRC'
double f(void) { return 0x1.8p+2; }
SRC
cat > "$tmp/cpp.c" <<'SRC'
int f(void) { // C99 line comment
    return 1;
}
SRC
cat > "$tmp/version.c" <<'SRC'
#ifndef __STDC__
#error missing_stdc
#endif
#if WANT99
# if !defined(__STDC_VERSION__) || __STDC_VERSION__ != 199901L
#  error bad_stdc_version
# endif
#else
# ifdef __STDC_VERSION__
#  error unexpected_stdc_version
# endif
#endif
int x;
SRC

accept()
{
    mode=$1
    file=$2
    TERM=dumb "$KCC" "-P$mode" -S -v=nostats -R="$tmp/out" "$tmp/$file.c" \
        >"$tmp/$mode-$file.out" 2>"$tmp/$mode-$file.err" || {
        echo "$mode unexpectedly rejected $file" >&2
        cat "$tmp/$mode-$file.err" >&2
        exit 1
    }
}

reject()
{
    mode=$1
    file=$2
    if TERM=dumb "$KCC" "-P$mode" -S -v=nostats -R="$tmp/out" "$tmp/$file.c" \
        >"$tmp/$mode-$file.out" 2>"$tmp/$mode-$file.err"; then
        echo "$mode unexpectedly accepted $file" >&2
        exit 1
    fi
}

for mode in c89 strict c99 gnu89 gnu99; do accept "$mode" c89; done
for mode in c89 strict; do reject "$mode" c99; reject "$mode" inline; reject "$mode" hex; reject "$mode" cpp; done
accept c99 c99; accept c99 inline; accept c99 hex; accept c99 cpp
reject c99 gnu
reject c99 c11
for mode in gnu89 gnu99; do
    accept "$mode" c99
    accept "$mode" gnu
    accept "$mode" c11
    accept "$mode" inline
    accept "$mode" hex
    accept "$mode" cpp
done

# Both spellings of the strict C89 profile are accepted.
TERM=dumb "$KCC" -P=c89 -S -v=nostats -R="$tmp/equal1" "$tmp/c89.c" >/dev/null 2>&1
TERM=dumb "$KCC" -Pstrict -S -v=nostats -R="$tmp/equal2" "$tmp/c89.c" >/dev/null 2>&1
cmp "$tmp/equal1.s" "$tmp/equal2.s" >/dev/null

# C99 profiles publish the C99 predefined version; C89 profiles do not.
for mode in c99 gnu99; do
    TERM=dumb "$KCC" "-P$mode" -DWANT99=1 -S -v=nostats -R="$tmp/ver" "$tmp/version.c" >/dev/null 2>&1
done
for mode in c89 strict gnu89; do
    TERM=dumb "$KCC" "-P$mode" -DWANT99=0 -S -v=nostats -R="$tmp/ver" "$tmp/version.c" >/dev/null 2>&1
done

# Historical mode syntax remains compatible and intentionally unrestricted.
TERM=dumb "$KCC" -P=stdc+kcc -S -v=nostats -R="$tmp/legacy" "$tmp/c11.c" >/dev/null 2>&1

printf '%s\n' 'KCC language mode regression passed'
