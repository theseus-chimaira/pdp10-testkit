#!/bin/sh
# Test KCC on valid *C89 compiler* constant expressions, not DAIMOS.
set -eu
TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/pdp10-kcc-constant-v1683.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
here=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
KCC_BIN=${KCC_BIN:-${PDP10_PREFIX:-$HOME/cross}/bin/kcc}
if ! test -x "$KCC_BIN"; then
    echo "FAIL: missing KCC compiler: $KCC_BIN" >&2
    exit 1
fi
for opt in optimized unoptimized; do
    if test "$opt" = optimized; then
        flags=-O
    else
        flags=-n
    fi
    "$KCC_BIN" -Pgnu99 -x=pdp6 -m=gas $flags -S \
        "$here/valid-v1683.c" -o "$work/$opt.s" \
        >"$work/$opt.log" 2>&1 || {
        cat "$work/$opt.log" >&2
        echo "FAIL: ordinary C89 constants rejected ($opt)" >&2
        exit 1
    }
    if ! test -s "$work/$opt.s"; then
        echo "FAIL: missing $opt generated PDP-6 assembly" >&2
        exit 1
    fi
    if grep -iE 'constant expression overflow|internal error|fatal error' \
        "$work/$opt.log"; then
        echo "FAIL: unexpected C89 constant-expression diagnostic" >&2
        exit 1
    fi
    echo "PASS v1683: $opt valid C89 integer dimensions/enum folding"
done
