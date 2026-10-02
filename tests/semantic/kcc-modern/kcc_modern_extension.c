/* kcc_modern_extension.c - GNU __extension__ marker accepted and ignored. */

volatile int __test_exit;

__extension__ int
value()
{
    return __extension__ 6;
}

int
main()
{
    __test_exit = 0;
    return value() == 6 ? 0 : 1;
}
