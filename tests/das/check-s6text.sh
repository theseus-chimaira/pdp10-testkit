#!/bin/sh
set -eu
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
TMP=$TMPDIR/s6text-check-$$
trap 'rm -rf "$TMP"' 0 1 2 3 15
mkdir "$TMP"
printf 'HELLO, PDP-6!\n\n# SIXBIT_TEXT\n' > "$TMP/in"
"$DAS_ROOT/s6text" --encode "$TMP/in" "$TMP/out.s6"
"$DAS_ROOT/s6text" --check "$TMP/out.s6"
"$DAS_ROOT/s6text" --decode "$TMP/out.s6" "$TMP/back"
cmp "$TMP/in" "$TMP/back"
printf 'lowercase\n' > "$TMP/bad"
if "$DAS_ROOT/s6text" --encode "$TMP/bad" "$TMP/bad.s6" >/dev/null 2>&1; then
    echo 's6text accepted lowercase input' >&2
    exit 1
fi
printf '\001\000\000\000\000\000\000\000' > "$TMP/malformed"
if "$DAS_ROOT/s6text" --check "$TMP/malformed" >/dev/null 2>&1; then
    echo 's6text accepted malformed record' >&2
    exit 1
fi
