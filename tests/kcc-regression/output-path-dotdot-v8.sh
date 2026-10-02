#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_require_prefix
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
export KCC
tmp=${TMPDIR:-/tmp}/kcc-output-path-dotdot-v8-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp/src" "$tmp/out"
cat > "$tmp/src/t.c" <<'SRC'
int main(void) { return 0; }
SRC
(
    cd "$tmp/src"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=../out/result t.c >/dev/null
)
test -s "$tmp/out/result.s"
test ! -e "$tmp/src/.s"
printf '%s\n' 'KCC -R ../ output-path regression passed'
