#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-aggregate-return-abi-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

"$PDP10_GCC" -S -O1 -fno-inline -mlong-long-71bit \
    -o "$tmp/gcc.s" "$root/tests/compat/aggregate-return-abi.c"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=p10retv8 \
        "$root/tests/compat/aggregate-return-abi.c"
)

for asm in "$tmp/gcc.s" "$tmp/p10retv8.s"; do
    grep -Ei '(^|[[:space:]])pushj[[:space:]]+17,abi_ret_pair36' "$asm" >/dev/null
    grep -Ei '(^|[[:space:]])pushj[[:space:]]+17,abi_ret_pair71' "$asm" >/dev/null
    grep -A28 '^abi_ret_pair36:' "$asm" | grep -Ei '(^|[[:space:]])d?move[[:space:]]+1,' >/dev/null
    grep -A50 '^abi_ret_quad36:' "$asm" | grep -Ei '(^|[[:space:]])d?move[[:space:]]+3,' >/dev/null
done

echo "KCC/GCC one-to-four-word aggregate return ABI agrees"
