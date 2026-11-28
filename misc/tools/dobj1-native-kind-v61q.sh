#!/bin/sh
# Cross-compile the actual native reader and run it with word-file test I/O.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
TOOLS=$(CDPATH= cd -- "${DAIMOS_TOOLS_ROOT:-$ROOT/../daimos-tools}" && pwd)
DAIMOS=$(CDPATH= cd -- "${DAIMOS_ROOT:-$ROOT/../DAIMOS}" && pwd)
: "${PDP10_PREFIX:?set PDP10_PREFIX}"
TMPDIR=${TMPDIR:-$HOME/tmp}
export TMPDIR
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/dobj1-native-kind-v61q.XXXXXX")
cleanup() {
    rc=$?
    if [ "$rc" -eq 0 ]; then rm -rf "$work";
    else echo "Native reader failure evidence: $work" >&2; fi
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM
export PATH="$PDP10_PREFIX/bin:$PATH"
for cpu in pdp6 ka10 ki10 ks10; do
    for mode in opt noopt; do
        flag=
        test "$mode" = opt || flag=-n
        tag=$cpu-$mode
        for src in "$TOOLS/native/dobj_native.c" "$ROOT/misc/tools/dobj1-native-kind-v61q.c"; do
            name=${src##*/}; name=${name%.c}
            "$PDP10_PREFIX/bin/kcc" -Pgnu99 -S -v=nostats -x="$cpu" $flag -m=gas \
                -I"$TOOLS/native" -I"$DAIMOS/system/kernel/boot" \
                -I"$DAIMOS/system/kernel/core" -I"$DAIMOS/system/kernel/drivers" \
                -I"$DAIMOS/system/kernel/fs" -I"$DAIMOS/system/kernel/mm" \
                -I"$DAIMOS/system/kernel/modules" -I"$DAIMOS/system/kernel/proc" \
                -I"$DAIMOS/system/kernel/storage" -I"$DAIMOS/userland/libc" \
                -I"$PDP10_PREFIX/include" -o "$work/$tag-$name.s" "$src"
        done
        "$PDP10_PREFIX/bin/p10run" --machine "$cpu" --mode deposit --exec-mode step \
            --step-limit 18000000 --timeout 30 --workdir "$work/$tag" --name "$tag" \
            --expect __test_exit=0 "$ROOT/misc/kcc-regression/semantic-crt0.s" \
            "$work/$tag-dobj_native.s" "$work/$tag-dobj1-native-kind-v61q.s" >/dev/null
        echo "PASS native DOBJ1 kind reader: $tag"
    done
done
