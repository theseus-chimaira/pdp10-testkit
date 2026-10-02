#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-pointer-abi-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

"$PDP10_GCC" -S -O1 -fno-inline -mlong-long-71bit \
    -o "$tmp/gcc.s" "$root/tests/compat/pointer-abi.c"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=p10ptrv8 \
        "$root/tests/compat/pointer-abi.c"
)

for asm in "$tmp/gcc.s" "$tmp/p10ptrv8.s"; do
    grep -Ei '(^|[[:space:]])ldb[[:space:]]+1,' "$asm" >/dev/null
    grep -Ei '(^|[[:space:]])dpb[[:space:]]+' "$asm" >/dev/null
    grep -A8 '^ptr_word_add:' "$asm" | grep -Ei '(^|[[:space:]])add[[:space:]]+1,' >/dev/null
    grep -A8 '^ptr_word_get:' "$asm" | grep -Ei '(^|[[:space:]])move[[:space:]]+1,' >/dev/null
    grep -A8 '^ptr_word_set:' "$asm" | grep -Ei '(^|[[:space:]])movem?[[:space:]]+' >/dev/null
done

# Both compilers use PDP-10 byte pointers for char/short pointers.  The base
# target cannot require ADJBP: GCC may lower byte-pointer addition to IBP,
# while KCC currently calls its equivalent %ADJBPH helper.
grep -Ei '(^|[[:space:]])(adjbp|ibp)[[:space:]]+' "$tmp/gcc.s" >/dev/null
grep -Ei 'pushj[[:space:]]+17,%ADJBPH' "$tmp/p10ptrv8.s" >/dev/null

echo "KCC/GCC ordinary and byte-pointer representations agree"
