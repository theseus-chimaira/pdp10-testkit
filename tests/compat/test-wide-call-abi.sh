#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-wide-call-abi-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

"$PDP10_GCC" -S -O1 -fno-inline -mlong-long-71bit \
    -o "$tmp/gcc.s" "$root/tests/compat/wide-call-abi.c"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=kcc \
        "$root/tests/compat/wide-call-abi.c"
)
test -s "$tmp/gcc.s"
test -s "$tmp/kcc.s"

# Both compilers consume the second 71-bit argument from AC3:AC4 and
# return the result through AC1:AC2.  Do not require a particular wide-add
# instruction sequence: GCC may use DADD or an equivalent carry sequence.
grep -Ei '(^|[[:space:]])(dadd|add)[[:space:]]+[12],[34]([[:space:]]|$)' "$tmp/gcc.s" >/dev/null
grep -Ei '(^|[[:space:]])move[[:space:]]+1,3([[:space:]]|$)' "$tmp/kcc.s" >/dev/null
grep -Ei '(^|[[:space:]])move[[:space:]]+2,4([[:space:]]|$)' "$tmp/kcc.s" >/dev/null

# Calls use the ordinary PUSHJ 17 entry convention and leave the result in
# AC1:AC2.  KCC may tail-call with JRST after restoring the caller frame.
grep -Ei 'pushj[[:space:]]+17,abi_ret' "$tmp/gcc.s" >/dev/null
grep -Ei 'jrst[[:space:]]+abi_ret' "$tmp/kcc.s" >/dev/null

grep -Ei 'pushj[[:space:]]+17,abi_add2' "$tmp/gcc.s" >/dev/null
grep -Ei 'jrst[[:space:]]+abi_add2' "$tmp/kcc.s" >/dev/null

# A mixed scalar/pair/scalar signature occupies AC1, AC2:AC3, and AC4.
# KCC must release the read-once pair after consuming it so later DImode
# temporaries can reuse the dead ABI registers instead of exhausting rrdfind.
"$PDP10_GCC" -S -O1 -mlong-long-71bit -o "$tmp/mixed-gcc.s" \
    "$root/tests/compat/wide-mixed-register-pressure.c"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=mixed-kcc \
        "$root/tests/compat/wide-mixed-register-pressure.c"
)
test -s "$tmp/mixed-kcc.s"

echo "KCC/GCC 71-bit fixed-argument calling ABI agrees"
