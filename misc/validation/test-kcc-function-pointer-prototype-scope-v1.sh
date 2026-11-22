#!/bin/sh
set -eu

# Named parameters of nested function-pointer types have prototype scope.
export TMPDIR="${TMPDIR:-$HOME/tmp}"
mkdir -p "$TMPDIR"
PDP10_PREFIX="${PDP10_PREFIX:-$HOME/cross}"
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
work=$(mktemp -d "$TMPDIR/p10tk-fnptr-proto-v1.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

cat >"$work/reduced.c" <<'EOF'
int (*table[])(int named) = { 0 };
int (*single)(int named);
int *factory(int named);
int (*maker(int named))(int other);
int f(int named) { return named; }
EOF

for cpu in pdp6 ka10 ki10 ks10; do
    for source in "$work/reduced.c" \
        "$root/tests/semantic/upstream/extensions/bcp-1.c"; do
        "$PDP10_PREFIX/bin/kcc" -S -v=nostats -x="$cpu" \
            -I"$PDP10_PREFIX/lib/kcc/include" \
            -o "$work/out.s" "$source" >"$work/out.log" 2>&1 || {
            cat "$work/out.log" >&2
            echo "FAIL: function-pointer prototype on $cpu" >&2
            exit 1
        }
        if grep -q 'Internal error' "$work/out.log"; then
            cat "$work/out.log" >&2
            exit 1
        fi
    done
    printf 'PASS: named nested prototype on %s\n' "$cpu"
done
