#!/bin/sh
# Non-XKL2 targets must not use XKL2 extended byte-load/store suboperations.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:?TMPDIR must be set}"

src=$root/tests/validation/gcc/byteptr2/no-xkl2-byte-extend-v40.c
work=$TMPDIR/pdp10-testkit-no-xkl2-byte-extend-v40-$$
trap 'rm -rf "$work"' EXIT HUP INT TERM
mkdir -p "$work"

check_one()
{
        arch=$1
        opt=$2
        tag=$arch-${opt#-}
        asm=$work/$tag.s
        obj=$work/$tag.dobj

        "$PDP10_GCC" -S "$opt" -march="$arch" -o "$asm" "$src"

        case "$arch" in
        xkl2)
                ;;
        *)
                if grep -Eiq 'extend[[:space:]].*\[(i?ldbe|ldbei|ldbi|dpbi)([[:space:]]|[^[:alnum:]_])' "$asm"; then
                        echo "GCC emitted XKL2 byte extension for -march=$arch $opt" >&2
                        grep -Ein 'extend[[:space:]].*\[(i?ldbe|ldbei|ldbi|dpbi)' "$asm" >&2 || true
                        exit 1
                fi
                ;;
        esac

        "$PDP10_AS" -C -O "$obj" "$asm"
}

for arch in base 166 pdp10 ka10 ki10 ks10 kl10 xkl1 xkl2; do
        for opt in -O0 -O1 -O2 -Os; do
                check_one "$arch" "$opt"
        done
done

printf '%s\n' 'GCC non-XKL2 byte-extension regression passed'
