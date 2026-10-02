/* kcc_longlong_shift_min.c - KCC long long << and >> smoke test. */

volatile int __test_exit;
volatile int fail_id;

typedef long long Dint;
typedef unsigned long long UDint;

static Dint ga;
static UDint gua;

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
    UDint ux;

    fail_id = 0;
    __test_exit = 0;

    x = (Dint)68719482085LL;
    ga = x << 1;
    if (!check_word(&ga, 0, 4, 1))
	return fail_id;
    if (!check_word(&ga, 1, 10698, 2))
	return fail_id;

    ga = x >> 1;
    if (!check_word(&ga, 0, 1, 3))
	return fail_id;
    if (!check_word(&ga, 1, 05162, 4))
	return fail_id;

    ux = (UDint)68719482085ULL;
    gua = ux >> 1;
    if (!check_word((Dint *)&gua, 0, 1, 5))
	return fail_id;
    if (!check_word((Dint *)&gua, 1, 05162, 6))
	return fail_id;

    return fail_id;
}