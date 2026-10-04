#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
DAIMOS_REPO=${DAIMOS_REPO:-../DAIMOS}
CC=${CC:-cc}
work="$TMPDIR/pdp10-testkit-type340-text-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"

"$CC" -std=c99 -Wall -Wextra -Werror \
    -I"$DAIMOS_REPO/system/kernel/drivers" \
    -I"$DAIMOS_REPO/system/kernel/core" \
    -I"$DAIMOS_REPO/system/kernel/mm" \
    tests/daimos/type340-text-v1.c -o "$work/type340-text-v1"
"$work/type340-text-v1"

grep -Eq '^#define[[:space:]]+DPY_TEXT_ROW_WORDS[[:space:]]+14U$' \
    "$DAIMOS_REPO/system/kernel/drivers/dpy_text.c" || {
        echo 'type340-text-v1: logical row is not 14 packed SIXBIT words' >&2
        exit 1
}

# The large text/cache store must remain an MM allocation, never fixed MRES
# BSS.  This is also the permanent-size accounting contract.
grep -q 'MM_TYPE_KERNEL_DYNAMIC' "$DAIMOS_REPO/system/kernel/drivers/dpy_text.c"
if grep -Eq '\.block[[:space:]]+(03726|2006)' \
    "$DAIMOS_REPO/system/kernel/drivers/dpy_io.s"; then
        echo 'type340-text-v1: display text buffer leaked into MRES BSS' >&2
        exit 1
fi
grep -Eq '^[[:space:]]*blko[[:space:]]+0130,dpy_refresh_iowd' \
    "$DAIMOS_REPO/system/kernel/drivers/dpy_io.s" || {
        echo 'type340-text-v1: retained refresh is not using Type-344 BLKO' >&2
        exit 1
}
if awk '
    /^dpy_putchar:/ { in_putchar=1 }
    in_putchar && /^dpy_text_setup_words:/ { exit }
    in_putchar { print }
' "$DAIMOS_REPO/system/kernel/drivers/dpy_io.s" |
    grep -Eq 'datao[[:space:]]+0130'; then
        echo 'type340-text-v1: terminal putchar performs DPY DATAO' >&2
        exit 1
fi

printf '%s\n' 'type340-text-v1: permanent-buffer policy PASS'
printf '%s\n' 'type340-text-v1: BLKO refresh policy PASS'
