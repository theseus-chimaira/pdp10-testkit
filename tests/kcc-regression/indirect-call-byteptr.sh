#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-indirect-call-byteptr-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat > "$tmp/test.c" <<'SRC'
static int add_at(p, i, v)
char *p;
int i;
int v;
{
    p[i] = (char)(p[i] + v);
    return p[i];
}

static int callit(fn, p, i, v)
int (*fn)();
char *p;
int i;
int v;
{
    return (*fn)(p, i, v) + p[0];
}

int main()
{
    char b[4];
    b[0] = 10;
    b[1] = 20;
    b[2] = 30;
    b[3] = 40;
    return callit(add_at, b, 2, 7) != 47;
}
SRC

(cd "$tmp" && "$PDP10_PREFIX/bin/kcc" -S -v=nostats -n -x=base -R=test test.c)

sed -n '/^callit:/,/^main:/p' "$tmp/test.s" > "$tmp/callit.s"

grep -Eq '^[[:space:]]*move[[:space:]]+16,1([[:space:]]|$)' "$tmp/callit.s"
grep -Eq '^[[:space:]]*pushj[[:space:]]+17,0\(16\)([[:space:]]|$)' "$tmp/callit.s"

if grep -Eq '^[[:space:]]*pushj[[:space:]]+17,0\([1-4]\)([[:space:]]|$)' "$tmp/callit.s"; then
    echo "indirect call target left in an ABI argument register" >&2
    exit 1
fi

echo "indirect function-call byte-pointer regression passed"
