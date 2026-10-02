#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-constant-negation-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
typedef unsigned long kword_t;

#define REFCNT_MASK 01777UL
#define REFCNT_SHIFT 26U

struct vnode {
    kword_t meta;
};

#define GET_REFCNT(p) \
    ((unsigned int)(((p)->meta >> REFCNT_SHIFT) & REFCNT_MASK))
#define SET_REFCNT(p, value) do { \
    (p)->meta = ((p)->meta & ~((kword_t)REFCNT_MASK << REFCNT_SHIFT)) | \
        (((kword_t)(value) & REFCNT_MASK) << REFCNT_SHIFT); \
} while (0)

int bump(struct vnode *p)
{
    SET_REFCNT(p, GET_REFCNT(p) + 1U);
    return 0;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

if grep -Eq 'movei[[:space:]]+([0-7]+),0*32[[:space:]]*$' "$ASM"; then
    echo "constant shift count retained MOVEI materialization" >&2
    exit 1
fi
if grep -Eq 'movn[[:space:]]+[0-7]+,[0-7]+[[:space:]]*$' "$ASM"; then
    echo "constant shift count retained self MOVN" >&2
    exit 1
fi

grep -Eq 'lsh[[:space:]]+[0-7]+,-0*32[[:space:]]*$' "$ASM"
grep -Eq 'lsh[[:space:]]+[0-7]+,0*32[[:space:]]*$' "$ASM"

echo "constant negation fold regression passed"
