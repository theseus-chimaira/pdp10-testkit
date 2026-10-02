/* kcc_modern_c23_attributes.c - C23 [[...]] attributes accepted/ignored. */

[[maybe_unused]] static int c23_value;

volatile int __test_exit;

[[maybe_unused]] static int
c23_func(x)
int x;
{
    return x + 5;
}

int
main()
{
    __test_exit = 0;
    c23_value = c23_func(2);
    return (c23_value == 7) ? 0 : 1;
}
