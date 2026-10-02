#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-pointer-void-roundtrip-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
cat > "$tmp/t.c" <<'SRC'
volatile int __test_exit;

typedef signed _KCCtype_char9 char9;
typedef unsigned _KCCtype_char9 uchar9;
typedef signed _KCCtype_char18 short18;

struct rec {
    char9 c9[4];
    uchar9 u9[4];
    short18 h18[3];
};

static void *
as_void(p)
void *p;
{
    return p;
}

static int
run(r)
struct rec *r;
{
    char9 *pc9;
    uchar9 *pu9;
    short18 *ph18;
    void *vp;

    r->c9[1] = (char9)-255;
    r->u9[1] = (uchar9)0777;
    r->h18[0] = (short18)-012345;
    r->h18[1] = (short18)012345;

    pc9 = &r->c9[1];
    vp = as_void((void *)pc9);
    pc9 = (char9 *)vp;
    if ((int)*pc9 != -255)
        return 1;

    pu9 = (uchar9 *)(void *)&r->u9[1];
    vp = as_void((void *)pu9);
    pu9 = (uchar9 *)vp;
    if ((int)*pu9 != 0777)
        return 2;

    ph18 = &r->h18[0];
    vp = as_void((void *)(ph18 + 1));
    ph18 = (short18 *)vp;
    if ((int)*ph18 != 012345)
        return 3;
    if (ph18 - &r->h18[0] != 1)
        return 4;

    return 0;
}

int
main()
{
    struct rec r;
    return run(&r);
}
SRC
for opt in opt noopt; do
    case "$opt" in
    opt) opts= ;;
    noopt) opts=-n ;;
    esac
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats $opts -x=base -R="ptr-$opt" t.c
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 3000000 --timeout 20 --workdir "$tmp/run-$opt" \
        --name "pointer-void-roundtrip-$opt" --expect __test_exit=0 \
        "$testroot/semantic-crt0.s" "$tmp/ptr-$opt.s" "$KCC_RT" >/dev/null
done
printf '%s\n' 'pointer void round-trip regression passed'
