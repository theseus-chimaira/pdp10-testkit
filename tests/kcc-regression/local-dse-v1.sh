#!/bin/sh
set -eu

testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env

KCC=$PDP10_PREFIX/bin/kcc
P10RUN=$PDP10_PREFIX/bin/p10run
TMPROOT=${TMPDIR:-.}/kcc-local-dse-v1-$$
trap 'rm -rf "$TMPROOT"' EXIT HUP INT TERM
mkdir -p "$TMPROOT"

src="$testroot/../semantic/kcc-regression/kcc_longlong_promotion_min.c"
crt="$testroot/semantic-crt0.s"

# The three sizeof temporaries are used only by conditions which KCC folds.
# Their stores must therefore disappear before statement emission.
d="$TMPROOT/base"
mkdir -p "$d"
cp "$src" "$d/test.c"
(
    cd "$d"
    "$KCC" -S -v=nostats -x=base -R=dse test.c >/dev/null
)
if grep -Eiq '^[[:space:]]*movem[[:space:]]+[0-7]+,-[456]\(17\)' "$d/dse.s"; then
    echo "dead constant-local store survived" >&2
    exit 1
fi

# Run the same optimized program on every supported CPU personality.  This
# guards the reference-count rewrite as well as the generated DImode traffic.
for cpu in pdp6 ka10 ki10 ks10; do
    d="$TMPROOT/$cpu"
    mkdir -p "$d"
    cp "$src" "$d/test.c"
    (
        cd "$d"
        "$KCC" -S -v=nostats -x="$cpu" -R=dse test.c >/dev/null
    )
    "$P10RUN" --machine "$cpu" --mode deposit --exec-mode step \
        --start 1000 --step-limit 1000000 --timeout 10 \
        --workdir "$d/run" --name dse --expect __test_exit=0 \
        "$crt" "$d/dse.s" >/dev/null
done

echo "local dead-store regression passed"
