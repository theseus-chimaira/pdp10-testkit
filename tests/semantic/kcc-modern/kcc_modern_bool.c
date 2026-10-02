/* kcc_modern_bool.c - C99 _Bool syntax, int-backed in KCC. */

volatile int __test_exit;

int
main()
{
    _Bool b;

    __test_exit = 0;
    b = 0;
    if (b)
        return 1;
    b = 5;
    if (!b)
        return 2;
    return 0;
}
