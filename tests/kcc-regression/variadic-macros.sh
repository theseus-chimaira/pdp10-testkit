#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-variadic-macros-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;

#define ADD(a, ...) ((a) + (__VA_ARGS__))
#define CALL(fn, ...) fn(__VA_ARGS__)
#define LIST(...) __VA_ARGS__
#define CAT(a, ...) a ## __VA_ARGS__
#define SUFFIX(...) __VA_ARGS__ ## tail
#define NOTHING(...) __VA_ARGS__
#define BOTH(...) __VA_ARGS__ ## __VA_ARGS__
#define STR(...) #__VA_ARGS__
#define EXPAND(...) __VA_ARGS__

static int sum3(int a, int b, int c)
{
    return a + b + c;
}

static int foo = 11;
static int foo7 = 17;
static int tail = 19;
char *variadic_string = STR(alpha, beta, 3);

int main(void)
{
    int a[3] = { LIST(4, 5, 6) };
    int z = 1 NOTHING();
    int q = 1 BOTH();

    if (ADD(1, 2) != 3) return 1;
    if (CALL(sum3, 1, 2, 3) != 6) return 2;
    if (a[0] != 4 || a[1] != 5 || a[2] != 6) return 3;
    if (CAT(foo, 7) != 17) return 4;
    if (CAT(foo) != 11) return 5;
    if (SUFFIX() != 19) return 6;
    if (z != 1 || q != 1) return 7;
    if (ADD(EXPAND(2), EXPAND(3 + 4)) != 9) return 8;
    return 0;
}
SRC

cd "$tmp"
TERM=dumb "$KCC" -E -v=nostats t.c > t.i
if ! grep -F 'char *variadic_string = "alpha, beta, 3";' t.i >/dev/null; then
    echo 'variadic macro stringization expansion mismatch' >&2
    grep 'variadic_string' t.i >&2 || true
    exit 1
fi

check_bad()
{
    name=$1
    diagnostic=$2
    src=$3
    cat > "$tmp/$name.c" <<SRC
$src
SRC
    set +e
    TERM=dumb "$KCC" -E -v=nostats "$tmp/$name.c" \
        >"$tmp/$name.out" 2>"$tmp/$name.err"
    status=$?
    set -e
    if test "$status" -eq 0; then
        echo "$name unexpectedly accepted" >&2
        exit 1
    fi
    if test "$status" -gt 128; then
        echo "$name terminated KCC by signal" >&2
        cat "$tmp/$name.err" >&2
        exit 1
    fi
    if ! grep -q "$diagnostic" "$tmp/$name.err"; then
        echo "$name missing expected diagnostic: $diagnostic" >&2
        cat "$tmp/$name.err" >&2
        exit 1
    fi
}

check_bad misplaced-ellipsis 'Ellipsis must end macro formal parameter list' \
'#define BAD(a, ..., b) a'
check_bad vaargs-outside '__VA_ARGS__ may only appear in a variadic macro' \
'#define BAD(a) __VA_ARGS__'
check_bad vaargs-formal '__VA_ARGS__ is reserved for variadic macro arguments' \
'#define BAD(__VA_ARGS__) 1'
check_bad too-few-fixed 'at least 2 expected' \
'#define BAD(a, b, ...) a
int x = BAD(1);'

TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=variadic t.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run" \
    --name variadic-macros --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/variadic.s" "$KCC_RT" >/dev/null
printf '%s\n' 'variadic macro regression passed'
