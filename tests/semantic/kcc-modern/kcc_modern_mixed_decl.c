/* kcc_modern_mixed_decl.c - C99 mixed declarations and statements. */

volatile int __test_exit;

int
main()
{
    int a;

    __test_exit = 0;
    a = 1;
    ++a;
    int b = 2;
    b += a;
    int c = b + 3;
    return c == 7 ? 0 : 1;
}
