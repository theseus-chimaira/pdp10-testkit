/* kcc_modern_static_assert_alias.c - C23 static_assert spelling. */

static_assert(1, "file scope static_assert alias");

volatile int __test_exit;

int
main()
{
    __test_exit = 0;
    static_assert(sizeof(int) >= 1, "block scope static_assert alias");
    static_assert(sizeof(char) == 1);
    return 0;
}
