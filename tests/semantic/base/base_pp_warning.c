#warning pdp10-testkit warning probe

volatile int __test_exit;
volatile int fail_id;

int main(void)
{
    fail_id = 0;
    return 0;
}
