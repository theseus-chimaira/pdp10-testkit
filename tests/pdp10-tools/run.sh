#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
: "${PDP10_TOOLS_REPO:?PDP10_TOOLS_REPO must be set}"

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$PDP10_TOOLS_REPO" && pwd)
work=$TMPDIR/pdp10-tools-regression-v1-$$
trap 'rm -rf "$work"' 0 1 2 3 15
mkdir -p "$work/tests"

${MAKE:-make} -C "$repo" all

for f in dlink darc p10run pdp10-objdump p10fold p10super mktap; do
        ln -s "$repo/$f" "$work/$f"
done
ln -s "$repo/p10run.c" "$work/p10run.c"

for f in dobj-test.c pdp10-objdump-test.c pdp10-objdump-test.sh \
        p10fold-link-test.c p10fold-link-test.sh \
        p10super-cfg-test.c p10super-cfg-test.sh \
        p10super-rewrite-test.c p10super-rewrite-test.sh \
        p10run-functional-test.sh mktap-mtc-7track-v1-test.sh; do
        cp "$here/$f" "$work/tests/$f"
done
chmod 755 "$work/tests"/*.sh

${CC:-c99} ${CFLAGS:--O2} -I"$repo" -o "$work/tests/dobj-test" \
        "$work/tests/dobj-test.c" "$repo/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$repo" -o "$work/tests/pdp10-objdump-mk" \
        "$work/tests/pdp10-objdump-test.c" "$repo/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$repo" -o "$work/tests/p10super-cfg-mk" \
        "$work/tests/p10super-cfg-test.c" "$repo/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$repo" -o "$work/tests/p10super-rewrite-mk" \
        "$work/tests/p10super-rewrite-test.c" "$repo/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$repo" -o "$work/tests/p10fold-link-mk" \
        "$work/tests/p10fold-link-test.c" "$repo/dobj.c"

(
        cd "$work"
        ./tests/dobj-test
        ./tests/pdp10-objdump-test.sh
        TMPDIR="$TMPDIR" P10FOLD_LINK_MK="$work/tests/p10fold-link-mk" \
                P10FOLD="$work/p10fold" DLINK="$work/dlink" \
        ./tests/p10fold-link-test.sh
        ./tests/p10super-cfg-test.sh
        ./tests/p10super-rewrite-test.sh
        ./tests/p10run-functional-test.sh
        ./tests/mktap-mtc-7track-v1-test.sh
)

TMPDIR="$TMPDIR" PDP10_TOOLS_REPO="$repo" \
        "$here/install-cleanup-test.sh"

echo 'pdp10-tools generic regressions: PASS'
