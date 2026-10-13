#!/bin/sh
set -eu
cd "$(dirname "$0")"

suite=tests/kcc-regression
mode=${1:-fast}
case "$mode" in
fast) skip= ;;
semantic) echo "semantic optimizer regression is in TEST_MATRIX.tsv; use ./run-tests.sh --kind semantic" >&2; exit 2 ;;
all) skip= ;;
*) echo "usage: $0 [fast|semantic|all]" >&2; exit 2 ;;
esac

for test_script in "$suite"/*.sh; do
    base=${test_script##*/}
    case "$base" in kcc-env.sh|$skip) continue ;; esac
    printf '%s\n' "KCC regression: $base"
    sh "$test_script"
done
