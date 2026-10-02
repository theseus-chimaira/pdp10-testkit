#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-abi-first-call-lifetime-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
extern int sink();

int dies(a, b)
int a, b;
{
    sink(a);
    return b + 1;
}

int later(a, b)
int a, b;
{
    b += 3;
    a ^= 1;
    sink(a);
    return b + 1;
}

int predies(a, b)
int a, b;
{
    a ^= 1;
    b += a;
    sink(b);
    return b + 1;
}

int lives(a, b)
int a, b;
{
    sink(a);
    return a + b;
}
SRC
(
 cd "$TMP"
 "$KCC" -x=pdp6 -D__PDP10__ -S test.c >/dev/null
)
ASM=$TMP/test.s
body() {
 awk -v name="$1" '
   $0 == name ":" { in_fn=1; next }
   in_fn && /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
   in_fn { print }
 ' "$ASM"
}
DIES=$(body dies)
LATER=$(body later)
PREDIES=$(body predies)
LIVES=$(body lives)
# a dies at the first call and must not consume a preserved register copy.
printf '%s\n' "$DIES" | grep -Eq 'pushj[[:space:]]+17,sink'
if printf '%s\n' "$DIES" | grep -Eq 'move[[:space:]]+1[01],1[[:space:]]*$'; then
 echo "dead first-call argument was promoted to a preserved AC" >&2
 exit 1
fi
# Leading call-free statements may precede the first call.  a still dies at
# that call and must remain in its incoming ABI AC rather than being promoted.
printf '%s\n' "$LATER" | grep -Eq 'pushj[[:space:]]+17,sink'
if printf '%s\n' "$LATER" | grep -Eq 'move[[:space:]]+1[01],1[[:space:]]*$'; then
 echo "later first-call argument was promoted to a preserved AC" >&2
 exit 1
fi
# a is consumed by straight-line code and is dead before the first call.
# It must remain in its incoming ABI AC until that point, not be promoted.
printf '%s\n' "$PREDIES" | grep -Eq 'pushj[[:space:]]+17,sink'
if printf '%s\n' "$PREDIES" | grep -Eq 'move[[:space:]]+1[01],1[[:space:]]*$'; then
 echo "pre-call-dead argument was promoted to a preserved AC" >&2
 exit 1
fi
# a remains live after the call here and must still be preserved.
printf '%s\n' "$LIVES" | grep -Eq 'move[[:space:]]+1[01],1[[:space:]]*$'
echo "ABI first-call lifetime regression passed"
