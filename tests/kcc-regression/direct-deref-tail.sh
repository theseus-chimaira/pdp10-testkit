#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-direct-deref-tail-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
extern int foo();
typedef int (*fn_t)();

int direct(a, b)
int a, b;
{
    return (*foo)(a, b);
}

int indirect(fn, a, b)
fn_t fn;
int a, b;
{
    return (*fn)(a, b);
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

awk '
    /^direct:/ { in_direct = 1; next }
    /^indirect:/ { in_direct = 0 }
    in_direct && /^[[:space:]]*jrst[[:space:]]+foo[[:space:]]*$/ { direct_tail = 1 }
    END { exit direct_tail ? 0 : 1 }
' "$ASM" || {
    echo "explicit direct-function dereference did not tail-call" >&2
    exit 1
}

awk '
    /^indirect:/ { in_indirect = 1; next }
    in_indirect && /^[[:space:]]*pushj[[:space:]]+17,0\([0-7]+\)[[:space:]]*$/ {
        indirect_call = 1
    }
    END { exit indirect_call ? 0 : 1 }
' "$ASM" || {
    echo "function-pointer variable was incorrectly made direct" >&2
    exit 1
}

echo "direct function dereference tail-call regression passed"
