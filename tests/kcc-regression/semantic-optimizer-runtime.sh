#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-semantic-optimizer-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

if ! command -v "$P10RUN" >/dev/null 2>&1 && [ ! -x "$P10RUN" ]; then
    echo "semantic optimizer runtime test: P10RUN not found" >&2
    exit 77
fi

for cpu in pdp6 ka10 ki10 ks10; do
    d="$TMP/$cpu"
    mkdir -p "$d"
    cp "$testroot/semantic-optimizer-runtime.c" "$d/test.c"
    (
        cd "$d"
        "$KCC" -x="$cpu" -D__PDP10__ -S test.c >/dev/null
    )
    "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
        --start 1000 --step-limit 1000000 --timeout 10 \
        --workdir "$d/run" --name semantic \
        --expect __test_exit=0 "$testroot/semantic-crt0.s" "$d/test.s" >/dev/null
    echo "$cpu semantic optimizer runtime passed"
done
