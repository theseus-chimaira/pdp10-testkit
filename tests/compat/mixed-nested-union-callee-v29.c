#include "mixed-nested-union-v29.h"

int
abi_union_words_v29(union abi_wide_union_v29 u, int extra)
{
    return u.words.left + u.words.right + extra;
}

int
abi_nested_sum_v29(int before, struct abi_nested_v29 n, int after)
{
    return before + n.head + n.pair.left + n.pair.right
        + n.value.words.left + n.value.words.right + n.tail + after;
}
