/* kcc_modern_pretty_function.c - GNU __PRETTY_FUNCTION__ alias. */

volatile int __test_exit;

static int
sample()
{
    return __PRETTY_FUNCTION__[0] == 's'
        && __PRETTY_FUNCTION__[1] == 'a';
}

int
main()
{
    __test_exit = 0;
    return sample() ? 0 : 1;
}
