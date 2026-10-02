#!/bin/sh
set -eu

DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to DAS source tree}
PDP10_PREFIX=${PDP10_PREFIX:?set PDP10_PREFIX}
TMPDIR=${TMPDIR:?set TMPDIR to writable temporary directory}
WORK=$(mktemp -d "$TMPDIR/das-reloc-negative-addend-v1.XXXXXX")
trap 'rm -rf "$WORK"' EXIT HUP INT TERM

cat > "$WORK/t.s" <<'EOS'
        .text
        .globl __start
__start:
        move 3,[foo-024000]
        halt
foo:
        .word 0
EOS

"$DAS_ROOT/das" -C -O "$WORK/t.dobj" "$WORK/t.s"
"$PDP10_PREFIX/bin/dlink" -b 030000 -o "$WORK/t.dxr" "$WORK/t.dobj"
word=$(
    "$DAS_ROOT/dxrcheck" -d "$WORK/t.dxr" |
    awk '$1 == "IMAGE" && $2 == "000003" { print $3 }'
)
case "$word" in
    000000004002) ;;
    *)
        echo "DAS relocatable negative addend leaked into LH: $word" >&2
        exit 1
        ;;
esac

echo "DAS relocatable negative-addend contract: PASS"
