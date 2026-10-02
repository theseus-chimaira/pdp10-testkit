#!/bin/sh
set -eu
TEST_ROOT=${TEST_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}
DAS_ROOT=${DAS_ROOT:?set DAS_ROOT to the DAS source tree}
AS_BIN=${AS_BIN:-$DAS_ROOT/pdp10-dec-none-as}
DAS_BIN=${DAS_BIN:-$DAS_ROOT/das}
DXRCHECK_BIN=${DXRCHECK_BIN:-$DAS_ROOT/dxrcheck}
TMPDIR=${TMPDIR:-/tmp}
STATE=${PDP10_TEST_STATE:-$TMPDIR/pdp10-jfcl-alias-tests.state}
mkdir -p "$STATE"

run_step() {
    name=$1
    shift
    stamp=$STATE/$name.ok
    if [ -f "$stamp" ]; then
        echo "skip $name"
        return 0
    fi
    echo "run $name"
    "$@"
    : > "$stamp"
}

as_alias() {
    out=${AS_ALIAS_OUT:-$TMPDIR/pdp10-as-jfcl-aliases.$$}
    exp=${AS_ALIAS_EXP:-$TMPDIR/pdp10-as-jfcl-aliases.exp.$$}
    got=${AS_ALIAS_GOT:-$TMPDIR/pdp10-as-jfcl-aliases.got.$$}
    trap 'rm -f "$out" "$exp" "$got"' 0 1 2 3 15
    "$AS_BIN" --start 0 -o "$out" "$TEST_ROOT/jfcl-aliases.s"
    grep '^deposit ' "$out" > "$got"
    cat > "$exp" <<'EOF_EXPECTED'
deposit 0 255200000007
deposit 1 255200000007
deposit 2 255100000007
deposit 3 255100000007
deposit 4 255400000007
deposit 5 255400000007
deposit 6 255200000010
deposit 7 263740000000
deposit 10 344040000011
EOF_EXPECTED
    cmp -s "$exp" "$got"
}

das_alias() {
    out=${DAS_ALIAS_OUT:-$TMPDIR/das-dxr-jfcl-alias.$$}
    trap 'rm -f "$out"' 0 1 2 3 15
    "$DAS_BIN" -o "$out" "$TEST_ROOT/dxr-jfcl-alias.s"
    "$TEST_ROOT/dxr-jfcl-alias-check.py" "$out"
    "$DXRCHECK_BIN" -q "$out"
}

run_step as-jfcl-alias as_alias
run_step das-jfcl-alias das_alias

echo "JFCL alias assembler tests passed"
