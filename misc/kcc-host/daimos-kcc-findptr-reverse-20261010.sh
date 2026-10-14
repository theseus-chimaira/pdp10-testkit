#!/bin/sh
# Exercise all three production typed KIR lookups and verify stable IDs.
set -eu
: "${KCC_REPO:?}" "${TMPDIR:?}"
work=$(mktemp -d "$TMPDIR/daimos-kcc-findptr-reverse-20261010.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM
cat > "$work/check.c" <<'SOURCE'
#include "cckirwrite.c"
#include <stdio.h>
int main(void)
{
    enum { COUNT = 4096 };
    static TYPE types[COUNT];
    static NODE nodes[COUNT];
    static SYMBOL symbols[COUNT];
    static TYPE *typeptrs[COUNT];
    static NODE *nodeptrs[COUNT];
    static SYMBOL *symptrs[COUNT];
    static TYPE absent_type;
    static NODE absent_node;
    static SYMBOL absent_symbol;
    unsigned i;
    for (i = 0; i < COUNT; ++i) {
        typeptrs[i] = &types[i];
        nodeptrs[i] = &nodes[i];
        symptrs[i] = &symbols[i];
    }
    if (findtype(typeptrs, 0U, typeptrs[0]) != 0U) return 1;
    if (findnode(nodeptrs, 0U, nodeptrs[0]) != 0U) return 2;
    if (findsymbol(symptrs, 0U, symptrs[0]) != 0U) return 3;
    for (i = 0; i < COUNT; ++i) {
        if (findtype(typeptrs, COUNT, typeptrs[i]) != i + 1U) return 4;
        if (findnode(nodeptrs, COUNT, nodeptrs[i]) != i + 1U) return 5;
        if (findsymbol(symptrs, COUNT, symptrs[i]) != i + 1U) return 6;
    }
    if (findtype(typeptrs, COUNT, &absent_type) != 0U) return 7;
    if (findnode(nodeptrs, COUNT, &absent_node) != 0U) return 8;
    if (findsymbol(symptrs, COUNT, &absent_symbol) != 0U) return 9;
    if (findtype(typeptrs, COUNT, NULL) != 0U) return 10;
    if (findnode(nodeptrs, COUNT, NULL) != 0U) return 11;
    if (findsymbol(symptrs, COUNT, NULL) != 0U) return 12;
    puts("PASS: production typed KIR pointer identity and discovery IDs");
    return 0;
}
SOURCE
"${HOST_CC:-cc}" -std=c99 -O2 -ffunction-sections -fdata-sections \
    -I"$KCC_REPO" "$work/check.c" -Wl,--gc-sections -o "$work/check"
"$work/check"
