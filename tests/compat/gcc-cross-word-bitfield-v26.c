struct cross_word_bits_v26 {
    unsigned int a:20;
    unsigned int b:20;
    unsigned int c:20;
};

int
main(void)
{
    struct cross_word_bits_v26 x;

    x.a = 0x54321U;
    x.b = 0x12345U;
    x.c = 0x23456U;
    if (x.a != 0x54321U)
        return 1;
    if (x.b != 0x12345U)
        return 2;
    if (x.c != 0x23456U)
        return 3;
    return 0;
}
