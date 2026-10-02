#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-/tmp}/p10tk-symbol-runtime-v11-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

"$PDP10_GCC" -S -O1 -fno-inline -mlong-long-71bit \
    -o "$tmp/gcc.s" "$root/tests/compat/symbol-runtime-abi-v11.c"
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=p10srv11 \
        "$root/tests/compat/symbol-runtime-abi-v11.c" \
        >kcc.out 2>&1
)

# Identifiers within the common 31-character limit retain spelling.
for symbol in abi_public_lower_v11 AbiPublicMixedV11 _abi_public_lead_v11; do
    grep -F "${symbol}:" "$tmp/gcc.s" >/dev/null
    grep -F "${symbol}:" "$tmp/p10srv11.s" >/dev/null
done
for symbol in abi_external_lower_v11 AbiExternalMixedV11 _abi_external_lead_v11; do
    grep -Ei "pushj[[:space:]]+17,${symbol}([^A-Za-z0-9_]|$)" \
        "$tmp/gcc.s" >/dev/null
    grep -Ei "pushj[[:space:]]+17,${symbol}([^A-Za-z0-9_]|$)" \
        "$tmp/p10srv11.s" >/dev/null
done

# GCC preserves the long identifier. KCC warns and truncates it to 31 chars.
grep -F 'abi_public_symbol_name_longer_than_31_v11:' "$tmp/gcc.s" >/dev/null
grep -F 'abi_public_symbol_name_longer_t:' "$tmp/p10srv11.s" >/dev/null
grep -F 'Identifer truncated' "$tmp/kcc.out" >/dev/null

# GCC exposes its DImode helper ABI; KCC uses private generated machinery.
grep -Ei 'pushj[[:space:]]+17,__divdi3([^A-Za-z0-9_]|$)' "$tmp/gcc.s" >/dev/null
grep -Ei 'pushj[[:space:]]+17,__moddi3([^A-Za-z0-9_]|$)' "$tmp/gcc.s" >/dev/null
if grep -Ei 'pushj[[:space:]]+17,__divdi3|pushj[[:space:]]+17,__moddi3' \
    "$tmp/p10srv11.s" >/dev/null; then
    echo 'KCC unexpectedly used GCC DImode helper names' >&2
    exit 1
fi

echo 'KCC/GCC symbols agree through 31 characters; long names and runtime helpers differ'
