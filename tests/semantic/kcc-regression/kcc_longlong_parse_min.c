/* kcc_longlong_parse_min.c - KCC long long type parsing smoke test. */

volatile int __test_exit;
volatile int fail_id;

long long ga;
unsigned long long gb;
long long int gc;
unsigned long long int gd;

static long long identity_ll;
static unsigned long long identity_ull;

int
main()
{
    long long a;
    unsigned long long b;

    fail_id = 0;
    __test_exit = 0;

    a = identity_ll;
    b = identity_ull;

    ga = a;
    gb = b;
    gc = a;
    gd = b;

    return 0;
}