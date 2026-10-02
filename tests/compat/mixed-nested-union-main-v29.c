#include "mixed-nested-union-v29.h"

int
main(void)
{
    union abi_wide_union_v29 u;
    struct abi_nested_v29 n;

    u.words.left = 3;
    u.words.right = 5;
    if (abi_union_words_v29(u, 7) != 15)
        return 1;

    n.head = 11;
    n.pair.left = 13;
    n.pair.right = 17;
    n.value.words.left = 19;
    n.value.words.right = 23;
    n.tail = 29;
    if (abi_nested_sum_v29(31, n, 37) != 180)
        return 2;

    return 0;
}
