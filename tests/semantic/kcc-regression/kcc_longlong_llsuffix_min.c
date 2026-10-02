/* kcc_longlong_llsuffix_min.c - KCC LL/ULL integer suffix smoke test. */

volatile int __test_exit;
volatile int fail_id;

int
main()
{
    long long a;
    unsigned long long b;
    long long c;
    unsigned long long d;

    fail_id = 0;
    __test_exit = 0;

    a = 1LL;
    b = 2ULL;
    c = 0x1000000000LL;
    d = 0x100000000ULL;

    return 0;
}