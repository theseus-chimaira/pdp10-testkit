#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
TMPBASE=${TMPDIR:-/tmp}
TMP=$TMPBASE/kcc-gnu-function-attributes-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"
cat > "$TMP/test.c" <<'SRC'
extern void die(void) __attribute__((__noreturn__));
static inline void __attribute__((__noinline__)) helper(void) { }
__attribute__((noreturn)) void bad(void) { return; }
_Noreturn void bad2(void) { return; }
void use(void) { helper(); die(); }
SRC
(cd "$TMP" && "$KCC" -S test.c >out 2>err) || true
grep -q 'inline function given attribute noinline' "$TMP/err"
test "$(grep -c 'return statement in noreturn function' "$TMP/err")" -eq 2
# The recognized noinline function must remain an out-of-line callable symbol.
grep -q 'helper' "$TMP/test.s"
printf '%s\n' 'GNU noreturn/noinline attribute regression passed'
