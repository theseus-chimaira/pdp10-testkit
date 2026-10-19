#!/bin/sh
# Check real PDP-6 C calls into freestanding strstr/strpbrk/strspn.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd -P)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
: "${TMPDIR:=$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-freestanding-search-v1.XXXXXXXX")
if [ "${P10_SEARCH_KEEP_WORK:-0}" != 1 ]; then
    trap 'rm -rf "$work"' EXIT HUP INT TERM
else
    echo "search work retained: $work"
fi
libdir=${P10_SEARCH_LIBDIR:-$PDP10_PREFIX/lib/kcc/freestanding}
for name in strstr strpbrk strspn; do
    test -f "$libdir/kcc-libc-$name-v1.s" || {
        echo "missing freestanding $name assembler source in $libdir" >&2
        exit 1
    }
done

for compiler in kcc gcc; do
    case "$compiler" in
        kcc) profiles='opt noopt' ;;
        gcc) profiles='O0'
             # The extended sweep is an explicit investigation mode until
             # the GCC PDP-6 -O1 ADDRESSOF ICE is fixed and validated.
             if [ "${P10_SEARCH_SWEEP_GCC:-0}" = 1 ]; then
                 profiles='O0 O1 O2 Os'
             fi ;;
    esac
    for profile in $profiles; do
        out="$work/search-$compiler-$profile.s"
        if [ "$compiler" = kcc ]; then
            set --
            if [ "$profile" = noopt ]; then set -- -n; fi
            "$KCC" -S -v=nostats -x=pdp6 "$@" -I"$KCC_LIBDIR/include" \
                -o "$out" "$root/tests/semantic/freestanding-search-v1.c"
        else
            "$PDP10_GCC" -S "-$profile" -fno-builtin -march=pdp6 -o "$out" \
                "$root/tests/semantic/freestanding-search-v1.c"
        fi
        "$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
            --step-limit 8000000 --timeout 25 \
            --workdir "$work/run-$compiler-$profile" \
            --name "search-$compiler-$profile-v1" \
            --expect __test_exit=0 --expect semantic_fail_id=0 \
            --examine search_observed_ptr --examine search_expected_ptr \
            "$root/support/crt0-upstream-v1.s" "$out" \
            "$libdir/kcc-libc-strstr-v1.s" \
            "$libdir/kcc-libc-strpbrk-v1.s" \
            "$libdir/kcc-libc-strspn-v1.s" \
            "$root/support/exit-v1.s" "$root/support/abort-v1.s"
        echo "PASS freestanding search: $compiler $profile PDP-6"
    done
done
