#!/bin/sh
set -eu

testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
AS=$PDP10_PREFIX/bin/das
tmp=${TMPDIR:-$HOME/tmp}/kcc-runtime-helper-fragments-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

# Call DAS by its native name: the pdp10-dec-none-as alias selects
# GNU-compatible CLI parsing, which does not accept native -O output.
for machine in pdp6 ka10 ks10; do
    for helper in adjbp kdfad kdfsb kdfmp kdfdv; do
        src="$root/${machine}rt-${helper}.s"
        "$AS" -C -O "$tmp/${machine}-${helper}.o" "$src" >/dev/null
    done
done

"$AS" -C -O "$tmp/zero.o" "$root/kccrt-zero.s" >/dev/null
"$AS" -C -O "$tmp/dimode-div.o" "$root/kccrt-dimode-div.s" >/dev/null

echo "KCC split runtime helper fragments assemble independently"
