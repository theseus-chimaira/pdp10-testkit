#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMPBASE=${TMPDIR:-/tmp}
TMP=$TMPBASE/kcc-exact-width-16-32-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef signed _KCCtype_char16 s16;
typedef unsigned _KCCtype_char16 u16;
typedef signed _KCCtype_int32 s32;
typedef unsigned _KCCtype_int32 u32;

s16 a16[4];
u16 u16a[4];
s32 a32[4];
u32 u32a[4];

int load16(i) int i; { return a16[i]; }
int loadu16(i) int i; { return u16a[i]; }
int load32(i) int i; { return a32[i]; }
int loadu32(i) int i; { return u32a[i]; }
long diff16(p, q) s16 *p; s16 *q; { return p - q; }
int arg16(x) s16 x; { return x; }
int argu16(x) u16 x; { return x; }
int arg32(x) s32 x; { return x; }
int argu32(x) u32 x; { return x; }
SRC
for cpu in base pdp10 pdp6 ka10; do
    dir="$TMP/$cpu"
    mkdir -p "$dir"
    cp "$TMP/test.c" "$dir/test.c"
    (cd "$dir" && "$KCC" -x="$cpu" -S test.c >out 2>err)
    test -s "$dir/test.s"
    grep -q 'POINT 16' "$dir/test.s"
    if grep -q 'POINT 32' "$dir/test.s"; then
        echo "exact 32-bit value incorrectly used byte-pointer storage on $cpu" >&2
        exit 1
    fi
done
printf '%s\n' 'exact 16/32-bit type regression passed'
