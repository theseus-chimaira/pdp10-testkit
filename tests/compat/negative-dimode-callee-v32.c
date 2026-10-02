#include "negative-dimode-v32.h"

volatile abi_int71_v32 abi_negative_global_v32;

int
neg_reg_v32(abi_int71_v32 value)
{
    return value == (abi_int71_v32)-3;
}

int
neg_split_v32(int a, int b, int c, abi_int71_v32 value)
{
    return a == 1 && b == 2 && c == 3 &&
           value == (abi_int71_v32)-5;
}

int
neg_stack_v32(int a, int b, int c, int d, abi_int71_v32 value)
{
    return a == 1 && b == 2 && c == 3 && d == 4 &&
           value == (abi_int71_v32)-5;
}

int
neg_global_v32(void)
{
    return abi_negative_global_v32 == (abi_int71_v32)-7;
}

int
neg_tail_v32(abi_int71_v32 value)
{
    return neg_reg_v32(value);
}
