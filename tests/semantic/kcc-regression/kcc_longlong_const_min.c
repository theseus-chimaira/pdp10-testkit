/* kcc_longlong_const_min.c - KCC long long wide constant smoke test. */

volatile int __test_exit;
volatile int fail_id;

typedef long long Dint;

static Dint ga;
static Dint gb;
/* 2^36 + 012345 in canonical 71-bit DImode: high=2, low=012345. */
static Dint gs = (Dint)68719482085LL;

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

    fail_id = 0;
    __test_exit = 0;

    x = (Dint)68719482085LL;
    ga = x;
    if (!check_word(&ga, 0, 2, 1))
	return fail_id;
    if (!check_word(&ga, 1, 012345, 2))
	return fail_id;

    gb = (Dint)2251799813690597LL;
    if (!check_word(&gb, 0, 0200000, 3))
	return fail_id;
    if (!check_word(&gb, 1, 012345, 4))
	return fail_id;

    ga = gs;
    if (!check_word(&ga, 0, 2, 5))
	return fail_id;
    if (!check_word(&ga, 1, 012345, 6))
	return fail_id;

    return fail_id;
}