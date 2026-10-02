/* kcc_modern_digit_separators.c - C23 digit separators in integer constants. */

volatile int __test_exit;

int
main()
{
    int a, b, c, d;

    __test_exit = 0;
    a = 1'000;
    b = 0b1010'0101;
    c = 0x12'34;
    d = 012'34;
    if (a != 1000)
        return 1;
    if (b != 165)
        return 2;
    if (c != 0x1234)
        return 3;
    if (d != 01234)
        return 4;
    return 0;
}
