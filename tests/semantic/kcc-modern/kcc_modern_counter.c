/* kcc_modern_counter.c - GNU __COUNTER__ macro. */

volatile int __test_exit;

int
main()
{
    int a, b, c;

    __test_exit = 0;
    a = __COUNTER__;
    b = __COUNTER__;
    c = __COUNTER__;
    if (b != a + 1)
        return 1;
    if (c != b + 1)
        return 2;
    return 0;
}
