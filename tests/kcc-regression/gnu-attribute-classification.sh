#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
: "${TMPDIR:?TMPDIR must be set}"
tmp=$TMPDIR/kcc-gnu-attribute-classification-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/ok.c" <<'SRC'
struct P { char a; char b; } __attribute__((packed));
struct A { char a; char b __attribute__((aligned(2))); };
static int __attribute__((unused)) u;
static int __attribute__((deprecated)) d;
static int __attribute__((noinline)) f(void) { return sizeof(struct P) + sizeof(struct A) + u + d; }
int main(void) { return f() == 0; }
SRC
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=ok ok.c >/dev/null 2>ok.err
)
for attr in weak alias section mode visibility constructor destructor used common nocommon dllimport dllexport; do
    case "$attr" in
        alias) decl='extern int x(void) __attribute__((alias("y")));' ;;
        section) decl='int x __attribute__((section("foo")));' ;;
        mode) decl='typedef int x __attribute__((mode(SI)));' ;;
        visibility) decl='int x __attribute__((visibility("hidden")));' ;;
        constructor|destructor) decl="void x(void) __attribute__(($attr));" ;;
        *) decl="int x __attribute__(($attr));" ;;
    esac
    printf '%s\n' "$decl" > "$tmp/$attr.c"
    if (
        cd "$tmp"
        TERM=dumb "$KCC" -S -v=nostats -x=base -R="$attr" "$attr.c" >"$attr.out" 2>"$attr.err"
    ); then
        echo "KCC unexpectedly accepted GNU attribute $attr" >&2
        exit 1
    fi
    grep -q 'GNU attribute .* is not supported' "$tmp/$attr.err"
done
cat > "$tmp/unknown.c" <<'SRC'
int x __attribute__((mystery_attr));
SRC
(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -R=unknown unknown.c >unknown.out 2>unknown.err
)
grep -q 'Unknown GNU attribute mystery_attr ignored' "$tmp/unknown.err"
printf '%s\n' 'GNU attribute classification regression passed'
