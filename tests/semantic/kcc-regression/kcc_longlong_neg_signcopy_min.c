/* kcc_longlong_neg_signcopy_min.c - KCC long long negation (negdi2) smoke test. */

volatile int __test_exit;
volatile int fail_id;

typedef long long Dint;

static Dint ga;
static Dint gb;

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
    fail_id = 0;
    __test_exit = 0;

    /* negdi_const_one: seto + movni */
    ga = -(Dint)1LL;
    if (!check_word(&ga, 0, 0777777777777, 1))
	return fail_id;
    if (!check_word(&ga, 1, 0777777777777, 2))
	return fail_id;

    gb = (Dint)1LL;
    ga = -gb;
    if (!check_word(&ga, 0, 0777777777777, 3))
	return fail_id;
    if (!check_word(&ga, 1, 0777777777777, 4))
	return fail_id;

    ga = -(Dint)2LL;
    if (!check_word(&ga, 0, 0777777777777, 5))
	return fail_id;
    if (!check_word(&ga, 1, 0777777777776, 6))
	return fail_id;

    /* cast-then-neg form that regressed sign_min under sign-copy neg */
    gb = (Dint)0123;
    ga = -gb;
    if (!check_word(&ga, 0, 0777777777777, 7))
	return fail_id;
    if (!check_word(&ga, 1, 0777777777655, 8))
	return fail_id;

    ga = -((Dint)0123);
    if (!check_word(&ga, 0, 0777777777777, 9))
	return fail_id;
    if (!check_word(&ga, 1, 0777777777655, 10))
	return fail_id;

    return fail_id;
}
