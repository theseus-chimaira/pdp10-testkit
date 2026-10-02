#include "mixed-cross-word-bitfield-v27.h"

struct cross_word_bits_v27 cross_word_bits_v27;

int
main(void)
{
    cross_word_bits_v27.a = 0x54321U;
    cross_word_bits_v27.b = 0x12345U;
    cross_word_bits_v27.c = 0x23456U;
    return cross_word_check_v27();
}
