#!/bin/sh
# Multi-translation-unit UTF-9 target check; one source is the library codec.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
tmp=$(mktemp -d "$TMPDIR/utf9-runtime-v1.XXXXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
profile=${P10_UTF9_PROFILE:-0}
if [ "$profile" = 1 ]; then
    : "${P10_UTF9_PROFILE_DIR:=$TMPDIR/utf9-profile-results-v1}"
    mkdir -p "$P10_UTF9_PROFILE_DIR"
fi
codec=${UTF9_CODEC_SOURCE:-"$root/../pdp10-tools/utf9-codec-v1.c"}
if [ ! -f "$codec" ]; then
    echo "UTF-9 codec missing: $codec" >&2
    exit 2
fi
header=$(CDPATH= cd -- "$(dirname "$codec")" && pwd)
codec="$header/$(basename "$codec")"

for compiler in kcc gcc; do
    for version in v1 v2; do
        source="$root/tests/semantic/utf9-codec-pdp6-$version.c"
        case "$compiler" in
            gcc)
                "$PDP10_GCC" -std=c99 -S -O0 -I"$header" \
                    -o "$tmp/codec-gcc.s" "$codec"
                "$PDP10_GCC" -std=c99 -S -O0 -I"$header" \
                    -o "$tmp/test-gcc.s" "$source"
                ;;
            kcc)
                (cd "$tmp" && "$KCC" -S -v=nostats -x=pdp6 \
                    -I"$KCC_LIBDIR/include" -I"$header" \
                    -R=codec-kcc "$codec" && \
                    "$KCC" -S -v=nostats -x=pdp6 \
                    -I"$KCC_LIBDIR/include" -I"$header" \
                    -R=test-kcc "$source")
                ;;
        esac
        if [ "$profile" = 1 ]; then
            set -- --opcode-profile
        else
            set --
        fi
        "$P10RUN" --machine pdp6 --mode deposit --exec-mode step "$@" \
            --step-limit 12000000 --timeout 10 \
            --workdir "$tmp/run-$compiler-$version" \
            --name "utf9-$compiler-$version" --expect __test_exit=0 \
            "$root/support/crt0-upstream-v1.s" \
            "$tmp/codec-$compiler.s" "$tmp/test-$compiler.s" \
            "$root/support/exit-v1.s" "$root/support/abort-v1.s"
        if [ "$profile" = 1 ]; then
            simh_log="$tmp/run-$compiler-$version/utf9-$compiler-$version.out"
            json="$P10_UTF9_PROFILE_DIR/utf9-$compiler-$version.json"
            if [ -n "${P10_PDP6_COST_WEIGHTS:-}" ]; then
                python3 "$root/tools/report-pdp6-opcodes-v1.py" "$simh_log" \
                    --json "$json" --weights "$P10_PDP6_COST_WEIGHTS"
            else
                python3 "$root/tools/report-pdp6-opcodes-v1.py" "$simh_log" \
                    --json "$json"
            fi
        fi
    done
done
echo 'UTF-9 PDP-6 runtime KCC/GCC v1/v2: PASS'
