#!/bin/sh
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
. "$root/tools/pdp10-env.sh"
pdp10_setup_env
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/p10tk-rh18-negative-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

# The original unmodified upstream source historically failed linking in
# four GCC modes and optimized KCC; the sixth KCC mode is a green control.
"$root/run-tests.sh" --out-dir "$work/index" \
    --source tests/todo/generic/index-1.c \
    --compiler all --family base --cpu pdp6 --opt all \
    --exit-policy strict -j 4
if ! grep -qx 'pass=6' "$work/index/summary.txt"; then
    cat "$work/index/summary.txt" >&2
    exit 1
fi
if ! grep -qx 'fail=0' "$work/index/summary.txt"; then
    cat "$work/index/summary.txt" >&2
    exit 1
fi

# Preserve the strict positive overflow check: wrapping is only permitted
# for negative RH18 displacements, not for arbitrary invalid addresses.
cat > "$work/positive.s" <<'SRC'
.text
.globl start
start:
 move 1,target+0377777
 halt
.data
target:
 .long 0
SRC
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 1000 --timeout 10 \
    --workdir "$work/positive-run" --name rh18-positive-guard-v1 \
    "$work/positive.s"
obj="$work/positive-run/p10run-001-positive.dobj"
if "$PDP10_PREFIX/bin/dlink" -b 0777000 \
        -o "$work/positive.dxr" "$obj" \
        > "$work/positive.log" 2>&1; then
    echo 'FAIL: positive RH18 overflow was accepted' >&2
    exit 1
fi
if ! grep -q 'RH18 relocation overflow' "$work/positive.log"; then
    cat "$work/positive.log" >&2
    exit 1
fi
echo 'PASS: negative RH18 displacement and positive overflow guard'
