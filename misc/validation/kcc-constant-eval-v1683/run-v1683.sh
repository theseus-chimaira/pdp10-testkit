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
    runner=${P10RUN_BIN:-${PDP10_PREFIX:-$HOME/cross}/bin/p10run}
    if ! test -x "$runner"; then
        echo "FAIL: missing PDP-6 runner: $runner" >&2
        exit 1
    fi
    "$runner" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 250000 --timeout 25 \
        --workdir "$work/pdp6-$opt" \
        --name "kcc-c89-constant-v1683-$opt" \
        --expect __test_exit=0 \
        "$here/../../../support/crt0-upstream-v1.s" \
        "$work/$opt.s" >"$work/$opt.run.log" 2>&1 || {
        tail -75 "$work/$opt.run.log" >&2
        echo "FAIL: $opt PDP-6 constant folding runtime" >&2
        exit 1
    }
    echo "PASS v1683: $opt valid C89 folding, dimensions and PDP-6 execution"
done
