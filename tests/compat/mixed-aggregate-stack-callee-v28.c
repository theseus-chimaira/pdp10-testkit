#include "mixed-aggregate-stack-v28.h"

int
abi_take_three_v28(int p, struct abi_three_word_v28 v, int q)
{
    return p + v.a + v.b + v.c + q;
}

int
abi_take_four_v28(int p, struct abi_four_word_v28 v, int q)
{
    return p + v.a + v.b + v.c + v.d + q;
}
