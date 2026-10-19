#!/bin/sh
# Catch GCC's trailing 9-bit initializer word escaping into .text.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-gcc-data-section-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
src="$root/tests/semantic/validation-gcc/pdp10-9bit-data-section-v1.c"
for opt in -O0 -O1 -O2 -Os; do
    label=${opt#-}
    asm="$work/$label.s"
    "$PDP10_GCC" -march=pdp6 "$opt" -S "$src" -o "$asm"
    # The first instruction or data emitted after .text must not be a
    # stray trailing initializer word. Runtime checks verify every byte.
    if awk '
        /^[[:space:]]*\.text[[:space:]]*$/ { text = 1; next }
        text && /^[[:space:]]*\.word[[:space:]]/ { exit 1 }
        text && /^[[:space:]]*[^;[:space:]]/ { exit 0 }
    ' "$asm"; then :; else
        echo "GCC emitted a pending data word after .text: $opt" >&2
        exit 1
    fi
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 1000000 --timeout 18 \
        --workdir "$work/run-$label" --name "gcc-data-section-$label-v1" \
        --expect __test_exit=0 \
        "$root/support/crt0-upstream-v1.s" "$asm" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
done
echo 'PASS GCC 9-bit initialized data section regression'
