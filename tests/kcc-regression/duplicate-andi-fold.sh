#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-duplicate-andi-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat >"$TMP/test.c" <<'SRC'
typedef unsigned long kword_t;

struct packed_proc {
    kword_t meta;
};

#define FIELD_MASK 0777UL
#define UID_SHIFT 18U
#define GID_SHIFT 27U
#define GET_UID(p) ((unsigned int)(((p)->meta >> UID_SHIFT) & FIELD_MASK))
#define GET_GID(p) ((unsigned int)(((p)->meta >> GID_SHIFT) & FIELD_MASK))
#define SET_CRED(p, uid, gid) ((p)->meta = \
    ((p)->meta & ((((kword_t)1U << UID_SHIFT) - 1U))) | \
    (((kword_t)(uid) & FIELD_MASK) << UID_SHIFT) | \
    (((kword_t)(gid) & FIELD_MASK) << GID_SHIFT))

void copy_cred(struct packed_proc *dst, const struct packed_proc *src)
{
    SET_CRED(dst, GET_UID(src), GET_GID(src));
}

unsigned long narrower_mask(unsigned long x)
{
    return (x & 07777UL) & 0777UL;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

# The real packed-field shape used to emit two consecutive masks for each
# extracted field.  UID still needs one mask; GID no longer needs one after
# its logical right shift because only nine bits remain.  The narrower-mask
# control contributes the second required mask.
if [ "$(grep -Ec 'andi[[:space:]]+[0-7]+,0?777[[:space:]]*$' "$ASM")" -ne 2 ]; then
    echo "duplicate ANDI masks were not folded" >&2
    exit 1
fi

if awk '
    /^[[:space:]]*andi[[:space:]]+[0-7]+,0?777[[:space:]]*$/ {
        cur = $0
        gsub(/[[:space:]]+/, " ", cur)
        sub(/^ /, "", cur)
        if (cur == prev)
            bad = 1
        prev = cur
        next
    }
    { prev = "" }
    END { exit bad ? 0 : 1 }
' "$ASM"; then
    echo "adjacent duplicate ANDI remains" >&2
    exit 1
fi

echo "duplicate ANDI fold regression passed"
