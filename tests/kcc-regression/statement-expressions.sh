#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-statement-expressions-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;

static int twice_plus(int x)
{
    return ({ int y = x + 1; y *= 2; y + 3; });
}

static int absolute_value(int x)
{
    return ({ int y = x; if (y < 0) y = -y; y; });
}

static int mixed_live(int a, int b)
{
    return a * 7 + ({ int y = b + 2; y * 3; }) + a;
}

static int side_effect(int *p)
{
    return ({ *p += 4; *p; });
}

int main(void)
{
    int x;

    if (twice_plus(4) != 13) return 1;
    if (absolute_value(-7) != 7) return 2;
    if (mixed_live(5, 6) != 64) return 3;
    if (({ int y = 2; ({ y += 3; y; }); }) != 5) return 4;
    if (sizeof(({ int y = 1; y; })) != sizeof(int)) return 5;
    x = 10;
    if (side_effect(&x) != 14 || x != 14) return 6;
    (void)({ int y = x; y += 1; });
    return 0;
}
SRC

cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=statement-expressions t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name statement-expressions --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/statement-expressions.s" "$KCC_RT" >/dev/null

cat > "$tmp/file-scope.c" <<'SRC'
int x = ({ int y = 1; y; });
SRC
set +e
TERM=dumb "$KCC" -S -v=nostats "$tmp/file-scope.c" \
    >"$tmp/file-scope.out" 2>"$tmp/file-scope.err"
status=$?
set -e
if test "$status" -eq 0; then
    echo 'file-scope statement expression unexpectedly accepted' >&2
    exit 1
fi
if test "$status" -gt 128; then
    echo 'file-scope statement expression terminated KCC by signal' >&2
    cat "$tmp/file-scope.err" >&2
    exit 1
fi
grep -q 'Statement expressions are only allowed inside functions' \
    "$tmp/file-scope.err" || {
    echo 'missing file-scope statement-expression diagnostic' >&2
    cat "$tmp/file-scope.err" >&2
    exit 1
}
if grep -q '\[Internal error\]' "$tmp/file-scope.err"; then
    echo 'file-scope statement expression triggered internal error' >&2
    cat "$tmp/file-scope.err" >&2
    exit 1
fi

printf '%s\n' 'GNU statement expression regression passed'
