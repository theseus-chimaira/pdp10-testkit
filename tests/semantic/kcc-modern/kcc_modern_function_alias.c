/* kcc_modern_function_alias.c - GNU __FUNCTION__ alias. */

volatile int __test_exit;

static int
probe()
{
    return __FUNCTION__[0] == 'p' && __FUNCTION__[1] == 'r';
}

int
main()
{
    __test_exit = 0;
    return probe() ? 0 : 1;
}
