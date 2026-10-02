#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
work=$(mktemp -d "${TMPDIR%/}/p10super-cfg-v1.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

check_guard()
{
        name=$1
        op=$2
        ./tests/p10super-cfg-mk "$work/$name.dobj" "$op"
        ./p10super "$work/$name.dobj" >"$work/$name.out" 2>&1
        grep -F 'CFG-GUARD-SUFFIX' "$work/$name.out" >/dev/null || {
                echo "p10super missed $name conditional guard equivalence" >&2
                cat "$work/$name.out" >&2
                exit 1
        }
}

# Condition 2 is a real two-way conditional skip in every family below.
check_guard skip 0332
check_guard aos 0352
check_guard sos 0372
check_guard tr 0602
check_guard tl 0612

echo "p10super conditional CFG normalization: PASS"
