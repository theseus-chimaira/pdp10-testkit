/* kcc_modern_binary_constants.c - C23/GNU 0b integer constants. */

volatile int __test_exit;

int
main()
{
    int a;
    unsigned b;

    __test_exit = 0;
    a = 0b101010;
    b = 0B111u;
    if (a != 42)
        return 1;
    if (b != 7u)
        return 2;
    return 0;
}
