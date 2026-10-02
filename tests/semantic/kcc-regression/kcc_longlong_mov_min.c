/* kcc_longlong_mov_min.c - KCC long long 2-word move/load/store smoke test. */

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

    gb = 1LL;
    ga = gb;
    if (!check_word(&ga, 0, 0, 1))
	return fail_id;
    if (!check_word(&ga, 1, 1, 2))
	return fail_id;

    gb = 2ULL;
    ga = gb;
    if (!check_word(&ga, 0, 0, 3))
	return fail_id;
    if (!check_word(&ga, 1, 2, 4))
	return fail_id;

    gb = ga;
    if (!check_word(&gb, 0, 0, 5))
	return fail_id;
    if (!check_word(&gb, 1, 2, 6))
	return fail_id;

    return fail_id;
}