#!/bin/sh
# A configuration-file quit exercises the debug descriptor cleanup
# without relying on asynchronous keyboard input on a nonterminal.
set -eu
: "${PDP10_PREFIX:?PDP10_PREFIX must be set}"
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/ts10-quit-v60d.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
cd "$work"
printf 'quit\n' > quit.ini
ulimit -c 0
timeout 15 "$PDP10_PREFIX/bin/ts10" -f quit.ini </dev/null > quit.log 2>&1 || { cat quit.log; exit 1; }
grep -q 'TS10 Emulator Exit (Reason: Quit Command)' quit.log
test -f debug.log
echo 'PASS: TS10 debug stream shutdown'
