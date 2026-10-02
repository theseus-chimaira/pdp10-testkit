#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-extended-aggregate-abi-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

"$PDP10_GCC" -S -O1 -fno-inline -mlong-long-71bit \
    -o "$tmp/gcc.s" "$root/tests/compat/extended-aggregate-abi.c"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=p10eav9 \
        "$root/tests/compat/extended-aggregate-abi.c"
)

for asm in "$tmp/gcc.s" "$tmp/p10eav9.s"; do
    grep -A35 '^abi_call_five36:' "$asm" | grep -Ei '(^|[[:space:]])(x?movei)[[:space:]]+1,' >/dev/null
    grep -A35 '^abi_call_five36:' "$asm" | grep -Ei 'pushj[[:space:]]+17,abi_ret_five36' >/dev/null
    grep -A45 '^abi_ret_five36:' "$asm" | grep -Ei '(^|[[:space:]])(blt|extend)[[:space:]]+' >/dev/null
    grep -A12 '^abi_bitpack_sum:' "$asm" | grep -Ei '(^|[[:space:]])ldb[[:space:]]+' >/dev/null
    grep -A15 '^abi_call_function_pointer:' "$asm" | grep -Ei 'pushj[[:space:]]+17,.*\([0-9]+\)' >/dev/null
    grep -A12 '^abi_union_high:' "$asm" | grep -Ei '(^|[[:space:]])(move|popj)[[:space:]]+' >/dev/null
done

echo "KCC/GCC large aggregate, union, bit-field, and function-pointer ABI agrees"
