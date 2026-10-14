#!/bin/sh
# P0 parser recovery regressions: invalid code must be rejected without ICEs.
set -eu
TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/kcc-p0-diagnostics-v1.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
kcc=${KCC_BIN:-${KCC_REPO:-$root/../kcc}/build/kcc}
if [ ! -x "$kcc" ]; then
    echo "KCC executable not found: $kcc" >&2
    exit 1
fi

check_rejected() {
    case_name=$1
    source="$root/tests/negative/upstream-gcc/gcc-dg-noncompile/$case_name.c"
    cp "$source" "$work/$case_name.c"
    (cd "$work" && "$kcc" -S -v=nostats -x=pdp6 "$case_name.c") \
        > "$work/$case_name.log" 2>&1 || :
    if ! grep -q '^? KCC - .*error' "$work/$case_name.log" ||
       grep -q '\[Internal error\]' "$work/$case_name.log"; then
        cat "$work/$case_name.log" >&2
        echo "Incorrect rejection or internal compiler error: $case_name" >&2
        exit 1
    fi
    echo "PASS rejected without ICE: $case_name"
}

for case_name in init-2 init-3 920824-1 voidparam-1; do
    check_rejected "$case_name"
done

cat > "$work/valid-p0-v1.c" <<'EOF'
struct node { struct node *next; };
struct outer { struct inner { int field; } value; };
void plain(void);
void plain(void) { }
EOF
(cd "$work" && "$kcc" -S -v=nostats -x=pdp6 valid-p0-v1.c) \
    > "$work/valid-p0-v1.log" 2>&1 || {
        cat "$work/valid-p0-v1.log" >&2
        exit 1
    }
if grep -q '^? KCC - .*error\|\[Internal error\]' "$work/valid-p0-v1.log"; then
    cat "$work/valid-p0-v1.log" >&2
    exit 1
fi
echo 'PASS valid tag references and unqualified (void) parameters'
