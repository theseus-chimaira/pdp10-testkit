#!/bin/sh
# Verify that the imported-C startup preserves success and failure outcomes.
set -eu
: "${PDP10_PREFIX:?PDP10_PREFIX must be set}"
TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"
work=$(mktemp -d "$TMPDIR/pdp10-upstream-crt-v2.XXXXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
here=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
kcc=$PDP10_PREFIX/bin/kcc
p10run=$PDP10_PREFIX/bin/p10run
# A direct invocation must not let p10run select the OS libc.a.
# Stage only the genuine installed KCC freestanding runtime.
compiler_prefix=$(
    P10TK_CRT_RUNTIME_OUT="$work" \
    PYTHONPATH="$here/tools${PYTHONPATH:+:$PYTHONPATH}" \
    python3 -c 'import os
from compiler_stdlib_prefix_v1 import prepare_script_prefix
print(prepare_script_prefix(os.environ["P10TK_CRT_RUNTIME_OUT"],
                            os.environ["PDP10_PREFIX"], "kcc"))'
)

check_case() {
    name=$1
    expected=$2
    body=$3
    printf 'extern void exit(int);\nextern void abort(void);\nint main(void) { %s }\n' "$body" > "$work/$name.c"
    (cd "$work" && "$kcc" -S -v=nostats -x=pdp6 -R="$name" "$name.c")
    if PDP10_PREFIX="$compiler_prefix" "$p10run" --machine pdp6 \
            --mode deposit --exec-mode step --step-limit 1000000 \
            --timeout 20 --workdir "$work/run-$name" --name "$name" \
            --expect __test_exit=0 \
            "$here/support/crt0-upstream-v1.s" "$work/$name.s" \
            "$here/support/exit-v1.s" "$here/support/abort-v1.s" \
            > "$work/$name.log" 2>&1; then
        result=success
    else
        result=failure
    fi
    if [ "$result" != "$expected" ]; then
        cat "$work/$name.log" >&2
        echo "unexpected outcome: $name ($result, expected $expected)" >&2
        exit 1
    fi
    # A linker/setup/simulator failure must never masquerade as a test that
    # correctly rejected abort() or a nonzero termination status.
    if [ "$expected" = failure ] &&
            ! grep -q '^FAIL: __test_exit: got ' "$work/$name.log"; then
        cat "$work/$name.log" >&2
        echo "expected a status assertion failure, not infrastructure failure: $name" >&2
        exit 1
    fi
}

check_case return-zero success 'return 0;'
check_case return-one failure 'return 1;'
check_case exit-zero success 'exit(0);'
check_case exit-one failure 'exit(1);'
check_case abort-test failure 'abort();'
echo 'upstream bare-metal termination contract: PASS'
