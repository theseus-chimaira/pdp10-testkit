#!/bin/sh
set -eu

labels=${1:?usage: check-dxr-block-expr-v1.sh LABELS}

addr()
{
    awk -v name="$1" '$1 == name { print $2; found = 1; exit } END { if (!found) exit 1 }' "$labels"
}

oct=$(addr block_octal)
expr=$(addr block_expression)
end=$(addr block_end)

[ $((0$expr - 0$oct)) -eq 8 ] || exit 1
[ $((0$end - 0$expr)) -eq 8 ] || exit 1
