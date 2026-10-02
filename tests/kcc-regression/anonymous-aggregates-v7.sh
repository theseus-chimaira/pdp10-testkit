#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_require_prefix
root=$PDP10_PREFIX/lib/kcc
kcc_setup_env
KCC=$PDP10_PREFIX/bin/kcc
export KCC
tmp=${TMPDIR:-/tmp}/kcc-anonymous-aggregates-v7-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

run_one_v7()
{
    src=$1
    stem=$2
    cp "$src" "$tmp/$stem.c"
    (
        cd "$tmp"
        TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R="$stem" "$stem.c" >/dev/null
    )
    "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
        --step-limit 1000000 --timeout 20 --workdir "$tmp/run-$stem" \
        --name "$stem" --expect __test_exit=0 \
        "$testroot/semantic-crt0.s" "$tmp/$stem.s" "$KCC_RT" >/dev/null
}

run_one_v7 "$testroot/../semantic/base/base_anonymous_aggregate_v7.c" anon-base-v7
run_one_v7 "$testroot/../semantic/kcc-modern/kcc_modern_anonymous_designator_v7.c" anon-designator-v7
printf '%s\n' 'KCC anonymous aggregate regressions passed'
