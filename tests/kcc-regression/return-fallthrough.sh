#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-return-fallthrough-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
extern int h(int);
int f(int x)
{
    int y;
    y = h(x);
    if (y)
        return x;
    else
        return y;
}
SRC
(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s
if awk '
    /^[ \t]*jrst[ \t]+%L[0-9]+[ \t]*$/ {
        jump = $2
        if ((getline n) > 0 && n == jump ":")
            bad = 1
    }
    END { exit bad ? 1 : 0 }
' "$ASM"; then
    :
else
    echo "trailing return jump to immediately following epilogue remains" >&2
    exit 1
fi
if ! grep -Eqi '^[[:space:]]*pushj[[:space:]]+17,h[[:space:]]*$' "$ASM"; then
    echo "test did not exercise shared non-leaf return epilogue" >&2
    exit 1
fi

echo "return fallthrough regression passed"
