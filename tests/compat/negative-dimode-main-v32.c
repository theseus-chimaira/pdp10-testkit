#include "negative-dimode-v32.h"

volatile int __test_exit;

int
main(void)
{
    if (!neg_reg_v32((abi_int71_v32)-3))
        return 1;
    if (!neg_split_v32(1, 2, 3, (abi_int71_v32)-5))
        return 2;
    if (!neg_stack_v32(1, 2, 3, 4, (abi_int71_v32)-5))
        return 3;
    abi_negative_global_v32 = (abi_int71_v32)-7;
    if (!neg_global_v32())
        return 4;
    if (!neg_tail_v32((abi_int71_v32)-3))
        return 5;
    return 0;
}
