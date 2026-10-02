#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMPBASE=${TMPDIR:-/tmp}
TMP=$TMPBASE/kcc-subbp-byte-size-range-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
typedef signed _KCCtype_int32 s32;
struct s { int a; s32 b[1]; };
static s32 *addr(p) struct s *p; { return &p->b[0]; }
int diff(p) struct s *p; { return addr(p) - &p->b[0]; }
SRC
for cpu in base pdp10 pdp6 ka10; do
    dir="$TMP/$cpu"
    mkdir -p "$dir"
    cp "$TMP/test.c" "$dir/test.c"
    (cd "$dir" && "$KCC" -x="$cpu" -S test.c >out 2>err)
    test -s "$dir/test.s"
done
printf '%s\n' 'SUBBP general byte-size regression passed'
