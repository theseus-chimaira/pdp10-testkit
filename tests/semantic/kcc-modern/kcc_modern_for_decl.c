/* kcc_modern_for_decl.c - C99 declaration in for init clause. */

volatile int __test_exit;

int
main()
{
    int sum;

    __test_exit = 0;
    sum = 0;
    for (int i = 0; i < 5; ++i)
        sum += i;
    return sum == 10 ? 0 : 1;
}
