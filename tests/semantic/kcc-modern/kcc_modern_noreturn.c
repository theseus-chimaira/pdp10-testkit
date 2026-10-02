/* kcc_modern_noreturn.c - C11 _Noreturn accepted and ignored. */

volatile int __test_exit;

_Noreturn int
marker(x)
int x;
{
    return x + 4;
}

int
main()
{
    __test_exit = 0;
    return marker(3) == 7 ? 0 : 1;
}
