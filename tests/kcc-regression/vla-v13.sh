#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_require_prefix
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
export KCC

tmp=${TMPDIR:-/tmp}/kcc-vla-v13-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

run_one_v13()
{
    src=$1
    stem=$2
    cp "$src" "$tmp/$stem.c"
    (
        cd "$tmp"
        TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R="$stem" "$stem.c" >/dev/null
    )
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 100000000 --timeout 20 --workdir "$tmp/run-$stem" \
        --name "$stem" --expect __test_exit=0 \
        "$testroot/semantic-crt0.s" "$tmp/$stem.s" "$KCC_RT" >/dev/null
}

run_one_v13 "$testroot/../semantic/base/base_vla_v13.c" vla-base-v13
run_one_v13 "$testroot/../semantic/kcc-modern/kcc_modern_vla_scope_v13.c" vla-scope-v13

cp "$testroot/vla-goto-in-v13.c" "$tmp/vla-goto-in-v13.c"
if (
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=vla-goto-in-v13 \
        vla-goto-in-v13.c >vla-goto-in-v13.log 2>&1
); then
    echo "error: KCC accepted goto into VLA scope" >&2
    exit 1
fi
grep -q 'Goto enters scope of variable length array' "$tmp/vla-goto-in-v13.log" || {
    echo "error: missing VLA goto diagnostic" >&2
    cat "$tmp/vla-goto-in-v13.log" >&2
    exit 1
}

cp "$testroot/vla-switch-in-v13.c" "$tmp/vla-switch-in-v13.c"
if (
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=vla-switch-in-v13         vla-switch-in-v13.c >vla-switch-in-v13.log 2>&1
); then
    echo "error: KCC accepted switch into VLA scope" >&2
    exit 1
fi
grep -q 'Switch label enters scope of variable length array'     "$tmp/vla-switch-in-v13.log" || {
    echo "error: missing VLA switch diagnostic" >&2
    cat "$tmp/vla-switch-in-v13.log" >&2
    exit 1
}

cp "$testroot/vla-static-v13.c" "$tmp/vla-static-v13.c"
if (
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=vla-static-v13         vla-static-v13.c >vla-static-v13.log 2>&1
); then
    echo "error: KCC accepted static VLA object" >&2
    exit 1
fi
grep -q 'Variable length array must have automatic storage duration'     "$tmp/vla-static-v13.log" || {
    echo "error: missing static VLA diagnostic" >&2
    cat "$tmp/vla-static-v13.log" >&2
    exit 1
}

printf '%s\n' 'KCC VLA regressions passed'
