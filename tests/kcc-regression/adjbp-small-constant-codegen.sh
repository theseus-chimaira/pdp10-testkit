#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work="$TMPDIR/kcc-adjbp-small-constant-codegen-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"
cat > "$work/t.c" <<'SRC'
char *f(char *p)
{
        return p + 2;
}
SRC
cd "$work"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=p6 t.c
if grep -q '%ADJBPH' p6.s; then
        echo 'PDP-6 small constant byte-pointer adjustment uses ADJBP helper' >&2
        exit 1
fi
[ "$(grep -Eic '^[[:space:]]*ibp[[:space:]]' p6.s || true)" -eq 2 ] || {
        echo 'PDP-6 p+2 did not become exactly two IBPs' >&2
        exit 1
}
TERM=dumb "$KCC" -S -v=nostats -x=ks10 -R=ks t.c
if ! grep -Eiq '^[[:space:]]*adjbp[[:space:]]' ks.s; then
        echo 'KS10 p+2 lost native ADJBP' >&2
        exit 1
fi
printf '%s\n' 'small constant ADJBP codegen regression passed'
