/* kcc_modern_inline.c - C99 inline accepted and ignored. */

volatile int __test_exit;

static inline int
inc(x)
int x;
{
    return x + 1;
}

__inline int
add2(x)
int x;
{
    return inc(x) + 1;
}

int
main()
{
    __test_exit = 0;
    return add2(5) == 7 ? 0 : 1;
}
