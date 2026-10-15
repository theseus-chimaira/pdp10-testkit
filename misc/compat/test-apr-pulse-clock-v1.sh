#!/bin/sh
# Validate the AAP APR logical delay accumulator without hardware timing guesses.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/apr-pulse-clock-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
source_root=${PDP6_AAP_ROOT:-"$root/../pdp6"}
cc -std=c99 -Wall -Wextra -Werror \
    -I"$source_root/emu" "$root/misc/compat/test-apr-pulse-clock-v1.c" \
    -o "$work/test-clock"
"$work/test-clock"
echo 'PDP-6 AAP APR logical pulse clock v1: PASS'
