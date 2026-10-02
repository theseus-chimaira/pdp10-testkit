/* kcc_modern_cxx_comments.c - C99 // comments. */

volatile int __test_exit;

int
main()
{
    int a;

    __test_exit = 0;
    a = 1; // trailing comment must be ignored
    // full-line comment must be ignored
    a = a + 2; // another comment
    return (a == 3) ? 0 : 1;
}
