#!/bin/sh
# Verify real PDP-6 packed BLKmode copy via 9-bit byte pointers.
# The optional -B override is ONLY for testing an uninstalled staged cc1.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-gcc-packed-block-bp-v1.XXXXXXXX")
if [ "${P10TK_PACKED_KEEP_WORK:-0}" != 1 ]; then
    trap 'rm -rf "$work"' EXIT HUP INT TERM
else
    echo "packed block-copy evidence: $work"
fi

if [ -n "${P10TK_GCC_CC1_DIR:-}" ]; then
    test -x "${P10TK_GCC_CC1_DIR%/}/cc1" || {
        echo "missing staged GCC cc1: $P10TK_GCC_CC1_DIR" >&2
        exit 1
    }
fi
for opt in O0 O1 O2 Os; do
    asm="$work/packed-block-bytepointer-$opt-v1.s"
    set -- -S "-$opt" -march=pdp6
    if [ -n "${P10TK_GCC_CC1_DIR:-}" ]; then
        set -- "-B${P10TK_GCC_CC1_DIR%/}/" "$@"
    fi
    "$PDP10_GCC" "$@" \
        "$root/tests/semantic/validation-gcc/gcc-packed-block-bytepointer-v1.c" \
        -o "$asm"

    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 100000000 --timeout 25 \
        --workdir "$work/run-$opt" --name "gcc-packed-block-$opt-v1" \
        --expect __test_exit=0 \
        "$root/support/crt0-upstream-v1.s" "$asm" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    echo "PASS GCC PDP-6 packed block-copy byte-pointer $opt"
done
