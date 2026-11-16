#!/bin/sh
# One isolated source snapshot and build for all registered tool regressions.
# Ownership and removal of WORK belong to run-misc-suites.py.
set -eu
: "${TMPDIR:?set TMPDIR}"
: "${PDP10_TOOLS_REPO:?set PDP10_TOOLS_REPO}"
test "$#" -eq 1 || { echo 'usage: prepare-v2.sh WORK' >&2; exit 2; }
work=$1
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
if ! git -C "$repo" diff --quiet HEAD --; then
    echo 'pdp10-tools source tree has uncommitted changes' >&2
    exit 1
fi
if [ -e "$work/source" ]; then
    echo 'pdp10-tools build directory is already populated' >&2
    exit 1
fi
mkdir -p "$work/source" "$work/tests"

# Install no source-tree artifacts. The archive is always HEAD, not an
# untracked binary, a stale in-tree build or an implicitly different clone.
revision=$(git -C "$repo" rev-parse HEAD)
git -C "$repo" archive --format=tar -o "$work/source-v2.tar" HEAD
tar -xf "$work/source-v2.tar" -C "$work/source"
printf 'pdp10-tools independent source revision: %s\n' "$revision"

${MAKE:-make} -C "$work/source" all

for f in dlink darc p10run pdp10-objdump p10fold p10super csix \
    mkdt mkstream words2pt utf9-file-v1 utf9-s6rec-v1 s6rec-utf9-v1; do
    ln -s "$work/source/$f" "$work/$f"
done
ln -s "$work/source/p10run.c" "$work/p10run.c"

for f in dobj-test.c pdp10-objdump-test.c pdp10-objdump-test.sh \
    p10fold-link-test.c p10fold-link-test.sh \
    p10super-cfg-test.c p10super-cfg-test.sh \
    p10super-rewrite-test.c p10super-rewrite-test.sh \
    p10run-functional-test.sh csix-test.sh media-encoders-test-v1.py; do
    cp "$here/$f" "$work/tests/$f"
done
# UTF-9 oracles live under compat and are invoked by dedicated registry
# cases, but run against the same immutable pdp10-tools snapshot.
root=$(CDPATH= cd -- "$here/../.." && pwd)
for f in test-utf9-file-v1.py test-utf9-s6rec-v1.py \
    test-s6rec-utf9-v1.py; do
    cp "$root/misc/compat/$f" "$work/tests/$f"
done
chmod 755 "$work/tests"/*.sh

${CC:-c99} ${CFLAGS:--O2} -I"$work/source" -o "$work/tests/dobj-test" \
    "$work/tests/dobj-test.c" "$work/source/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$work/source" -o "$work/tests/pdp10-objdump-mk" \
    "$work/tests/pdp10-objdump-test.c" "$work/source/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$work/source" -o "$work/tests/p10super-cfg-mk" \
    "$work/tests/p10super-cfg-test.c" "$work/source/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$work/source" -o "$work/tests/p10super-rewrite-mk" \
    "$work/tests/p10super-rewrite-test.c" "$work/source/dobj.c"
${CC:-c99} ${CFLAGS:--O2} -I"$work/source" -o "$work/tests/p10fold-link-mk" \
    "$work/tests/p10fold-link-test.c" "$work/source/dobj.c"
printf 'pdp10-tools isolated build prepared\n'
