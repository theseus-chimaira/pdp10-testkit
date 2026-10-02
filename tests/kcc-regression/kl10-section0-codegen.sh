#!/bin/sh
set -eu
: "${TMPDIR:?TMPDIR must be set}"
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
work="$TMPDIR/kcc-kl10-section0-codegen-v1-$$"
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"
cat > "$work/t.c" <<'SRC'
struct pair { int a; int b; };
char *bump(char *p, int n) { return p + n; }
double dadd(double a, double b) { return a + b; }
struct pair copy_pair(struct pair *p) { return *p; }
int frame(int x) { int a[6]; a[0] = x; a[5] = x + 1; return a[0] + a[5]; }
SRC
cd "$work"
TERM=dumb "$KCC" -S -v=nostats -x=kl10 -R=kl t.c
for op in adjbp adjsp dfad dmove; do
    if ! grep -Eiq "^[[:space:]]*$op[[:space:]]" kl.s; then
        echo "KL10 section-0 codegen did not use $op" >&2
        exit 1
    fi
done
if grep -q '%ADJBPH' kl.s; then
    echo 'KL10 section-0 codegen unexpectedly used ADJBP helper' >&2
    exit 1
fi
printf '%s\n' 'KL10 section-0 codegen regression passed'
