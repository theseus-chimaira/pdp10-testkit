/* Bare-metal, cross-compiler wrapper for the original regression. */
volatile int __test_exit;
volatile int fail_id;
#include "test.c"
int main(void)
{
    fail_id = pointer_scan_regression();
    return fail_id;
}
