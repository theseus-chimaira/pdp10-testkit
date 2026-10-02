#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-register-overwrite-fold-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
typedef unsigned long kword_t;

#define ID_MASK 07777UL
#define CHARS_SHIFT 12U
#define CHARS_MASK 077UL

struct name {
    kword_t words[8];
    unsigned int chars;
};

struct key {
    kword_t meta;
    kword_t words[2];
};

extern int sink();
extern void zero_words(kword_t *, unsigned int);

struct block {
    kword_t words[5];
};

void reverse_move(struct block *p)
{
    zero_words((kword_t *)p, 5U);
}

extern void put_sixbit(kword_t *, unsigned int, unsigned int);

int resolved_reverse(path, nwords, index, c)
kword_t *path;
unsigned int nwords;
unsigned int index;
unsigned int c;
{
    unsigned int slot;

    if (path == 0)
        return -1;
    if (c < 040U || c > 0137U)
        return -1;
    slot = 1U + index / 6U;
    if (slot >= nwords)
        return -1;
    put_sixbit(path + 1U, index, c);
    return 0;
}

int test(name, table, count, id)
struct name *name;
const struct key *table;
unsigned int count;
unsigned int id;
{
    unsigned int i;

    for (i = 0; i < count; ++i) {
        if ((unsigned int)(table[i].meta & ID_MASK) == id)
            return sink(name, table[i].words,
                (unsigned int)((table[i].meta >> CHARS_SHIFT) & CHARS_MASK));
    }
    return -1;
}
SRC

(
    cd "$TMP"
    "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s

reverse_body=$(awk '
    /^reverse_move:$/ { in_fn = 1; next }
    in_fn && /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
    in_fn { print }
' "$ASM")
if printf '%s\n' "$reverse_body" | awk '
    BEGIN { prev = ""; bad = 0 }
    {
        line = $0
        if (prev ~ /^[[:space:]]*move[[:space:]]+2,1[[:space:]]*$/ &&
            line ~ /^[[:space:]]*move[[:space:]]+1,2[[:space:]]*$/)
            bad = 1
        prev = line
    }
    END { exit bad ? 0 : 1 }
'; then
    echo "reverse register copy was not folded" >&2
    exit 1
fi

resolved_body=$(awk '
    /^resolved_reverse:$/ { in_fn = 1; next }
    in_fn && /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
    in_fn { print }
' "$ASM")
if printf '%s\n' "$resolved_body" | awk '
    BEGIN { prev = ""; bad = 0 }
    {
        line = $0
        if (prev ~ /^[[:space:]]*move[[:space:]]+2,1[[:space:]]*$/ &&
            line ~ /^[[:space:]]*move[[:space:]]+1,2[[:space:]]*$/)
            bad = 1
        prev = line
    }
    END { exit bad ? 0 : 1 }
'; then
    echo "resolved reverse register copy was not folded" >&2
    exit 1
fi

# GCC-ABI tail calls must restore the first source argument into AC1.
# The parallel-copy call fix may therefore legitimately emit MOVE 1,10 here;
# what matters is that the old immediately-reversed copy pair stays absent.
grep -Eq 'jrst[[:space:]]+sink[[:space:]]*$' "$ASM"

echo "register overwrite fold regression passed"
