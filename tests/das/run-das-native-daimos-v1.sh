#!/bin/sh
set -eu

fail()
{
    echo "run-das-native-daimos-v1: $*" >&2
    exit 1
}

TEST_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
PDP10_PREFIX=${PDP10_PREFIX:?set PDP10_PREFIX to the source-built tool prefix}
DAIMOS_REPO=${DAIMOS_REPO:?set DAIMOS_REPO to the DAIMOS source tree}
NATIVE_BUILD_DIR=${NATIVE_BUILD_DIR:?set NATIVE_BUILD_DIR to native DAS build output}
TMPDIR=${TMPDIR:?set TMPDIR to a writable temporary directory}

tag=das-native-daimos-v1
work=$TMPDIR/$tag-$$
build=$work/build
user=$work/user
out=$work/simh.out
src=$work/test.s
s6=$work/test.s6rec
mkdir -p "$user"
trap 'rm -rf "$work"' 0 1 2 3 15

cc=$PDP10_PREFIX/bin/pdp10-dec-none-gcc
das=$DAS_ROOT/das
dlink=$PDP10_PREFIX/bin/dlink
simh=$PDP10_PREFIX/bin/pdp6

for tool in "$cc" "$das" "$dlink" "$simh" "$DAS_ROOT/s6text"; do
    [ -x "$tool" ] || fail "missing tool: $tool"
done
for image in das.dxr das1.dxr das2.dxr; do
    [ -f "$NATIVE_BUILD_DIR/$image" ] || fail "missing native image: $image"
done

incs="-I$DAIMOS_REPO/system/kernel/boot -I$DAIMOS_REPO/system/kernel/core -I$DAIMOS_REPO/system/kernel/drivers -I$DAIMOS_REPO/system/kernel/fs -I$DAIMOS_REPO/system/kernel/mm -I$DAIMOS_REPO/system/kernel/modules -I$DAIMOS_REPO/system/kernel/proc -I$DAIMOS_REPO/system/kernel/storage -I$DAIMOS_REPO/userland/libc -I$PDP10_PREFIX/include"

"$cc" -std=c99 -Os $incs -S "$TEST_ROOT/das-native-run-v1.c" -o "$user/init.s"
"$das" -F -C -O "$user/init.dobj" "$user/init.s"
"$das" -F -C -O "$user/crt0.dobj" "$DAIMOS_REPO/userland/libc/crt0.s"
"$das" -F -C -O "$user/syscall.dobj" "$DAIMOS_REPO/userland/libc/syscall.s"
libgcc=$($cc -print-libgcc-file-name)
"$dlink" --daimos-uuo-relax -b 020 -o "$user/init.dxr" -M "$user/init.map" \
    "$user/crt0.dobj" "$user/syscall.dobj" "$user/init.dobj" "$libgcc"

cat > "$src" <<'EOF'
        .TEXT
        .ENTRY START
START:
        MOVEI 1,0
        UUO 040,0(1)
        HALT .
EOF
"$DAS_ROOT/s6text" --encode "$src" "$s6"

PATH="$PDP10_PREFIX/bin:$PATH" make -C "$DAIMOS_REPO/system/boot/pdp6" image \
    BUILD="$build/system/boot/pdp6" PDP10_PREFIX="$PDP10_PREFIX" \
    DAS="$DAS_ROOT/das" DASFLAGS=-F PROC_BOOT_USERS=1 \
    D6FS_LOGSTORE_BLOCKS=010 D6FS_SWAP_TAIL_BLOCKS=010 \
    SYSTEM_INIT_DXR="$user/init.dxr" \
    D6FS_EXTRA_ARGS="-f /SYSTEM/EXEC/DAS:$NATIVE_BUILD_DIR/das.dxr:555:dxr -f /SYSTEM/EXEC/DAS1:$NATIVE_BUILD_DIR/das1.dxr:555:dxr -f /SYSTEM/EXEC/DAS2:$NATIVE_BUILD_DIR/das2.dxr:555:dxr -f /TEMP/TEST.S:$s6:644:binwords" \
    >/dev/null

boot=$build/system/boot/pdp6
set +e
(
    cd "$boot"
    TERM=dumb timeout -k 2s 60s stdbuf -o0 -e0 "$simh" boot.ini
) >"$out" 2>&1
rc=$?
set -e
if [ "$rc" -ne 0 ]; then
    cat "$out" >&2
    fail "simulator failed: $rc"
fi
if ! tr -d '\r' < "$out" | grep -F 'DAS NATIVE PASS' >/dev/null; then
    cat "$out" >&2
    fail "native assembler did not assemble and execute output"
fi
if tr -d '\r' < "$out" | grep -F 'DAS NATIVE FAIL' >/dev/null; then
    cat "$out" >&2
    fail "native assembler target reported failure"
fi

echo 'native DAS invocation/assembly/execution contract passed'
