#!/bin/sh
set -eu

: "${TMPDIR:?TMPDIR must be set}"
: "${PDP10_TOOLS_REPO:?PDP10_TOOLS_REPO must be set}"

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$PDP10_TOOLS_REPO" && pwd)
git_root=$(git -C "$repo" rev-parse --show-toplevel) || {
        echo 'pdp10-tools source must be a Git checkout' >&2
        exit 1
}
if [ "$repo" != "$git_root" ]; then
        echo 'PDP10_TOOLS_REPO must be the independent repository root' >&2
        exit 1
fi
work=$TMPDIR/pdp10-tools-regression-$$
trap 'rm -rf "$work"' 0 1 2 3 15
mkdir -p "$work/tests" "$work/source"

# The independent tools Makefile builds directly in its source directory.
# Snapshot the exact committed revision so stale local executables and
# in-tree build products can neither affect the result nor dirty the checkout.
if ! git -C "$repo" diff --quiet HEAD --; then
        echo 'pdp10-tools source tree has uncommitted changes' >&2
        exit 1
fi
revision=$(git -C "$repo" rev-parse HEAD)
git -C "$repo" archive --format=tar -o "$work/source-v1.tar" HEAD
tar -xf "$work/source-v1.tar" -C "$work/source"
source=$work/source
printf 'pdp10-tools independent source revision: %s\n' "$revision"

${MAKE:-make} -C "$source" all

for f in dlink darc p10run pdp10-objdump p10fold p10super csix \
        mkdt mkstream words2pt; do
        ln -s "$source/$f" "$work/$f"
done
ln -s "$source/p10run.c" "$work/p10run.c"

for f in dobj-test.c pdp10-objdump-test.c pdp10-objdump-test.sh \
        p10fold-link-test.c p10fold-link-test.sh \
        p10super-cfg-test.c p10super-cfg-test.sh \
        p10super-rewrite-test.c p10super-rewrite-test.sh \
        p10run-functional-test.sh \
        csix-test.sh media-encoders-test-v1.py; do
        cp "$here/$f" "$work/tests/$f"
done
chmod 755 "$work/tests"/*.sh

${CC:-c99} ${CFLAGS:--O2} -I"$source" -o "$work/tests/dobj-test" \
        "$work/tests/dobj-test.c" "$source/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$source" -o "$work/tests/pdp10-objdump-mk" \
        "$work/tests/pdp10-objdump-test.c" "$source/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$source" -o "$work/tests/p10super-cfg-mk" \
        "$work/tests/p10super-cfg-test.c" "$source/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$source" -o "$work/tests/p10super-rewrite-mk" \
        "$work/tests/p10super-rewrite-test.c" "$source/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$source" -o "$work/tests/p10fold-link-mk" \
        "$work/tests/p10fold-link-test.c" "$source/dobj.c"

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
        TMPDIR="$TMPDIR" CSIX="$work/csix" ./tests/csix-test.sh
        python3 ./tests/media-encoders-test-v1.py \
                "$work/mkdt" "$work/mkstream" "$work/words2pt" \
                "$work/tests/media-fixtures-v1"
)

TMPDIR="$TMPDIR" PDP10_TOOLS_REPO="$source" \
        "$here/install-cleanup-test.sh"

echo 'pdp10-tools generic regressions: PASS'
