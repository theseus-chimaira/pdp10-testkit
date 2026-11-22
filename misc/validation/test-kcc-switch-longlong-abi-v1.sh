#!/bin/sh
set -eu

# A long long switch has no expression result type at its Q_SWITCH node.
# The ABI direct-peer analysis must not call sizetype(NULL).
if [ -z "${TMPDIR:-}" ]; then
    TMPDIR="$HOME/tmp"
fi
mkdir -p "$TMPDIR"
PDP10_PREFIX="${PDP10_PREFIX:-$HOME/cross}"
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
work=$(mktemp -d "$TMPDIR/p10tk-switch-ll-abi-v1.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
cat >"$work/reduced.c" <<'EOF'
int select_value(long long value)
{
    switch (value) {
    case 3:
    case 10:
    case 23:
        return 0;
    default:
        return 123;
    }
}
EOF

for cpu in pdp6 ka10 ki10 ks10; do
    for source in "$work/reduced.c" \
        "$root/tests/todo/generic/930111-1.c"; do
        "$PDP10_PREFIX/bin/kcc" -S -v=nostats -x="$cpu" \
            -I"$PDP10_PREFIX/lib/kcc/include" \
            -o "$work/out.s" "$source" >"$work/out.log" 2>&1 || {
            cat "$work/out.log" >&2
            echo "FAIL: KCC long long switch on $cpu" >&2
            exit 1
        }
    done
    printf 'PASS: long long switch and original on %s\n' "$cpu"
done
