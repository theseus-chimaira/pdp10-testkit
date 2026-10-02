#!/bin/sh
set -eu

TEST_ROOT=${1:?test root}
DAS=${2:?das path}
TMPDIR=${TMPDIR:?set TMPDIR}
BASE=$TMPDIR/das-macro-errors-$$
trap 'rm -f "$BASE".*' 0 1 2 3 15

fail_case()
{
    name=$1
    pattern=$2
    src=$3
    printf '%s\n' "$src" > "$BASE.$name.s"
    if "$DAS" -A -O "$BASE.$name.dxr" "$BASE.$name.s" \
            >"$BASE.$name.out" 2>"$BASE.$name.err"; then
        echo "DAS accepted invalid macro case: $name" >&2
        exit 1
    fi
    if ! grep -qi "$pattern" "$BASE.$name.err"; then
        echo "DAS macro diagnostic mismatch: $name" >&2
        cat "$BASE.$name.err" >&2
        exit 1
    fi
}

fail_case unmatched 'unmatched .endm' '.text
.endm
.word 1'
fail_case unterminated 'unterminated .macro' '.text
.macro X a
.word \a'
fail_case duplicate_param 'duplicate macro parameter' '.text
.macro X a,A
.word 1
.endm
X 1,2'
fail_case too_many_params 'more than 9 parameters' '.text
.macro X a,b,c,d,e,f,g,h,i,j
.word 1
.endm'
fail_case reserved 'macro name conflicts' '.text
.macro MOVE a
.word \a
.endm'
fail_case arg_count 'expects 2 arguments' '.text
.macro X a,b
.word \a
.endm
X 1'
fail_case bad_args 'malformed macro invocation' '.text
.macro X a
.word \a
.endm
X (1'
fail_case empty_arg 'malformed macro invocation' '.text
.macro X a,b
.word \a
.endm
X ,2'
fail_case unknown_param 'unknown macro parameter' '.text
.macro X a
.word \missing
.endm
X 1'
fail_case direct_recursion 'recursive macro invocation' '.text
.macro X a
X \a
.endm
X 1'
fail_case indirect_recursion 'recursive macro invocation' '.text
.macro X a
Y \a
.endm
.macro Y a
X \a
.endm
X 1'
fail_case nested_definition 'nested .macro definitions' '.text
.macro X a
.macro Y b
.word \b
.endm
.endm'
fail_case macro_in_rept 'not allowed inside .rept' '.text
.rept 1
.macro X a
.word \a
.endm
.endr'

cat > "$BASE.deep.s" <<'SRC'
.text
.macro M1
M2
.endm
.macro M2
M3
.endm
.macro M3
M4
.endm
.macro M4
M5
.endm
.macro M5
M6
.endm
.macro M6
M7
.endm
.macro M7
M8
.endm
.macro M8
M9
.endm
.macro M9
.word 1
.endm
M1
SRC
if "$DAS" -A -O "$BASE.deep.dxr" "$BASE.deep.s" \
        >"$BASE.deep.out" 2>"$BASE.deep.err"; then
    echo 'DAS accepted macro invocation deeper than limit' >&2
    exit 1
fi
grep -qi 'nesting too deep' "$BASE.deep.err"

echo 'DAS macro diagnostics and recursion contracts passed'
