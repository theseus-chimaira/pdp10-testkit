#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
tmp=${TMPDIR:-$HOME/tmp}/p10tk-language-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

(
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -I"$root/support/common/" -R=p10lngv13 \
        "$root/misc/compat/language-narrow.c"
)
"$PDP10_GCC" -I"$root/support/common" -S -O1 -o "$tmp/gcc-language.s" \
    "$root/misc/compat/language-narrow.c"

"$P10RUN" --machine ks10 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run-kcc" \
    --name language-kcc --expect __test_exit=0 \
    "$root/support/crt0.s" "$root/misc/compat/mixed-call-support.s" \
    "$tmp/p10lngv13.s" >/dev/null
"$P10RUN" --machine ks10 --mode deposit --exec-mode step \
    --step-limit 1000000 --timeout 20 --workdir "$tmp/run-gcc" \
    --name language-gcc --expect __test_exit=0 \
    "$root/support/crt0.s" "$root/misc/compat/mixed-call-support.s" \
    "$tmp/gcc-language.s" >/dev/null

if (
    cd "$tmp"
    TERM=dumb "$KCC" -S -v=nostats -x=base -I"$root/support/common/" -R=p10atrv13 \
        "$root/misc/compat/language-attr-reject.c"
) >"$tmp/attr-stdout-v1.log" 2>"$tmp/attr-stderr-v1.log"; then
    attr_status=0
else
    attr_status=$?
fi
if ! python3 "$root/tools/check-kcc-rejection-v1.py" \
    "$attr_status" "$tmp/attr-stdout-v1.log" "$tmp/attr-stderr-v1.log"; then
    echo "KCC did not produce a valid layout-attribute rejection" >&2
    cat "$tmp/attr-stderr-v1.log" >&2
    exit 1
fi

"$PDP10_GCC" -I"$root/support/common" -S -O1 -o "$tmp/gcc-attr.s" \
    "$root/misc/compat/language-attr-reject.c"

echo "language exact-width and attribute policy: PASS"
