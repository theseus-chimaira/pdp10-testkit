#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
tmp=kq$$
trap 'rm -f "$tmp.c" "$tmp.s"' 0 1 2 3 15

cat > "$tmp.c" <<'SRC'
static int safe_max(x, y)
int x;
int y;
{
    return x > y ? x : y;
}

static int unsafe_after(x, q)
int x;
int q;
{
    return (q ? 1 : 2) + x;
}

static int ac2_safe(q, x)
int q;
int x;
{
    return (q ? 1 : 2) + x;
}
SRC

"$KCC" -S -v=nostats -x=base -R="$tmp" "$tmp.c" >/dev/null

safe=$(awk '/^safe_max:/{p=1;next}/^[A-Za-z_][A-Za-z0-9_]*:/{if(p)exit}p' "$tmp.s")
unsafe=$(awk '/^unsafe_after:/{p=1;next}/^[A-Za-z_][A-Za-z0-9_]*:/{if(p)exit}p' "$tmp.s")
ac2=$(awk '/^ac2_safe:/{p=1;next}/^[A-Za-z_][A-Za-z0-9_]*:/{if(p)exit}p' "$tmp.s")

case "$safe" in
  *'push'*',10'*) echo 'direct return query unnecessarily preserves AC1' >&2; exit 1;;
esac
case "$unsafe" in
  *'push'*',10'*) echo 'simple query unnecessarily preserves AC1' >&2; exit 1;;
esac
case "$unsafe" in
  *'movei'\ *'1,1'*|*'movei'\ *'1,2'*) echo 'simple query still merges through live AC1' >&2; exit 1;;
esac
case "$ac2" in
  *'push'*',10'*|*'push'*',11'*) echo 'scalar query unnecessarily preserves AC2' >&2; exit 1;;
esac

echo 'ABI query liveness regression passed'
