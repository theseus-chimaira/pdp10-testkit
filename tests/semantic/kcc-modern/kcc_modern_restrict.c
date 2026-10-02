/* kcc_modern_restrict.c - C99 restrict accepted and ignored. */

volatile int __test_exit;

static int
sum_ptrs(a, b, c)
int * restrict a;
int *__restrict b;
int *__restrict__ c;
{
    return *a + *b + *c;
}

int
main()
{
    int a;
    int b;
    int c;

    __test_exit = 0;
    a = 2;
    b = 3;
    c = 4;
    return sum_ptrs(&a, &b, &c) == 9 ? 0 : 1;
}
