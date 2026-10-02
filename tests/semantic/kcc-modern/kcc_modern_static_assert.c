/* kcc_modern_static_assert.c - C11 _Static_assert declarations. */

_Static_assert(1, "file scope works");
_Static_assert(sizeof(int) >= 1, "sizeof is constant");

volatile int __test_exit;

int
main()
{
    __test_exit = 0;
    _Static_assert(1, "block scope works");
    _Static_assert(sizeof(char) == 1);
    return 0;
}
