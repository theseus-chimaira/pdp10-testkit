/* kcc_modern_func_name.c - C99 __func__ string. */

volatile int __test_exit;

static int
same(a, b)
char *a;
char *b;
{
    while (*a && *b)
        {
        if (*a++ != *b++)
            return 0;
        }
    return *a == *b;
}

static int
kcc_func_probe()
{
    return same(__func__, "kcc_func_probe");
}

int
main()
{
    __test_exit = 0;
    return kcc_func_probe() ? 0 : 1;
}
