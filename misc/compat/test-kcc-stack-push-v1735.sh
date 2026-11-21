#!/bin/sh
# Physical KCC ABI: one stack argument, including nested-call fallback.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
KCC=${KCC_V1735_OVERRIDE:-$KCC}
: "${TMPDIR:?TMPDIR must be set}"
tmp="$TMPDIR/p10tk-kcc-stack-push-v1735-$$"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"
for unit in main callee; do
    (cd "$tmp" && TERM=dumb "$KCC" -S -v=nostats -x=base \
        -R="v1735-$unit" \
        "$root/misc/compat/kcc-stack-push-v1735-$unit.c")
done
"$P10RUN" --machine ks10 --mode deposit --exec-mode step \
    --step-limit 2000000 --timeout 25 --workdir "$tmp/run" \
    --name kcc_stack_push_v1735 --expect __test_exit=0 \
    "$root/support/crt0.s" "$root/misc/compat/mixed-call-support.s" \
    "$root/misc/compat/mixed-stack-support.s" \
    "$tmp/v1735-main.s" "$tmp/v1735-callee.s" >/dev/null
echo 'KCC one-stack-word and nested-call ABI v1735: PASS'
