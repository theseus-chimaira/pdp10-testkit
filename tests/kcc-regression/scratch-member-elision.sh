#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-scratch-member-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat >"$TMP/test.c" <<'SRC'
typedef unsigned long word_t;

struct pair {
    word_t first;
    word_t last;
};

struct pair pair0;
struct pair pairs[2];

word_t member_delta(void)
{
    if (pair0.last < pair0.first)
        return 0;
    return (pair0.last - pair0.first) + 1UL;
}

word_t pointer_member_delta(struct pair *p)
{
    if (p->last < p->first)
        return 0;
    return (p->last - p->first) + 1UL;
}

struct pair *second_pair(void)
{
    return &pairs[1];
}

int stack_byte_postinc(char *p)
{
    char *q;
    int c;

    q = p;
    c = *q++;
    return c;
}

typedef int (*call_fn)(int);

int indirect_call(call_fn fn, int value)
{
    return (*fn)(value);
}

word_t unsigned_divide(word_t a, word_t b)
{
    return a / b;
}
SRC

(
    cd "$TMP"
    "$KCC" -S test.c >/dev/null
)
ASM=$TMP/test.s

body()
{
    name=$1
    awk -v name="$name" '
        $0 == name ":" { in_fn = 1; next }
        in_fn && /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
        in_fn { print }
    ' "$ASM"
}

member_delta=$(body member_delta)
pointer_member_delta=$(body pointer_member_delta)
second_pair=$(body second_pair)
stack_byte_postinc=$(body stack_byte_postinc)
indirect_call=$(body indirect_call)
unsigned_divide=$(body unsigned_divide)

if printf '%s\n' "$member_delta" | grep -Eq 'push[[:space:]]+17,0*16|move[[:space:]]+16,'; then
    echo "member_delta: scalar aggregate member access saved AC16" >&2
    exit 1
fi

if printf '%s\n' "$pointer_member_delta" | grep -Eq 'push[[:space:]]+17,0*16|move[[:space:]]+16,'; then
    echo "pointer_member_delta: scalar pointer member access saved AC16" >&2
    exit 1
fi

if printf '%s\n' "$second_pair" | grep -Eq 'push[[:space:]]+17,0*16|move[[:space:]]+16,'; then
    echo "second_pair: aggregate element address saved AC16" >&2
    exit 1
fi

if printf '%s\n' "$stack_byte_postinc" | grep -Eq 'push[[:space:]]+17,0*16|move[[:space:]]+16,'; then
    echo "stack_byte_postinc: memory byte-pointer increment saved AC16" >&2
    exit 1
fi
printf '%s\n' "$stack_byte_postinc" | grep -iq 'ibp'

# Indirect calls now deliberately pin the function target in AC16 while
# fixed ABI argument ACs are populated, so the containing function must save
# and restore AC16.  Keep this distinct from ordinary member/address cases.
printf '%s\n' "$indirect_call" | grep -Eq 'push[[:space:]]+17,0*16'
printf '%s\n' "$indirect_call" | grep -Eq 'move[[:space:]]+16,'
printf '%s\n' "$indirect_call" | grep -iq 'pushj'

printf '%s\n' "$unsigned_divide" | grep -q 'push[[:space:]]*17,0*16'
printf '%s\n' "$unsigned_divide" | grep -q 'move[[:space:]]*16,0(17)'

echo "scratch register member-access regression passed"
