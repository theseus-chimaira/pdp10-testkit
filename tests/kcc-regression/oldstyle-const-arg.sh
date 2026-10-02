#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

tmp=${TMPDIR:-/tmp}/kcc-oldstyle-const-arg.$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat >"$tmp/test.c" <<'EOF'
static int
first(p)
const unsigned long *p;
{
        return *p != 0;
}

int
test()
{
        unsigned long a[1];

        a[0] = 1;
        return first(&a[0]);
}
EOF
kcc=$(pwd)/kcc
(
        cd "$tmp"
        "$kcc" -S -x=pdp6 -D__PDP10__ test.c >out 2>err
)
if grep -E '\[(Advisory|Note|Warning|Error)\]|warnings? detected|errors? detected' "$tmp/err" >/dev/null 2>&1; then
        cat "$tmp/err" >&2
        exit 1
fi
