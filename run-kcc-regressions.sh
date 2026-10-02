#!/bin/sh
set -eu
cd "$(dirname "$0")"

suite=tests/kcc-regression
mode=${1:-fast}
case "$mode" in
fast) skip=semantic-optimizer-runtime.sh ;;
semantic) exec sh "$suite/semantic-optimizer-runtime.sh" ;;
all) skip= ;;
*) echo "usage: $0 [fast|semantic|all]" >&2; exit 2 ;;
esac

for test_script in "$suite"/*.sh; do
    base=${test_script##*/}
    case "$base" in kcc-env.sh|$skip) continue ;; esac
    printf '%s\n' "KCC regression: $base"
    sh "$test_script"
done
