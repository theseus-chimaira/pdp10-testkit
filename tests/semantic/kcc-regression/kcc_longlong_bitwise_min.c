/* kcc_longlong_bitwise_min.c - KCC long long &, |, ^ smoke test. */

volatile int __test_exit;
volatile int fail_id;

typedef long long Dint;

static Dint ga;

static int
check_word(p, off, expect, id)
Dint *p;
int off;
unsigned expect;
int id;
{
    unsigned *w;

    w = (unsigned *)p;
    if (w[off] != expect)
	{
	fail_id = id;
	return 0;
	}
    return 1;
}

int
main()
{
    Dint x;
    Dint m;

    fail_id = 0;
    __test_exit = 0;

    x = (Dint)68719482085LL;
    m = (Dint)1LL;

    ga = x & m;
    if (!check_word(&ga, 0, 0, 1))
	return fail_id;
    if (!check_word(&ga, 1, 1, 2))
	return fail_id;

    ga = x | m;
    if (!check_word(&ga, 0, 2, 3))
	return fail_id;
    if (!check_word(&ga, 1, 012345, 4))
	return fail_id;

    ga = x ^ m;
    if (!check_word(&ga, 0, 2, 5))
	return fail_id;
    if (!check_word(&ga, 1, 012344, 6))
	return fail_id;

    return fail_id;
}