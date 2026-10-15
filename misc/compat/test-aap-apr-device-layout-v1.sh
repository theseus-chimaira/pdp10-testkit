#!/bin/sh
# Structural regression for AAP's Device-to-Apr ownership invariant.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/aap-apr-layout-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
aap=${PDP6_AAP_ROOT:-"$root/../pdp6"}
cc -std=c99 -Wall -Wextra -Werror -I"$aap/emu" \
    "$root/misc/compat/test-aap-apr-device-layout-v1.c" -o "$work/check"
"$work/check"
echo 'AAP APR device layout v1: PASS'
