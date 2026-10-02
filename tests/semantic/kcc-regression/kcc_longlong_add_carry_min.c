/* kcc_longlong_add_carry_min.c - KCC long long add/sub smoke test. */

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
    Dint y;

    fail_id = 0;
    __test_exit = 0;

    x = (Dint)68719482085LL;
    y = (Dint)1LL;
    ga = x + y;
    if (!check_word(&ga, 0, 2, 1))
	return fail_id;
    if (!check_word(&ga, 1, 012346, 2))
	return fail_id;

    x = (Dint)2251799813690597LL;
    y = (Dint)68719482085LL;
    ga = x - y;
    if (!check_word(&ga, 0, 0177776, 3))
	return fail_id;
    if (!check_word(&ga, 1, 0, 4))
	return fail_id;

    return fail_id;
}