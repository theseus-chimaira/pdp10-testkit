#!/bin/sh
# Real PDP-6 packed short-field readback through static and dynamic objects.
# Optional staged cc1 override is limited to this manual regression.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-gcc-packed-halfword-v1.XXXXXXXX")
if [ "${P10TK_PACKED_KEEP_WORK:-0}" != 1 ]; then
    trap 'rm -rf "$work"' EXIT HUP INT TERM
else
    echo "packed halfword evidence: $work"
fi

if [ -n "${P10TK_GCC_CC1_DIR:-}" ]; then
    test -x "${P10TK_GCC_CC1_DIR%/}/cc1" || {
        echo "missing staged GCC cc1: $P10TK_GCC_CC1_DIR" >&2
        exit 1
    }
fi

# Check every supported optimization level. The exact original upstream
# source and the independent static/dynamic halfword regression must agree.
for opt in ${P10TK_PACKED_PROFILES:-O0 O1 O2 Os}; do
    case "$opt" in
        O0|O1|O2|Os) ;;
        *) echo "invalid packed halfword profile: $opt" >&2; exit 2 ;;
    esac
    asm="$work/packed-halfword-$opt-v1.s"
    set -- -S "-$opt" -march=pdp6
    if [ -n "${P10TK_GCC_CC1_DIR:-}" ]; then
        set -- "-B${P10TK_GCC_CC1_DIR%/}/" "$@"
    fi
    "$PDP10_GCC" "$@" \
        "$root/tests/semantic/validation-gcc/gcc-packed-halfword-readback-v1.c" \
        -o "$asm"

    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 100000000 --timeout 25 \
        --workdir "$work/run-$opt" --name "gcc-packed-halfword-$opt-v1" \
        --expect __test_exit=0 \
        "$root/support/crt0-upstream-v1.s" "$asm" \
        "$root/support/exit-v1.s" "$root/support/abort-v1.s"
    echo "PASS GCC PDP-6 packed halfword readback $opt"
done
