#!/bin/sh
set -eu
TEST_ROOT=$1
DAS=$2
case ${DAS##*/} in
    pdp10-dec-none-as) set -- -a -o ;;
    *) set -- -A -O ;;
esac
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}
A=$TMPDIR/das-c-comments-$$.dxr
B=$TMPDIR/das-c-comments-ref-$$.dxr
BAD=$TMPDIR/das-c-comments-bad-$$.s
trap 'rm -f "$A" "$B" "$BAD"' 0 1 2 3 15
"$DAS" "$@" "$A" "$TEST_ROOT/dxr-c-comments.s"
"$DAS" "$@" "$B" "$TEST_ROOT/dxr-c-comments-reference.s"
cmp "$A" "$B"
printf '%s\n' '.TEXT' 'MOVEI 1,1 /* unterminated' > "$BAD"
if "$DAS" "$@" "$A" "$BAD" 2>/dev/null; then
    echo 'DAS accepted unterminated C-style block comment' >&2
    exit 1
fi
echo 'DAS GAS-style block comment regression passed'
