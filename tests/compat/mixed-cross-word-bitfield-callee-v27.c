#include "mixed-cross-word-bitfield-v27.h"

int
cross_word_check_v27(void)
{
    if (cross_word_bits_v27.a != 0x54321U)
        return 1;
    if (cross_word_bits_v27.b != 0x12345U)
        return 2;
    if (cross_word_bits_v27.c != 0x23456U)
        return 3;
    return 0;
}
