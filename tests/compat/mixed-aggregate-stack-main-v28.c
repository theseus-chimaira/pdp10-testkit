#include "mixed-aggregate-stack-v28.h"

int
main(void)
{
    struct abi_three_word_v28 three;
    struct abi_four_word_v28 four;

    three.a = 3;
    three.b = 5;
    three.c = 7;
    if (abi_take_three_v28(11, three, 13) != 39)
        return 1;

    four.a = 17;
    four.b = 19;
    four.c = 23;
    four.d = 29;
    if (abi_take_four_v28(31, four, 37) != 156)
        return 2;

    return 0;
}
