/* Bare-metal, cross-compiler wrapper for the original regression. */
volatile int __test_exit;
volatile int fail_id;
#include "test.c"
int main(void)
{
    fail_id = kcc_loop_return_test();
    return fail_id;
}
