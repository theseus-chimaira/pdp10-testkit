/* kcc_modern_gnu_attribute.c - GNU __attribute__((...)) accepted/ignored. */

__attribute__((unused)) static int attr_value;

volatile int __test_exit;

__attribute__((noinline)) static int
attr_func(x)
int x;
{
    return x + 4;
}

int
main()
{
    __test_exit = 0;
    attr_value = attr_func(3);
    return (attr_value == 7) ? 0 : 1;
}
